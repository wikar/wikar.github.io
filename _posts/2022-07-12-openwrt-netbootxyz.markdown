---
published: true
title: OpenWRT + netboot.xyz
layout: post
tags: [openwrt, netboot.xyz, pxe, ipxe, efi, bios]
categories: [OpenWRT]
---

There are numerous ways to get [netboot.xyz](https://netboot.xyz/) running as a PXE server together with OpenWRT but this is the simplest (and only) way I got it to work 😊

Inspired by [this forum post](https://forum.openwrt.org/t/dnsmasq-pxe-boot-using-netboot-xyz/56075/4) but I couldn't get it to boot straight from http so instead I did the following.

### 1. Created a tfpt-directory in the root of OpenWRT

```shell
mkdir tftp
```

### 2. Downloaded netboot.xyz.kpxe and netboot.xyz.efi locally

```shell
cd /tftp
curl http://boot.netboot.xyz/ipxe/netboot.xyz.kpxe -o netboot.xyz.kpxe
curl http://boot.netboot.xyz/ipxe/netboot.xyz.efi -o netboot.xyz.efi
```

### 3. Modified /etc/dnsmasq.conf to act as TFTP server

```shell
nano /etc/dnsmasq.conf
```

Add this block to the end of the file.

```bash
####################################
# TFTP Server custom configuration #
####################################
enable-tftp
tftp-root=/tftp
dhcp-boot=netboot.xyz.efi
```

```shell
/etc/init.d/dnsmasq restart
```

(Couldn't get the BIOS/EFI identification to work so I manually switched between netboot.xyz.kpxe and netboot.xyz.efi)

### 4. Finally a crucial but hard to find configuration change for OpenWRT

Disable the LAN interface to announce itself as a `Local IPv6 DNS server` which in turn somehow conflicted with the iPXE DNS lookup (even though booted in IPv4 mode).

Available through the OpenWRT interface. Network -> Interfaces, LAN -> Edit, DHCP Server -> 
IPv6 Settings. Untick this box if ticked.

![local-ipv6-dns-server](https://raw.githubusercontent.com/wikar/wikar.github.io/master/assets/images/2022-07-12-openwrt-netbootxyz/local-ipv6-dns-server.png)

Identified through [this thread](https://github.com/netbootxyz/netboot.xyz/issues/283).

### Done

Good luck!