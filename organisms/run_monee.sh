SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`
BASEDIR=$SCRIPTPATH/..

NUM_CORES=`nproc --all`

base_params="${SCRIPTPATH}/monee.sh --seed 0 --basedir ${BASEDIR} --templatedir ${BASEDIR}/template/ --iterations 1000000"

simulations[0]="${base_params}" #standard run
simulations[1]="${base_params} --useOrganisms true --organismBonusMode 0" # No additional reward
simulations[2]="${base_params} --useOrganisms true --organismBonusMode 1" # Entire group shares reward
simulations[3]="${base_params} --useOrganisms true --organismBonusMode 2" # Individuals in group increased reward


mkdir -p ${BASEDIR}/logs
rm -f ${BASEDIR}/logs/finished.progress
touch ${BASEDIR}/logs/running.progress
parallel --progress --eta --bar --joblog ${BASEDIR}/logs/parallel_job_log_`date "+%Y%m%d.%Hh%Mm%Ss"` -j ${NUM_CORES} ::: "${simulations[@]}" ::: `seq 1`
mv ${BASEDIR}/logs/running.progress ${BASEDIR}/logs/finished.progress