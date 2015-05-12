#!/bin/bash

#PBS -lnodes=1 -lwalltime=00:09:59

### Set the simulation-specific parameters
#--------------------------------------------------------------------------------------------------#
workdir=${HOME}/monee/
roborobodir=${HOME}/monee/RoboRobo
mytmpdir=monee #Subdirectory used in nodes' scratch space
#--------------------------------------------------------------------------------------------------#

#echo "$(date)"
#echo "Script running on `hostname`"

#echo "Nodes reserved:"
NODES="$(sort $PBS_NODEFILE | uniq)"
#echo "$NODES"

#
# Re-creating tempdir
#
cd $TMPDIR;
rm -rf $mytmpdir
mkdir $mytmpdir

#TODO: only copy necessary files...
#
# Copying roborobo simulator to scratch dir
#
cp -rf ${roborobodir} $mytmpdir/
cd ${mytmpdir}/RoboRobo

BASEDIR=`pwd`
SCRIPTDIR=scripts
TEMPLATEDIR=${BASEDIR}/template/
cd $BASEDIR

#
# How many cores does this node have?
#
module load stopos
ncores=`sara-get-num-cores`

#
# Start simulation for each available core on this node.
#
for ((i=1; i<=ncores; i++)) ; do
(
    # read job parameters from stopos string pool
    stopos next -p monee.pool

    if [ "$STOPOS_RC" != "OK" ]; then # Parameter pool exhausted: we're done
        break
    fi

    ### Run the simulation
    SEED=$RANDOM
    #echo "Running experiment with parameters: --seed ${SEED} --basedir ${BASEDIR}/ --templatedir ${TEMPLATEDIR} ${STOPOS_VALUE}"
    ${BASEDIR}/scripts/monee.sh --seed ${SEED} --basedir ${BASEDIR} --templatedir ${TEMPLATEDIR} ${STOPOS_VALUE}

    stopos remove -p monee.pool
) & # The whole loop contents executed in parallel in the background
done

wait # for the simulations to finish...
