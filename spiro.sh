oscheck=$(uname)
option=$1
bootchain=$2
BUILD=Spironolactone-1
BRANCH=dev
echo "Welcome to Spironolactone v0.0.1 (Build: "$BUILD-$BRANCH")!"

if [ "$option" = boot ]; then
    if [ -n "$bootchain" ]; then
        "$oscheck"/irecovery -f bootchain/"$bootchain"/iBoot.bin
    else
        echo 'To boot, you need to provide a "boardconfig-version-build" combination with your "./spiro.sh boot" commnad'
    fi
else
    echo 'To boot, run the script as "./spiro.sh boot boardconfig-version-build"'
fi
