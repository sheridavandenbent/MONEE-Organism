for d in `ls` 
do
    ( cd $d && ../../specialiser/analysis/analyse-single.sh )
done
