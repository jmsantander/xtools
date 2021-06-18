#!/bin/bash

obsid=$1
datadir="data"
outdir="out"
srcregfile="src.reg"
bkgregfile="bkg4.reg"

#data/00047168002/uvot/image/sw00047168002uuu_sk.img.gz

for filename in `ls -1 $datadir/$obsid/uvot/image/sw*sk.img*`; do
  bname=`basename $filename | cut -d_ -f1`
  dir=`dirname $filename`
  filter=`echo $bname | colrm 1 13`
  
  logfile=$outdir/phot_${obsid}_${filter}.txt
  photfile=$outdir/phot_${obsid}_${filter}.fits

  expfile=$dir/sw${obsid}${filter}_ex.img.gz

  skysum=$outdir/sw${obsid}${filter}_sk_sum.fits
  expsum=$outdir/sw${obsid}${filter}_ex_sum.fits

  echo "Opening $filename - Filter $filter"
  echo "Opening $filename - Filter $filter" > $logfile

  echo "Summing files"
  
  uvotimsum infile=$filename outfile=$skysum clobber=YES >> $logfile
  uvotimsum infile=$expfile outfile=$expsum clobber=YES >> $logfile

  cat $logfile
  
  echo "Close ds9 once you're done examining the exposure"
  /Applications/SAOImageDS9.app/Contents/MacOS/ds9 $skysum -regions load "*.reg" -cmap Heat -scale mode 99 -smooth

  echo "Does it look OK? (y/n)"
  read check 

  if [ $check = 'y' ]; then

    uvotsource image=${skysum} srcreg=$srcregfile bkgreg=$bkgregfile expfile=${expsum} sigma=3 clobber=YES outfile=$photfile chatter=1 >> $logfile
    cat $logfile

  fi

done


