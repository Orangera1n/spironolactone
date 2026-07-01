#export ipswurl="$1"
oscheck=$(uname)
BUILD=Spironolactone-10.1
BRANCH=$(git branch --show-current)
echo "Welcome to Spironolactone v0.1.1 (Build: "$BUILD-$BRANCH")!"
#export keypagename="$2"
#export keypage="https://theapplewiki.com/api.php?action=parse&formatversion=2&page="$keypagename"&prop=wikitext&format=json"
#echo $keypage

#curl -A "SpironolactoneKeyFetch" -s -o ./firmwarekeys.json "$keypage"
cpid=$("$oscheck"/irecovery -q | grep CPID | sed 's/CPID: //')
export option1="$1"
export option2="$2"
if [[ "$option1" == http* ]]; then
    ipswurl="$option1"
    echo $ipswurl
    boardconfig=$("$oscheck"/irecovery -q | grep MODEL | sed 's/MODEL: //')
    replace=$("$oscheck"/irecovery -q | grep MODEL | sed 's/MODEL: //')
    deviceid=$("$oscheck"/irecovery -q | grep PRODUCT | sed 's/PRODUCT: //')
elif [[ "$option1" =~ ^[0-9.]+$ ]]; then
    boardconfig=$("$oscheck"/irecovery -q | grep MODEL | sed 's/MODEL: //')
    replace=$("$oscheck"/irecovery -q | grep MODEL | sed 's/MODEL: //')
    deviceid=$("$oscheck"/irecovery -q | grep PRODUCT | sed 's/PRODUCT: //')
    ipswurl=$(curl -sL "https://api.ipsw.me/v4/device/$deviceid?type=ipsw" | "$oscheck"/jq '.firmwares | .[] | select(.version=="'$1'")' | "$oscheck"/jq -s '.[0] | .url' --raw-output)
    buildid=$(curl -sL "https://api.ipsw.me/v4/device/$deviceid?type=ipsw" | "$oscheck"/jq '.firmwares | .[] | select(.version=="'$1'")' | "$oscheck"/jq -s '.[0] | .buildid' --raw-output)
    version=$(curl -sL "https://api.ipsw.me/v4/device/$deviceid?type=ipsw" | "$oscheck"/jq '.firmwares | .[] | select(.version=="'$1'")' | "$oscheck"/jq -s '.[0] | .version' --raw-output)

    echo $ipswurl
else
    echo "Please specify a version or an IPSW URL! (not supported yet)"
fi
fwkeyjson=$option2
rm -rf work
mkdir work
cd work
../"$oscheck"/pzb -g BuildManifest.plist "$ipswurl"
if [ "$oscheck" = 'Darwin' ]; then
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".0."Manifest"."AOP"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
else
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:AOP:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
fi
aopfilenametest=$(ls aop*)
bmindex=0
if [[ "$aopfilenametest" == *11* && "$cpid" == "0x8030" ]]; then
    bmindex=3
elif [[ "$aopfilenametest" == *12* && "$cpid" == "0x8020" ]]; then
    bmindex=2
else
:
fi
#echo "$bmindex"
if [[ "$boardconfig" == n104ap ]]; then
    ../"$oscheck"/pzb -g Firmware/dfu/iBEC.n104.RELEASE.im4p "$ipswurl"
else
    ../"$oscheck"/pzb -g "$(awk "/""${replace}""/{x=1}x&&/iBEC[.]/{print;exit}" BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1)" "$ipswurl"
fi
../"$oscheck"/pzb -g "$(awk "/""${replace}""/{x=1}x&&/DeviceTree[.]/{print;exit}" BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1)" "$ipswurl"
if [ "$oscheck" = 'Darwin' ]; then
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."AOP"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."ANE"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."AVE"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."GFX"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."ISP"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."SIO"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
    ../"$oscheck"/pzb -g "$(/usr/bin/plutil -extract "BuildIdentities".0."Manifest"."RestoreRamDisk"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" "$ipswurl"
    ../"$oscheck"/pzb -g Firmware/"$(/usr/bin/plutil -extract "BuildIdentities".0."Manifest"."RestoreRamDisk"."Info"."Path" xml1 -o - BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)".trustcache "$ipswurl"
else
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:AOP:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:ANE:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:AVE:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:GFX:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:ISP:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:SIO:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
    ../"$oscheck"/pzb -g "$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:RestoreRamDisk:Info:Path" | sed 's/^"//; s/"$//')" "$ipswurl"
    ../"$oscheck"/pzb -g Firmware/"$(../Linux/PlistBuddy BuildManifest.plist -c "Print BuildIdentities:0:Manifest:RestoreRamDisk:Info:Path" | sed 's/^"//; s/"$//')".trustcache "$ipswurl"
fi
../"$oscheck"/pzb -g "$(awk "/""${replace}""/{x=1}x&&/kernelcache.release/{print;exit}" BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1)" "$ipswurl"
cd ..
iv=$(cat $fwkeyjson |  "$oscheck"/jq -r 'first(.. | objects | select(has("iv")) | .iv)' | tr -d '"[]\n')
key=$(cat $fwkeyjson | "$oscheck"/jq -r 'first(.. | objects | select(has("key")) | .key)' | tr -d '"[]\n')
iv=${iv:2}
key=${key:2}
ivkey=$iv$key
if [[ "$boardconfig" == n104ap ]]; then
    "$oscheck"/img4 -i work/iBEC.n104.RELEASE.im4p -o work/iBoot.bin -k "$ivkey"
else
    "$oscheck"/img4 -i work/"$(awk "/""${replace}""/{x=1}x&&/iBEC[.]/{print;exit}" work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | sed 's/Firmware[/]dfu[/]//')" -o work/iBoot.bin  -k "$ivkey"
fi
"$oscheck"/iBoot64Patcher_cryptic work/iBoot.bin work/iBoot.prepatched
"$oscheck"/kairos work/iBoot.prepatched work/iBoot.patched -b "-v debug=0x2014e rd=md0 wdt=-1"

if [ "$oscheck" = 'Darwin' ]; then
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".0."Manifest"."RestoreRamDisk"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)" -o work/ramdisk.dmg
    hdiutil resize -size 210MB work/ramdisk.dmg
    hdiutil attach -mountpoint /tmp/SpironolactoneRD work/ramdisk.dmg -owners off
    "$oscheck"/gtar -x --no-overwrite-dir -f resources/ssh.tar.gz -C /tmp/SpironolactoneRD/
    hdiutil detach -force /tmp/SpironolactoneRD
    hdiutil resize -sectors min work/ramdisk.dmg
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".0."Manifest"."RestoreRamDisk"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1)".trustcache -o work/trustcache.bin
else
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:RestoreRamDisk:Info:Path" | sed 's/^"//; s/"$//')" -o work/ramdisk.dmg
    "$oscheck"/hfsplus work/ramdisk.dmg grow 210000000 > /dev/null
    "$oscheck"/hfsplus work/ramdisk.dmg untar resources/ssh.tar > /dev/null
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:RestoreRamDisk:Info:Path" | sed 's/^"//; s/"$//')".trustcache -o work/trustcache.bin
fi
mkdir work/sshtar
$oscheck/gtar -x --no-overwrite-dir -f resources/ssh.tar.gz -C work/sshtar
$oscheck/trustcache append work/trustcache.bin $(cat resources/sshtarlist.txt)
filedir="$boardconfig-$version-$buildid"
mkdir -p bootchain/$boardconfig-$version-$buildid
$oscheck/img4 -i work/DeviceTree.$boardconfig.im4p -o bootchain/$filedir/devicetree.img4 -T rdtr -M resources/IM4M_$cpid
$oscheck/img4 -i work/trustcache.bin -o bootchain/$filedir/trustcache.img4 -A -T rtsc -M resources/IM4M_$cpid
$oscheck/img4 -i work/ramdisk.dmg -o bootchain/$filedir/ramdisk.img4 -A -T rdsk -M resources/IM4M_$cpid
$oscheck/img4 -i work/"$(awk "/""${replace}""/{x=1}x&&/kernelcache.release/{print;exit}" work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1)" bootchain/$filedir/kernelcache.img4 -T rkrn -M resources/IM4M_$cpid
if [ "$oscheck" = 'Darwin' ]; then
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."AOP"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1 |  cut -d'/' -f3-)" -o bootchain/$filedir/AOP.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."ANE"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1 |  cut -d'/' -f3-)" -o bootchain/$filedir/ANE.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."AVE"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1 |  cut -d'/' -f3-)" -o bootchain/$filedir/AVE.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."ISP"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1 |  cut -d'/' -f3-)" -o bootchain/$filedir/ISP.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."GFX"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1 |  cut -d'/' -f3-)" -o bootchain/$filedir/GFX.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(/usr/bin/plutil -extract "BuildIdentities".$bmindex."Manifest"."SIO"."Info"."Path" xml1 -o - work/BuildManifest.plist | grep '<string>' |cut -d\> -f2 |cut -d\< -f1 | head -1 |  cut -d'/' -f2-)" -o bootchain/$filedir/SIO.img4 -M resources/IM4M_$cpid
else
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:AOP:Info:Path" | sed -E 's#^.*Firmware/##; s#^.*AOP/##; s/^"//; s/"$//')" -o bootchain/$filedir/AOP.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:ANE:Info:Path" | sed -E 's#^.*Firmware/##; s#^.*ane/##; s/^"//; s/"$//')" -o bootchain/$filedir/ANE.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:AVE:Info:Path" | sed -E 's#^.*Firmware/##; s#^.*ave/##; s/^"//; s/"$//')" -o bootchain/$filedir/AVE.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:ISP:Info:Path" | sed -E 's#^.*Firmware/##; s#^.*isp_bni/##; s/^"//; s/"$//')" -o bootchain/$filedir/ISP.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:GFX:Info:Path" | sed -E 's#^.*Firmware/##; s#^.*agx/##; s/^"//; s/"$//')" -o bootchain/$filedir/GFX.img4 -M resources/IM4M_$cpid
    "$oscheck"/img4 -i work/"$(Linux/PlistBuddy work/BuildManifest.plist -c "Print BuildIdentities:0:Manifest:SIO:Info:Path" | sed -E 's#^.*Firmware/##; s/^"//; s/"$//')" -o bootchain/$filedir/SIO.img4 -M resources/IM4M_$cpid
fi
touch bootchain/$filedir/.ramdisk


cp work/iBoot.patched bootchain/$filedir/iBoot.patched.bin

echo 'To boot, run ./spiro.sh boot '"$filedir"
