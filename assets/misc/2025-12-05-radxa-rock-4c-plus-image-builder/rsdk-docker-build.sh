#!/bin/bash
set -e

OUTPUT_DIR="$(pwd)/output"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -p, --product PRODUCT   Product name (required, e.g., rock-4c-plus)
    -s, --suite SUITE       Debian suite (optional, e.g., bookworm)
    -e, --edition EDITION   Edition (optional, e.g., cli, kde)
    -o, --output DIR        Output directory (default: ./output)
    -n, --name NAME         Image name (default: <product>-<suite>-<edition>-<date>.img)
    -l, --list              List available products
    -h, --help              Show this help

Example:
    $0 --product rock-4c-plus
    $0 --product rock-5b --suite bookworm --edition kde
    $0 --product rock-4c-plus --name my-custom-image.img

Note: Both .img and .img.xz files are created automatically
EOF
    exit 1
}

# Parse arguments
PRODUCT=""
SUITE=""
EDITION=""
IMAGE_NAME=""
LIST_PRODUCTS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--product) PRODUCT="$2"; shift 2 ;;
        -s|--suite) SUITE="$2"; shift 2 ;;
        -e|--edition) EDITION="$2"; shift 2 ;;
        -o|--output) OUTPUT_DIR="$2"; shift 2 ;;
        -n|--name) IMAGE_NAME="$2"; shift 2 ;;
        -l|--list) LIST_PRODUCTS=true; shift ;;
        -h|--help) usage ;;
        *) log_error "Unknown option: $1"; usage ;;
    esac
done

# List products
if [ "$LIST_PRODUCTS" = true ]; then
    log_info "Fetching available products..."
    docker run -it --rm debian:bookworm bash -c "
        apt-get update && apt-get install -y git jq >/dev/null 2>&1
        git clone --recurse-submodules https://github.com/RadxaOS-SDK/rsdk.git >/dev/null 2>&1
        cd rsdk && cat src/share/rsdk/configs/products.json | jq '.'
    "
    exit 0
fi

# Validate
[ -z "$PRODUCT" ] && { log_error "Product name is required"; usage; }

mkdir -p "$OUTPUT_DIR"

# Set default image name if not provided
if [ -z "$IMAGE_NAME" ]; then
    DATE=$(date +%Y%m%d)
    IMAGE_NAME="${PRODUCT}"
    [ -n "$SUITE" ] && IMAGE_NAME="${IMAGE_NAME}-${SUITE}"
    [ -n "$EDITION" ] && IMAGE_NAME="${IMAGE_NAME}-${EDITION}"
    IMAGE_NAME="${IMAGE_NAME}-${DATE}.img"
fi

# Build command
RSDK_CMD="rsdk build $PRODUCT"
[ -n "$SUITE" ] && RSDK_CMD="$RSDK_CMD $SUITE"
[ -n "$EDITION" ] && RSDK_CMD="$RSDK_CMD $EDITION"

log_info "Building: $PRODUCT"
log_info "Command: $RSDK_CMD"
log_info "Output image: $IMAGE_NAME"

# Run build in container
docker run -it --rm \
    --privileged \
    -v "$OUTPUT_DIR:/output" \
    -w /workspace \
    debian:bookworm \
    bash -c "
        set -e
        
        echo 'Installing dependencies...'
        apt-get update && apt-get install -y \
            git npm qemu-user-static binfmt-support debootstrap \
            debian-archive-keyring device-tree-compiler systemd-container \
            dosfstools mtools parted kpartx rsync sudo jq jsonnet \
            bdebstrap apt-utils curl wget ca-certificates libguestfs-tools >/dev/null
        
        echo 'Setting up ARM emulation...'
        mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc || true
        update-binfmts --enable
        export PATH=\"/usr/bin:\$PATH\"
        
        echo 'Cloning rsdk...'
        git clone --recurse-submodules https://github.com/RadxaOS-SDK/rsdk.git
        cd rsdk
        
        echo 'Installing devcontainer CLI...'
        npm install @devcontainers/cli >/dev/null
        export PATH=\"\$PWD/src/bin:\$PWD/node_modules/.bin:\$PATH\"
        
        echo 'Running build...'
        $RSDK_CMD
        
        echo 'Copying output...'
        find out -name '*.img' -exec cp -v {} /output/temp_output.img \; 2>/dev/null || true
        
        # Rename to custom name
        if [ -f /output/temp_output.img ]; then
            mv /output/temp_output.img /output/$IMAGE_NAME
            echo \"Image saved as: $IMAGE_NAME\"
        fi
        
        ls -lh /output/
    "

# Always compress
if [ -f "$OUTPUT_DIR/$IMAGE_NAME" ]; then
    log_info "Compressing image..."
    docker run --rm -v "$OUTPUT_DIR:/output" debian:bookworm bash -c "
        apt-get update && apt-get install -y xz-utils >/dev/null 2>&1
        cd /output
        xz -9 -v -k $IMAGE_NAME
    "
    log_info "Created compressed image: ${IMAGE_NAME}.xz"
fi

# Verify output
if ls "$OUTPUT_DIR"/*.img* >/dev/null 2>&1; then
    log_info "Success! Images in: $OUTPUT_DIR"
    ls -lh "$OUTPUT_DIR"
else
    log_error "No images found in output directory"
    exit 1
fi

log_info "Done!"
