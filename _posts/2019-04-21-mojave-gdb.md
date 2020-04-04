---
layout: post
title: "GDB Installation & <i>Code-sign</i> Steps on macOS X"
date: 2019-04-21 10:47:56
author: Guanzhou Hu
categories: Technical
---

TL; DR: Try not to use GDB on macOS >= 10.14 Mojave directly (app verification scheme on newer macOS gets really complicated). If you really wanna make it, please strictly follow these steps. This procedure is what finally worked or me.
如下是在 Mojave 上 GDB debugger 安装使用踩坑后，最终成功的步骤总结。

### Prerequisites

1. macOS X Mojave (10.14.x).
2. Met problems considering *Codesign* or "*During startup program terminated with signal ...*" / "*unknown load command 0x32*", etc.
3. Do NOT install `gdb` in advance. If you already have it (with `brew` for example), make a clean uninstallation (e.g. `brew uninstall --force gdb`).

### Turn off System Intergrity (Debugging Component)

1. Shut down your Mac. Turn it on again, **hold `cmd + R` when booting up**, until  logo shows up. You should now be booting into *Recovery Mode*.
2. Select a language and enter the Recovery Mode UI. In the Menu, select **"Utilities" → "Terminal" to open a terminal**.
3. **Run the command:**
    ```bash
    csrutil enable --without debug
    ```
    It won't turn off system integrity protection entirely, only the *Debugging Restriction* component is turned off. This should be enough.
4. Reboot normally.

Type:
```bash
csrutil status
```
in your terminal to see if the Debugging Restriction component is "Disabled".

### Create Codesign Certificate

1. Open **Keychain Access** app.
2. **Make sure there aren't any GDB-related certificates**. If you tried some steps before and left some previous (unsuccessful) certificates & keys in *login* / *System* keychain, delete them all, then `cmd + Q` to quit Keychain Access app and reopen for a refresh.
3. In the Menu, select **"Keychain Access"** → **"Certificate Assistant"** → **"Create a certificate..."**.
4. **Name the certificate `gdb-cert`**, set *Identity Type* to be "Self Signed Root" (default), and set *Certificate Type* to be **"Code Signing"**. Check "**Let me override defaults**", then click "Continue" until "Specify a Location For The Certificate" screen.
5. (Though saving the certificate into *System* may succeed sometimes, it would probably trigger "*Unknown Error: -214,...*" error. So here we save it into *login*, then drag into *System*.) Do NOT change this option to "System" as suggested in [^1]. Instead, **leave it as "login"**. Click "Continue" to create the certificate.
6. `cmd + Q` to quit Keychain Access app and reopen for a refresh.
7. You may now find the certificate `gdb-cert` in *login* keychains. **Right-click *System* keychain → "Unlock ..." to unlock it**. (Now the lock icon should be unlocked.) Enter *login* keychain, **drag** the `gdb-cert` certificate (NOT the keys!) into *System* in GUI. The certificate should now be correctly placed in *System* keychain. `cmd + Q` to quit Keychain Access app.
8. Reopen Keychain Access app, **double-click the `gdb-cert` certificate → click out *Trust* section → set *Code Signing* to "Always Trust"**. Save and `cmd + Q` to quit Keychain Access app.

Use:
```bash
security find-certificate -c gdb-cert | grep System.keychain
```
to check whether a correct "System.keychain" exists.

Use
```bash
security find-certificate -p -c gdb-cert | openssl x509 -checkend 0
```
to check that it will not expire.

Check
```bash
security dump-trust-settings -d
```
to see if the trust info of your certificate is set.

### Install GDB 8.0.1

Newer GDB versions are known to have "*During startup program terminated with signal ...*" problems on macOS X. If you have installed them in advance, uninstall them cleanly. GDB 8.0.1, however, has the "*unknown load command 0x32*"" issues on Mojave which has not been patched on homebrew. (see [^3]) So we will need to build it from source, and manually patch the `bfd` component during the procedure.

1. **Get GDB version 8.0.1 (stable) source** from [https://ftp.gnu.org/gnu/gdb/](https://ftp.gnu.org/gnu/gdb/). Unzip it.
2. Modify the source code as guided by this [Stackoverflow post](https://stackoverflow.com/questions/52529838/gdb-8-2-cant-recognized-executable-file-on-macos-mojave-10-14) [^3] (2 locations to modify).
3. Do the normal build procedure:
    ```bash
    ./configure && make && make install
    ```

Check
```bash
gdb --version
```
for your current `gdb` version, and it should be 8.0.1.

See
```bash
which gdb
```
for the actual thing executed when you type `gdb` command in shell.

Use
```bash
file /path/to/your/gdb  # normally /usr/local/bin/gdb
```
to check that it really is an executable, not a shell script or alias or something else.

### Entitle and Codesign Your GDB

1. In some arbitrary user location, create an entitlement file `gdb-entitlement.xml`, whose content is as follows:
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>com.apple.security.cs.debugger</key>
        <true/>
    </dict>
    </plist>
    </pre>
    ```
2. Open terminal at the same location, then do:
    ```bash
    sudo codesign --entitlements gdb-entitlement.xml -fs gdb-cert $(which gdb)
    ```
    (You probably need `sudo` here because your `gdb` is likely to be in a root location, i.e. `/usr/local/bin/`). You have now successfully codesigned your GDB.
3. (Instead of killing `taskgated` process, which may sometimes fail,) The most reliable thing to do now is to reboot your Mac...
4. In `~/.gdbinit` file (create it if you don't have it currently), add a line:
    ```bash
    set startup-with-shell off
    ```
    to avoid starting up GDB with a new shell.

Use
```bash
codesign -vv $(which gdb)
```
to check the *Codesign* result.

Use
```bash
codesign -d --entitlements - $(which gdb)
```
to examine the entitlement information.

**You should now be able to use GDB Debugger as expected!**

#### References

[^1]: GDB Wiki: https://sourceware.org/gdb/wiki/PermissionsDarwin.
[^2]: Stackoverflow: https://stackoverflow.com/questions/49001329/gdb-doesnt-work-on-macos-high-sierra-10-13-3.
[^3]: Stackoverflow: https://stackoverflow.com/questions/52529838/gdb-8-2-cant-recognized-executable-file-on-macos-mojave-10-14.
