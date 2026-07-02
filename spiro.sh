oscheck=$(uname)
option=$1
bootchain=$2
BUILD=Spironolactone-11
BRANCH=$(git branch --show-current)
echo "Welcome to Spironolactone v0.1.2 (Build: "$BUILD-$BRANCH")!"

if [ "$option" = boot ]; then
    if [ -n "$bootchain" ]; then
        sleep 3
        echo "Loading iBoot!"
        "$oscheck"/usbliter8ctl boot bootchain/"$bootchain"/iBoot.patched.bin
        sleep 4
      #  "$oscheck"/irecovery -f bootchain/"$bootchain"/logo.img4
      #  "$oscheck"/irecovery -c "setpicture 0x1"
        echo "Loading Devicetree!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/devicetree.img4
        "$oscheck"/irecovery -c "devicetree"
        if [ -e bootchain/"$bootchain"/.ramdisk ]; then
            echo "Loading Ramdisk!"
            "$oscheck"/irecovery -f bootchain/"$bootchain"/ramdisk.img4
            sleep 2
            irecovery -c ramdisk
        fi
        echo "Loading trustcache!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/trustcache.img4
        "$oscheck"/irecovery -c "firmware"
        echo "Loading AOP!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/AOP.img4
        "$oscheck"/irecovery -c "firmware"
        echo "Loading ANE!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/ANE.img4
        "$oscheck"/irecovery -c "firmware"
        echo "Loading AVE!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/AVE.img4
        "$oscheck"/irecovery -c "firmware"
        echo "Loading ISP!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/ISP.img4
        "$oscheck"/irecovery -c "firmware"
        echo "Loading GFX!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/GFX.img4
        "$oscheck"/irecovery -c "firmware"
        echo "Loading SIO!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/SIO.img4
        "$oscheck"/irecovery -c "firmware"
        echo "Loading and Booting Kernel!"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/kernelcache.img4
        "$oscheck"/irecovery -c "bootx"
else
        echo 'To boot, you need to provide a "boardconfig-version-build" combination with your "./spiro.sh boot" commnad'
    fi
else
    echo 'To boot, run the script as "./spiro.sh boot boardconfig-version-build"'
fi
