#!/bin/bash

filters=`ls -1 sw*sk* | cut -d_ -f1 | colrm 1 13 | sort | uniq`


for filter in $filters; do
  echo "*** Processing filter: $i ***"
  echo "-> Sky image"
  files=`ls sw*${filter}_sk*`
  nfiles=`ls -1 sw*${filter}_sk* | wc -l`
  declare -a arr=($files)

  bname=`basename ${arr[0]} .fits`
  outfile="${bname}_stack.fits"
 
  cp ${arr[0]} $outfile

  if [ "$nfiles" -gt "1" ]; then
    limit=`expr $nfiles - 1`
    for i in `seq $limit`; do
      echo "Appending ${arr[$i]}"
      fappend ${arr[$i]} $outfile 
    done
  fi

  uvotimsum infile=$outfile outfile=${bname}_stack_summed.fits exclude=NONE clobber=YES
  
  echo "-> Exposure map"

  files=`ls sw*${filter}_ex*`
  nfiles=`ls -1 sw*${filter}_ex* | wc -l`
  declare -a arr=($files)

  bname=`basename ${arr[0]} .fits`
  outfile="${bname}_stack.fits"

  cp ${arr[0]} $outfile

  if [ "$nfiles" -gt "1" ]; then
    limit=`expr $nfiles - 1`
    for i in `seq $limit`; do
      echo "Appending ${arr[$i]}"
      fappend ${arr[$i]} $outfile
    done
  fi
  
  uvotimsum infile=$outfile outfile=${bname}_stack_summed.fits exclude=NONE clobber=YES
  
done
