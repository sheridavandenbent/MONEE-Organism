#!/bin/bash

BINSIZE=1000
ITERATIONS=2000000 #`tail -n 1 output.*.log | awk '{print $1}' | sort -n | tail -n 1`

RESULTS=pucks-collected
DIR=`readlink -fn $0`
BASEDIR=`dirname $DIR`

# Generate timestep column 
seq 0 $BINSIZE $ITERATIONS > ${RESULTS}.0
seq 0 $BINSIZE $ITERATIONS > ${RESULTS}.1

#temp file for paste results
PASTE_BUFFER=`mktemp`
PUCK_BUFFER=`mktemp`

# Collect  data
for f in output.*.log.bz2
do
	echo "Processing $f ..."
	bzcat $f | awk '/PuckTaken/{print $2}' | tr -d '(' | tr -d ')' | awk -F';' -v binsize=${BINSIZE} -v iterations=${ITERATIONS} 'BEGIN{for (i=0; i<=(iterations/binsize); i++){pucks[i,0]=0;pucks[i,1]=0}}{pucks[int($1/binsize),$2]+=1}END{for (i=0; i<=(iterations/binsize); i++) { print  1000*i, pucks[i,0], pucks[i,1]}}' | sort -n -k 1 > ${PUCK_BUFFER}
	awk '{print $2}'  ${PUCK_BUFFER} | paste ${RESULTS}.0 - > ${PASTE_BUFFER}
	mv ${PASTE_BUFFER} ${RESULTS}.0
	awk '{print $3}'  ${PUCK_BUFFER} | paste ${RESULTS}.1 - > ${PASTE_BUFFER}
	mv ${PASTE_BUFFER} ${RESULTS}.1
done

echo "Summarising..."

# Summarise puck counts
awk -f ${BASEDIR}/moments-per-line.awk $RESULTS.0 > ${RESULTS}.0.stats
awk -f ${BASEDIR}/moments-per-line.awk $RESULTS.1 > ${RESULTS}.1.stats

# Calculate and summarise puck ratios
# NOTE: assumes 64 runs!
paste ${RESULTS}.0 ${RESULTS}.1 > ${RESULTS}

awk '{printf("%d ", $1); for (i=2; i <= 65; i++){ tot = $i + $(i+65); printf("%f ",  tot==0?0:$i/tot)} print ""}' ${RESULTS} > ${RESULTS}-ratio.0
awk '{printf("%d ", $1); for (i=2; i <= 65; i++){ tot = $i + $(i+65); printf("%f ",  tot==0?0:$(i+65)/tot)} print ""}' ${RESULTS} > ${RESULTS}-ratio.1
awk -f ${BASEDIR}/moments-per-line.awk $RESULTS-ratio.0 > ${RESULTS}-ratio.0.stats
awk -f ${BASEDIR}/moments-per-line.awk $RESULTS-ratio.1 > ${RESULTS}-ratio.1.stats

awk '{printf("%d ", $1); for (i=2; i <= 65; i++){ tot = $i + $(i+65); printf("%f ",  tot)} print ""}' ${RESULTS} > ${RESULTS}.counts
awk -f ${BASEDIR}/moments-per-line.awk ${RESULTS}.counts > ${RESULTS}.counts.stats

echo Done.
