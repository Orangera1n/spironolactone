aopfilenametest=$(ls work/aop*)
bmindex=0
cpid="$1"
if [[ "$aopfilenametest" == *11* && "$cpid" == 0x8030 ]]; then
    bmindex=3
elif [[ "$aopfilenametest" == *12* && "$cpid" == 0x8020 ]]; then
    bmindex=2
else
:
fi
echo "$bmindex"
