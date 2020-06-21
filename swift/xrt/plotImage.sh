#!/bin/bash

ifile=$1
base=`basename $ifile .img`
dir=`dirname $ifile`
psfile="$dir/${base}.ps"
echo $psfile 

echo "read $ifile" > temp.xco
echo "cpd $psfile/ps" >> temp.xco
echo "disp" >> temp.xco
echo "detect/snr=3" >> temp.xco

ximage < temp.xco

open $psfile
