#/bin/bash

# Run in logs folder, assumes all log files are split into seperate subfolders

for d in `ls -d */ -I summary` 
do
    echo "handeling $d"
    ( cd $d && ../../organisms/analysis/analyse-single.sh )
done
