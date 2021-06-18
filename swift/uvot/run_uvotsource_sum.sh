#!/bin/bash

obsid=$1
srcregfile="src.reg"
bkgregfile="bkg.reg"

#data/00047168002/uvot/image/sw00047168002uuu_sk.img.gz

for filename in `ls -1 sw*sk_sum_stack_summed.fits`; do
  bname=`basename $filename | cut -d_ -f1`
  filter=`echo $bname | colrm 1 13`

  echo "Filter: ${filter}"
  
  logfile=phot_${filter}_summed.txt
  photfile=phot_${filter}_summed.fits

  #echo "Close ds9 once you're done examining the exposure"
  #/Applications/SAOImageDS9.app/Contents/MacOS/ds9 $filename -regions load "*.reg" -cmap Heat -scale mode 99 -smooth

  #echo "Does it look OK? (y/n)"
  #read check 

  #if [ $check = 'y' ]; then
  #  uvotsource image=${filename} srcreg=$srcregfile bkgreg=$bkgregfile sigma=3 clobber=YES outfile=$photfile chatter=1 > $logfile
  #  cat $logfile
  #fi
  
  uvotsource image=${filename} srcreg=$srcregfile bkgreg=$bkgregfile sigma=3 clobber=YES outfile=$photfile chatter=1 > $logfile
  cat $logfile

done


