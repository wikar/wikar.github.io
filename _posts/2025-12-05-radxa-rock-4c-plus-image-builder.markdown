---
published: true
title: Radxa ROCK 4C+ Image Builder
layout: post
tags: [radxa, linux, sbc, rock-4c-plus, docker, rsdk]
categories: [Linux]
---

I've had various issues (blank screen, no display signal, no blue LED, etc) getting the [Radxa ROCK 4C+](https://radxa.com/products/rock4/4cp/) to work based with the Armbian, DietPi and Radxa standard images for Debian Bookworm. Therefore I created this script to build an image via [rsdk](https://github.com/RadxaOS-SDK/rsdk) from within a Docker container.

Successfully tested with the Radxa ROCK 4C+ but could/should also work with other boards compatible with rsdk.

Download: [rsdk-docker-build.sh](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/misc/2025-12-05-radxa-rock-4c-plus-image-builder/rsdk-docker-build.sh)

## rsdk Docker Build Script

Build RadxaOS images for ARM single-board computers using Docker.

## Requirements

- Docker
- ~10GB free disk space
- sudo access (for binfmt_misc setup)

## Quick Start

```bash
chmod +x rsdk-docker-build.sh

# Build with defaults (creates rock-4c-plus-bookworm-kde-YYYYMMDD.img)
./rsdk-docker-build.sh --product rock-4c-plus

# Specify suite and edition
./rsdk-docker-build.sh --product rock-5b --suite bookworm --edition cli

# Custom image name
./rsdk-docker-build.sh --product rock-4c-plus --name my-custom.img
```

## Output

Both compressed and uncompressed images are created automatically:
- `<name>.img` - Uncompressed image
- `<name>.img.xz` - Compressed image (xz -9)

Default output directory: `./output/`

## Supported Boards

Common products: `rock-4c-plus`, `rock-5b`, `rock-3a`, `zero-3w`

List all available products:
```bash
./rsdk-docker-build.sh --list
```

## Options

- `-p, --product` - Board name (required)
- `-s, --suite` - Debian suite (optional, default from config)
- `-e, --edition` - Edition variant (optional, default from config)
- `-o, --output` - Output directory (default: ./output)
- `-n, --name` - Custom image name (default: product-suite-edition-date.img)
- `-l, --list` - List available products
- `-h, --help` - Show help

## Notes

- First build takes 30-60 minutes
- Uses QEMU for ARM cross-compilation
- Runs entirely in Docker containers
- Requires privileged mode for loop devices