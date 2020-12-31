#!/bin/bash
# Page on counting in bash: http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-7.html
# Page on counting the number of elements in an array: https://www.cyberciti.biz/faq/finding-bash-shell-array-length-elements/
# Page on value contained in array: https://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value

# This seems to work when I do it this way, for example: 
# SubID="DCNL-RDOC-015"
# /media/jm3080/Naider/RDOC/code/AutoPpc/WORKING_OrganizeScript.sh $SubID

SubID=$1
CDir="/media/jm3080/Naider/RDOC/converted/"
PDir="/media/jm3080/Naider/RDOC/ppc/"
mkdir $PDir$SubID
cd $CDir$SubID
Func=("Resting" "NBack" "StopSignal" "SocStroop")
Struct=("MPRAGE" "t2_structural")
Folders=($(ls))

for func in ${Func[@]}; do
for count in `seq 0 $((${#Folders[@]}-1))`; do
if [[ ${Folders[$count]} == *"$func"* ]]; then
echo Hooray ${Folders[$count]} $func
cp -r ${Folders[$count]} $PDir$SubID/$func
FNum1=$(($count-1))
FNum2=$(($count-2))
cp ${Folders[$FNum1]}/*.nii $PDir$SubID/$func
cp ${Folders[$FNum2]}/*.nii $PDir$SubID/$func
fi
done
done
