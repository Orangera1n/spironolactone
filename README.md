# Spironolactone
This is a tool meant for booting dualboots, ssh ramdisks, and tether downgrades for now. Currently, it only supports generating ssh ramdisks and booting them.

Expansion in functionality (i.e. installing dualboots, jailbreaks, downgrades, etc) willl come at a later date. 

We also have a discord server at https://discord.gg/tXBqy3FRUP for updates and discussion

I will annunce updates over at https://x.com/_orangera1n and on the afformentioned discord

# Important information
1. This tool is in VERY early stages of development, meaning that various functionailites might not be implemented or are otherwise buggy.
2. By using this tool, you will almost certainly wiping the device, back up any data beforehand.
3. Only iOS 12.0-14.4.2 are supported for now due to iBoot patch issues.
Do *not* ask for an ETA for new features or version support
# Prerequsites
1. A computer running macOS (Linux is not implemented yet, but is likely easy to implement, Windows is *very* unlikely to happen)
2. A usbliter8 compatible devices (A12, A13)
- Note that A12X/Z is not implemented due to lack of offsets, and S4/S5 will likely not be implemented due to tooling reasons and lack of demand.
- Note that A14+ is extremely unlikely to come in the future.
3. Common sense
4. An rp2350-based development board, I recommend the Waveshare RP2350A USB Mini

# Usage
0. Get the key json file: Head to https://theapplewiki.com/wiki/Firmware and head to your iOS version page for your device type (iPhone or iPad), then head to the specific device section (i.e. iPhone XR or iPad Air (3rd generation)), and then find your iOS version you want to make a ramdisk of, then click on the "iDeviceX,X" page, then download the keys json.
1. run `https://github.com/Orangera1n/spironolactone.git` and `cd spironolactone`
2. To make a ramdisk, run ./makerd.sh (iOS version here) (location of firmware key json here)
4. To boot a ramdisk, 
# Credits
- [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice) for libirecovery and other tools
- [Nathan](https://github.com/verygenericname) for [sshtars](https://github.com/verygenericname/sshtars/) and [SSHRD_Script](https://github.com/verygenericname/), which is going to be helpful for understanding how this works
- [Paradigm Shift](https://github.com/prdgmshift) for [usbliter8 Explot](https://github.com/prdgmshift/usbliter8) used in the tool
- [tihmstar](https://github.com/tihmstar) for pzb/original iBoot64Patcher, and img4tool
- [xerub](https://github.com/xerub) for img4lib and restored_external in the ramdisk
- [Cryptic](https://github.com/Cryptiiiic) for iBoot64Patcher fork
- [opa334](https://github.com/opa334) for TrollStore
- [OpenAI](https://chat.openai.com/chat) (yes we do apologize, but it's not sploified code) for converting [kerneldiff](https://github.com/mcg29/kerneldiff) into [C](https://github.com/verygenericname/kerneldiff_C)
