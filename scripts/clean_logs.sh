#!/bin/bash
printf "Running `basename $0`"

basedir=`pwd`/`dirname $0`/..
printf " in basefolder: $basedir\n\n"

printf "Cleaning $basedir/logs\n"
rm $basedir/logs/* 2> /dev/null

printf "Cleaning $basedir/logs2\n\n"
rm $basedir/logs2/* 2> /dev/null
