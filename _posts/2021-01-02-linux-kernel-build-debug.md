---
layout: post
title: "Building a Custom Linux Kernel & Debugging via QEMU + GDB"
date: 2021-01-02 09:10:59
author: Guanzhou Hu
categories: Memo
enable_math: "enable"
---

When doing systems research, we sometimes need to modify/add new stuff into the Linux kernel. This post lists a successful workflow of building and installing a custom Linux kernel under a Ubuntu 18.04/20.04 environment (deb), along with steps to debug the Linux kernel by running it over the QEMU emulator and attaching to GDB.

## System Requirements & Preparations

This workflow has been tested on x86_64 arch, Ubuntu 18.04/20.04 LTS, with Linux kernel versions 4.1 - 5.15.

First, install the required dependencies (common things shipped with Ubuntu are not listed here):

```bash
sudo apt update
sudo apt upgrade
sudo apt install libncurses-dev flex bison openssl libssl-dev \
                 dkms libelf-dev libudev-dev libpci-dev       \
                 libiberty-dev autoconf
sudo apt autoremove
```

Then, get the Linux source of desired version from [one of the official mirror sites](https://mirrors.edge.kernel.org/pub/linux/kernel/) [^1]. Untar and apply the modifications/additions you need to the code.

## Building & Installing a Custom Linux Kernel

This section shows how to compile a custom Linux kernel, and how to install and boot into that kernel under a Ubuntu environment.

### Compiling a Custom Kernel

To compile the custom kernel, produce the config file by:

```bash
cd linux-v.x.y  # The root folder of the Linux source.
sudo make menuconfig
    # Tweak options & save the config to default name;
    # If you are later going to run with QEMU, make sure to
    #   read the paragraphs below.
```

A graphical menu should now pop up in the terminal. Tweak any options you need (e.g., turning off KPTI, KASLR, ...).

If you are later going to run & debug with QEMU, these options must be selected as *built-in*:

- Device drivers $$\rightarrow$$ Network device support $$\rightarrow$$ Virtio network driver `<*>`
- Device drivers $$\rightarrow$$ Block devices $$\rightarrow$$ Virtio block driver `<*>`

> A kernel module's menu option may have three states:
> 1. `< >`: not selected - will not be built
> 2. `<*>`: selected as built-in - will be built within the monolithic kernel
> 3. `<M>`: selected as a kernel module - will be built as a loadable kernel module instead of bulit-in; this is useful when you don't want the feature, e.g. a device driver, to bloat the kernel, but want it to be loadable after booting up whenever needed

If you are later going to play with custom kernel modules, these changes will also be necessary/helpful:

- Binary Emulations $$\rightarrow$$ x32 ABI for 64-bit mode, turn this OFF `[ ]`
- Enable loadable modules support $$\rightarrow$$ Module unloading - Forced module unloading `[*]`

Save the tweaked config to default location `.config` under the source folder.

To build the kernel into an installable deb package, follow these steps:

```bash
sudo make clean
sudo rm -rf debian
rm -f vmlinux-gdb.py

sudo make -j$(nproc) KDEB_PKGVERSION=1.some-suffix deb-pkg
    # 1.some-suffix stands for some custom package version-suffix
```

This will take quite a while to build (~ 20-60 minutes). After successful compilation, you will find several `.deb` packages in the upper level folder, i.e., the folder that contains the Linux source root folder.

> If you are not attempting to build a deb package for installation on bare-metal machine, but just want a `bzImage` of the kernel (to boot in QEMU, etc.), then set the trusted key option to empty through menuconfig:
>
> - Cryptographic API $$\rightarrow$$ Certificates for signature checking $$\rightarrow$$ Provide system-wide ring of trusted keys, change the additional key string in the line below to EMPTY
> 
> then, doing `make -j$(nproc) bzImage` is sufficient.

### Installing the Kernel Image

List the current list of Linux images on the machine:

```bash
dpkg -l | grep linux-image
```

Make sure that there is no image with conflicting version-suffix with the one you are going to install. If you do, first uninstall them by:

```bash
sudo apt purge linux-image-v.x.y-suffix
sudo apt purge linux-image-v.x.y-suffix-dbg
```

Make sure you always have at least one workable kernel available - DO NOT remove all of them before installing the new one, otherwise an unsuccessful installation might become a disaster.

Install the newly compiled kernel package by:

```bash
cd ..
sudo dpkg -i linux-*.deb
```

### Booting into the Newly Installed Kernel

After successful installation, GRUB should have been updated to reflect the new kernel image in its menu. You could list the GRUB menu textually by:

```bash
awk -F\' '$1=="menuentry " || $1=="submenu " {print i++ " : " $2}; /\tmenuentry / {print "\t" i-1">"j++ " : " $2};' /boot/grub/grub.cfg
```

The desired Ubuntu subversion will have an index like `1>3`. Change GRUB config to boot into the entry by default next time:

```bash
sudo vim /etc/default/grub
    # Change the line to e.g. GRUB_DEFAULT="1>3"
    # If you need to add any boot-time command-line parameters,
    #   do so by appending to the variable GRUB_CMDLINE_LINUX.

sudo update-grub
```

Reboot and you should automatically enter the Ubuntu subversion with the custom kernel.

## Debugging Linux Kernel with QEMU + GDB

This section shows how to debug the Linux kernel via running it over QEMU and attaching QEMU to GDB.

Before moving forward, install QEMU & libvirt (and GDB if it does not come along) with:

```bash
sudo apt install qemu qemu-system qemu-kvm libvirt-daemon-system \
                 libvirt-clients bridge-utils
sudo apt install gdb
```

### Compiling the Kernel with Debugging Info

Be sure that the option `CONFIG_GDB_SCRIPTS` is ON and the option `CONFIG_DEBUG_INFO_REDUCED` is OFF when building the kernel. This should be the default case for recent Linux versions.

Assume we want to run the kernel on a QEMU guest with the same emulated microarchitecture, then we don't need cross compilation. The kernel we built in sections above should already be runnable on the QEMU guest. You can find the following files under the Linux source folder:

```bash
linux-v.x.y/arch/x86_64/boot/bzImage    # kernel binary image
linux-v.x.y/vmlinux                     # target for GDB
linux-v.x.y/vmlinux-gdb.py              # pre-defined GDB helpers
```

Add the script file to GDB's auto load path so that you can later use the `lx-*` helper commands. Some descriptions about the commands can be found [here](https://www.kernel.org/doc/html/latest/dev-tools/gdb-kernel-debugging.html) [^2].

```bash
echo "add-auto-load-safe-path path/to/linux-v.x.y/vmlinux-gdb.py" >> ~/.gdbinit
```

### Creating the Root Filesystem

We will need a root filesystem for the kernel to boot on a QEMU guest. The `buildroot` project can help us on this. Details about this project can be found at [https://buildroot.org](https://buildroot.org) [^3].

Clone the buildroot project to the same level with the Linux source folder:

```bash
git clone git://git.buildroot.net/buildroot
```

Then, create an Ext4 root filesystem by:

```bash
cd buildroot
make menuconfig
    # Please see the paragraphs below for required options.
```

The required options you need to set are:

- Target options $$\rightarrow$$ Target architecture, select `x86_64`
- Toolchain $$\rightarrow$$ Enable C++ support `[*]`
- Filesystem images $$\rightarrow$$ ext2/3/4 root filesystem; then choose the `ext4` variant
- Target packages $$\rightarrow$$ Network applications $$\rightarrow$$ openssh `[*]`; this helps us to later send files into the QEMU guest through SSH conveniently

Save the config to its default location `.config`, then do:

```bash
make -j$(nproc)
```

After successful compilation, you will find the root filesystem image at `output/images/rootfs.ext4`.

### Running on QEMU & Attaching GDB

Start QEMU on the compiled kernel with:

```bash
sudo qemu-system-x86_64 \
  -kernel linux-v.x.y/arch/x86_64/boot/bzImage \
  -nographic \
  -drive format=raw,file=buildroot/output/images/rootfs.ext4,if=virtio \
  -append "root=/dev/vda console=ttyS0 nokaslr other-paras-here-if-needed" \
  -m 4G \
  -enable-kvm \
  -cpu host \
  -smp $(nproc) \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::10022-:22 \
  -s -S
```

Please refer to [the QEMU documentation](https://www.qemu.org/docs/master/system/invocation.html) [^4] for what these command options stand for. Notice that the `nokaslr` boot parameter is required, since gdb cannot work well with KASLR turned on.

Specifically, using the `-s -S` combo holds QEMU from booting the kernel until a GDB instance is attached. Hence, in a separate shell window, start GDB and attach to QEMU, then start breaking & debugging the Linux kernel:

```bash
sudo gdb linux-v.x.y/vmlinux

(gdb) target remote :1234   # Attach to QEMU
(gdb) hbreak start_kernel
(gdb) b mm_alloc
(gdb) c
(gdb) lx-dmesg  # Display kernel dmesg log in GDB shell
(gdb) ...
```

Notice that GDB is an interactive debugger, so when we say continue, the QEMU window will continue its execution just like an OS running normally, until it hits the next break point or whatever. The interactive nature of GDB truly makes kernel debugging enjoyable.

To exit out of the QEMU nographics mode, in the QEMU window, type <kbd>ctrl</kbd> + <kbd>a</kbd>, release, then type <kbd>x</kbd>.

### Sending Files to the QEMU Guest

Recall that we selected `CONFIG_VIRTIO_NET` and `CONFIG_VIRTIO_BLK` as built-in when building the kernel and we activated the OpenSSH package when building the rootfs. With the forwarding of host port 10022 to guest port 22 in our QEMU command line arguments, we will be able to ssh and scp from host to guest.

In the QEMU guest, after logging in, check that there is an `eth0` network interface available:

```bash
(in-guest) ifconfig -a
```

Add `eth0` to the list of interfaces and enable this interface by:

```bash
(in-guest) echo "iface eth0 inet dhcp" >> /etc/network/interfaces

(in-guest) ifup eth0
    # You might need this step every time you boot the guest
```

Allow OpenSSH to accept logins as root and empty password:

```bash
(in-guest) vi /etc/ssh/sshd_config
    # Uncomment "PermitRootLogin" and set "yes";
    # Uncomment "PermitEmptyPasswords" and set "yes"

(in-guest) /etc/init.d/S50sshd restart
```

Now, we should be able to ssh into the guest right from host through:

```bash
ssh -p 10022 root@localhost
    # Lowercase `p` for ssh
```

, and send files (the most useful being compiled executables we wanna run on the debugged kernel) to the guest through:

```bash
scp -P 10022 file root@localhost:/root/some/path
    # Notice the uppercase `P` for scp
```

Since our root filesystem is minimal, to send an executable into the guest to run, the executable must be statically linked with `-static` gcc option. Verify it is static by:

```bash
ldd executable_file
    # Should say not a dynamically linked object
```

## References

[^1]: [https://mirrors.edge.kernel.org/pub/linux/kernel](https://mirrors.edge.kernel.org/pub/linux/kernel)
[^2]: [https://www.kernel.org/doc/html/latest/dev-tools/gdb-kernel-debugging.html](https://www.kernel.org/doc/html/latest/dev-tools/gdb-kernel-debugging.html)
[^3]: Buildroot project: [https://buildroot.org](https://buildroot.org)
[^4]: QEMU documentation: [https://www.qemu.org/docs/master/system/index.html](https://www.qemu.org/docs/master/system/index.html)
