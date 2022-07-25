---
published: true
title: Flatcar Container Linux - Bare Metal Simple Installation Guide
layout: post
tags: [flatcar, linux, docker, container, coreos, microsoft, netboot.xyz, pxe, ipxe]
categories: [Flatcar]
---

One of the main reasons I wanted to get [netboot.xyz](https://netboot.xyz/) up and running was to simplify installation of various linux machines and more specifically [Flatcar Container Linux](https://flatcar-linux.org/) which have really caught my interest as a minimal, immutable and always up-to-date container host. Kinvolk, the company behind Flatcar, was also aquired by Microsoft recently which piqued my curiousity even more.

I setup this little step-by-step bare metal installation guide and to be able to follow this method you would need to have a spare Linux instance with Docker. I used my [OpenWRT](https://openwrt.org/) router once again but you could use [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install), Raspberry Pi, Live Boot or whatever.

### 1. Create password

Using your existing Linux/Docker instance create a password hash to be used in the config.yaml for Flatcar.

```shell
docker container run --rm --interactive --tty fscm/mkpasswd --method=SHA-512 --rounds=4096 yourpassword
```

[https://www.flatcar.org/docs/latest/provisioning/cl-config/examples/#generating-a-password-hash](https://www.flatcar.org/docs/latest/provisioning/cl-config/examples/#generating-a-password-hash)

### 2. Create config.yaml (Container Linux Config)

I created a directory `/home/daniel/ignition` and this minimal `config.yaml`.

```shell
nano config.yaml
```

In the `password_hash` section paste the hash from [1](#1-create-password). I also added a static IP (additional comment under [6](#6-network-configuration-optional)) and made my user a member of the sudo group. 

```yaml
passwd:
  users:
    - name: daniel
      password_hash: "$6$rounds=4096$this_is_where_you_paste_your_really_long_password_hash"
      groups: ["sudo"]
networkd:
  units:
    - name: enp0s25.network
      contents: |
        [Match]
        Name=enp0s25

        [Network]
        DNS=1.1.1.1
        Address=192.168.100.252/24
        Gateway=192.168.100.1
```

[https://www.flatcar.org/docs/latest/provisioning/cl-config/examples/](https://www.flatcar.org/docs/latest/provisioning/cl-config/examples/)

[https://www.flatcar.org/docs/latest/provisioning/config-transpiler/configuration/](https://www.flatcar.org/docs/latest/provisioning/config-transpiler/configuration/)

### 3. Transpile config.yaml into ignition.json

```shell
cat config.yaml | docker run --rm -i ghcr.io/flatcar-linux/ct:latest > ignition.json
```

[https://flatcar-linux.org/docs/latest/provisioning/config-transpiler/](https://flatcar-linux.org/docs/latest/provisioning/config-transpiler/)

### 4. Setup local webserver

Setup a local webserver to host the ignition.json file and serve this during the Flatcar installation. I decided to share the directory `/home/daniel/ignition` using port 7080 in order to not conflict with an existing webserver.

```shell
docker run --name nginx-ignition -v /home/daniel/ignition:/usr/share/nginx/html:ro -p 7080:80 -d nginx
```

### 5. Local installation

Boot into a live version of Flatcar either via [ISO](https://flatcar-linux.org/docs/latest/installing/bare-metal/booting-with-iso/) or [PXE](http://wikar.se/openwrt/2022/07/12/openwrt-netbootxyz.html).

Using [netboot.xyz](https://netboot.xyz/) you can pass the ignition.json already during first boot but since we're going to do a local installation we can skip this step.

Once booted you will automatically be logged into a shell on the console without prompting for a password.

Now it's time to transfer the ignition.json file locally using the webserver from [4](#4-setup-local-webserver).

```shell
wget http://192.168.1.1:7080/ignition.json
```

If you are unsure of your disk setup you can check this with...

```shell
lsblk
```

And you then perform the installation by running...

```shell
sudo flatcar-install -d /dev/sda -i ignition.json
```

### 6. Network configuration (Optional)

During my first installation I specified the wrong interface name (should have been `Name=enp0s25`) in the config.yaml and I haven't figured out how the automatic naming works so on my second try I ran...

```shell
netstat -i
```

To list all active network devices...

```
Kernel Interface table
Iface             MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
docker0          1500        0      0      0 0             7      0      0      0 BMU
enp0s25          1500    58858      0    420 0         26959      0      0      0 BMRU
lo              65536        0      0      0 0             0      0      0      0 LRU
```

Then I modified config.yaml with the correct interface and transpiled again through step [3](#3-transpile-configyaml-into-ignitionjson) before installing [5](#5-local-installation).

### Done

Now you should be able to ssh into your freshly installed [Flatcar Container Linux](https://flatcar-linux.org/) instance.

Full documentation is found [here](https://flatcar-linux.org/docs/latest).

Good luck!