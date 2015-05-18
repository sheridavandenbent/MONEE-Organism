#/bin/bash

FULLCOMMAND="$0 $@"
. ${HOME}/lib/shflags

#define the flags
DEFINE_string 'iterations' '1000000' 'Number of iterations' 'i'

# Parse the flags
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

DIR=`readlink -fn $0`
BASEDIR=`dirname $DIR`

bash ${BASEDIR}/counts.sh --iterations ${FLAGS_iterations}
bash ${BASEDIR}/pucks.sh
bash ${BASEDIR}/count-inseminations.sh --iterations ${FLAGS_iterations}

bash ${BASEDIR}/calc_ratios.s --iterations ${FLAGS_iterations}
gnuplot ${BASEDIR}/plot-pucks-ratio
gnuplot ${BASEDIR}/plot-pucks-counts
gnuplot ${BASEDIR}/plot-inseminations

for i in *png
do 
  DEST=`readlink -f $i | sed 's|'${BASEDIR}'/||' | sed -e 's/\//./g'`
  cp $i ${BASEDIR}/summary/${DEST}
done
