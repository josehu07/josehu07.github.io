---
layout: post
title: "Raspberry Pi As Campus GlobalProtect VPN Proxy Server"
date: 2021-12-22 16:16:32
author: Guanzhou Hu
categories: Memo
---

Wisc campus VPN and our CS departmental VPN both use GlobalProtect. On the user side, GlobalProtect clients cannot configure VPN split tunneling, meaning that once connected, all outbound traffic from my host machine goes through the VPN. I have a daily need to access my lab machine sitting behind the departmental VPN, yet I would like all other traffic (e.g., searching Google) to bypass the VPN. I came up with a solution of using one or two Raspberry Pi chips as an always-on SSH proxy server.

## Original VPN Connection Scheme

Originally, I was using the GlobalProtect client directly on my host PC or on my laptop. My lab machine `labmachine.cs.wisc.edu` sits behind the departmental VPN. The VPN connection scheme looked like:

![GlobalProtectVPNProxy0](/assets/img/globalprotect-vpn-proxy-0.png)

Since GlobalProtect clients force all outbound traffic to go through the VPN once connected, I could not let only one terminal SSH session to use VPN while leaving all other connections native. One workaround would be to install a virtual machine on the host, start GlobalProtect client in the virtual machine, and do SSH from there, but that requires careful configuration of guest networking and also seems to be an unnecessarily heavy-weight solution.

## Raspberry Pi As Proxy Server

If you get lucky and have one or two spare Raspberry Pi chips at home, you can follow the steps listed below to setup them up properly as an SSH proxy server. SSH connections are very light-weight, so even RPi Zero chips can do the work nicely.

Let's first assume that the RPi chip is **within the same local network** with the host machine (where I want split tunneling). In this case, one RPi chip should be sufficient. The next section will talk about adding an extra RPi chip and setting up Dynamic DNS (DDNS) to allow accessing the proxy server from anywhere on the Internet.

With one RPi chip, the network connection scheme looks like:

![GlobalProtectVPNProxy1](/assets/img/globalprotect-vpn-proxy-1.png)

Setup steps:

1. Install Raspbian OS on RPi. Connect RPi to home router and test network connection.
2. Start OpenSSH server on RPi.
3. Open router configuration console  (`192.168.0.1` for my TP-Link Archer). Identify the RPi's hardware MAC address.
4. Most home routers do DHCP for its LAN. To give the RPi a permanent LAN IP, find the "Address Reservation" or equivalent setting in router console, add an entry mapping from the RPi's MAC address to a fixed LAN IP of your choice (e.g., `192.168.0.131`).
5. SSH connect to the RPi: `ssh piuser@192.168.0.131`. Setup password-less SSH if desired.
6. Install GlobalProtect command-line Linux client on RPi: [link for WiscVPN](https://kb.wisc.edu/page.php?id=105971).

Start GlobalProtect client on RPi:

```bash
(on-rpi) globalprotect connect --portal compsci.vpn.wisc.edu
```

After the above steps, I can connect to my lab machine from my host PC using the nice *Proxy Jump* feature of SSH:

```bash
ssh -J piuser@192.168.0.131 labuser@labmachine.cs.wisc.edu
```

It is strongly recommended to setup alias targets in `.ssh/config` to save future typing, e.g.:

```text
Host josepi4
  Hostname 192.168.0.131
  User piuser
  Port 22
  IdentityFile ~/.ssh/id_rsa
  ServerAliveInterval 30

Host labmachine
  Hostname labmachine.cs.wisc.edu
  User labuser
  Port 22
  IdentityFile ~/.ssh/id_rsa
  ServerAliveInterval 30

Host labmachine-jl
  Hostname labmachine.cs.wisc.edu
  User labuser
  Port 22
  IdentityFile ~/.ssh/id_rsa
  ServerAliveInterval 30
  ProxyJump josepi4
```

Then, to SSH to the RPi from local network at home:

```bash
ssh josepi4
```

To SSH to the lab machine behind VPN, either will work:

```bash
ssh -J josepi4 labmachine
# or simpler:
ssh labmachine-jl
```

Notice that the GlobalProtect client on RPi might timeout and disconnect after a few minutes of inactivity. It might be possible to write a simple keep-alive script that runs indefinitely on the RPi to keep GlobalProtect connected.

## Using Proxy Server When Not At Home

So far, the RPi proxy server is available to any machine connected to my home router's local network. However, I still want access to the proxy server **from anywhere on the Internet** when I'm not at home.

It is time to introduce two more techniques into the workflow:

- *Port Forwarding* on the router. This feature is named *Virtual Server* on my TP-Link Archer. This enables the router to recognize all inward traffic from the Internet to a specific port number, and relay those traffic to a specific LAN IP.
- *Dynamic DNS* (DDNS) service. This allows me to rent a fixed public domain name and map it to my router's public IP address. It is necessary because my Internet service provider allocates dynamic public addresses for my router, which means the public IP address may change at least once per 14 days. DDNS-aware routers can collaborate with DDNS providers to auto-update the IP address mapped to by that domain name.

Due to strict traffic hijacking of GlobalProtect, the virtual server feature does not work when the previous RPi is on GlobalProtect VPN. Hence, unfortunately, an additional RPi chip needs to be involved. (RPi chips are cheap enough, anyway.)

The final network connection scheme looks like:

![GlobalProtectVPNProxy2](/assets/img/globalprotect-vpn-proxy-2.png)

Setup steps:

1. Set up the second RPi and start OpenSSH server, similarly.
2. Open router configuration console and reserve a fixed LAN IP for the second RPi (e.g., `192.168.0.130`), similarly.
3. SSH connect to the RPi: `ssh piuser@192.168.0.130`. Setup password-less SSH if desired.
4. Go to router console and locate the "Virtual Server" or equivalent setting. Register port forwarding from some external port (e.g., `22122`) to internal port `192.168.0.130:22`. It is recommended to choose a non-default external port to avoid exposing port `22` on public Internet.
5. Check what DDNS providers does your router support. [No-IP](https://www.noip.com/) is a great choice -- it gives you one free domain name per account. Go to the provider, register an available domain name (e.g., `josedns.ddns.net`), and activate it.
6. Go to router console and locate the "Dynamic DNS" or equivalent setting. Enter DDNS provider account and password and enable public IP auto-update feature.

After the above steps, I can connect to the second RPi from anywhere on the public Internet through:

```bash
ssh piuser@josedns.ddns.net:22122
```

To access the first RPi:

```bash
ssh -J piuser@josedns.ddns.net:22122 piuser@192.168.0.131
```

Notice that SSH proxy jumps can be chained, so to access the lab machine behind VPN:

```bash
ssh -J piuser@josedns.ddns.net:22122,piuser@192.168.0.131 labuser@labmachine.cs.wisc.edu
```

Add a few more SSH config entries to save typing, e.g.:

```text
Host josepi0
  Hostname 192.168.0.130
  User piuser
  Port 22
  IdentityFile ~/.ssh/id_rsa
  ServerAliveInterval 30

Host josepi0-jp
  Hostname josedns.ddns.net
  User piuser
  Port 22122
  IdentityFile ~/.ssh/id_rsa
  ServerAliveInterval 30

Host josepi4-jp
  Hostname 192.168.0.131
  User piuser
  Port 22
  IdentityFile ~/.ssh/id_rsa
  ServerAliveInterval 30
  ProxyJump josepi0-jp

Host labmachine-jp
  Hostname labmachine.cs.wisc.edu
  User labuser
  Port 22
  IdentityFile ~/.ssh/id_rsa
  ServerAliveInterval 30
  ProxyJump josepi4-jp
```

Then, to connect to the second RPi when away from home:

```bash
ssh josepi0-jp
```

To access the first RPi:

```bash
ssh josepi4-jp
```

To access the lab machine:

```bash
ssh labmachine-jp
```

Hooray!
