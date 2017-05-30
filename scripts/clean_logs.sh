#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`
BASEDIR=$SCRIPTPATH/..
printf "Running `basename $SCRIPT`"

#basedir=`pwd`/`dirname $0`/..

printf " in basefolder: $BASEDIR\n\n"

printf "Cleaning $BASEDIR/logs\n"
rm -r $BASEDIR/logs/* 2> /dev/null

printf "Cleaning $BASEDIR/logs2\n"
rm $BASEDIR/logs2/* 2> /dev/null
