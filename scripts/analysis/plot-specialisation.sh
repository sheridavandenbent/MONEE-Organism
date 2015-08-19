#!/bin/bash

SCRIPT_DIR=$HOME/monee/results/analyse

for i in $@
do
  (
  pushd $i

  gnuplot  -e "set terminal pngcairo enhanced font 'Helvetica,11' size 1024, 1024;set output 'greenratio-histogram.png'" $SCRIPT_DIR/plot-histograms.gpl

  awk '999000 < $1 {print $3,$4}' *.collected | gnuplot -e "set output 'hexbin-puckcounts.png'" ${SCRIPT_DIR}/plot-hexbin-puckcounts.gnuplot  -
  popd
  )&
done
