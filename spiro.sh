oscheck=$(uname)
option=$1
bootchain=$2
BUILD=Spironolactone-5
BRANCH=$(git branch --show-current)
echo "Welcome to Spironolactone v0.1.0 (Build: "$BUILD-$BRANCH")!"

if [ "$option" = boot ]; then
    if [ -n "$bootchain" ]; then
        sleep 3
        "$oscheck"/usbliter8ctl boot bootchain/"$bootchain"/iBoot.patched.bin
        echo "Loading iBoot!"
        sleep 4
        "$oscheck"/irecovery -f bootchain/"$bootchain"/logo.img4
        "$oscheck"/irecovery -c "setpicture 0x1"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/devicetree.img4
        echo "Loading Devicetree!"
        "$oscheck"/irecovery -c "devicetree"
        if [ -e bootchain/"$bootchain"/.ramdisk ]; then
            "$oscheck"/irecovery -f bootchain/"$bootchain"/ramdisk.img4
            sleep 2
            echo "Loading Ramdisk!"
            irecovery -c ramdisk
        fi
        "$oscheck"/irecovery -f bootchain/"$bootchain"/trustcache.img4
        echo "Loading trustcache!"
        "$oscheck"/irecovery -c "firmware"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/AOP.img4
        echo "Loading AOP!"
        "$oscheck"/irecovery -c "firmware"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/ANE.img4
        echo "Loading ANE!"
        "$oscheck"/irecovery -c "firmware"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/AVE.img4
        echo "Loading AVE!"
        "$oscheck"/irecovery -c "firmware"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/ISP.img4
        echo "Loading ISP!"
        "$oscheck"/irecovery -c "firmware"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/GFX.img4
        echo "Loading GFX!"
        "$oscheck"/irecovery -c "firmware"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/SIO.img4
        echo "Loading SIO!"
        "$oscheck"/irecovery -c "firmware"
        "$oscheck"/irecovery -f bootchain/"$bootchain"/kernelcache.img4
        echo "Loading and Booting Kernel!"
        "$oscheck"/irecovery -c "bootx"
else
        echo 'To boot, you need to provide a "boardconfig-version-build" combination with your "./spiro.sh boot" commnad'
    fi
else
    echo 'To boot, run the script as "./spiro.sh boot boardconfig-version-build"'
fi
