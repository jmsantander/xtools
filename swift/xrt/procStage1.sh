#!/bin/bash

obsID=$1
outdir="./products/stage1/out$obsID/"

echo "Creating folder $outdir"
mkdir -p $outdir

targetID=`echo $obsID | colrm 9`
targetRA=`grep $targetID srcpos.dat | awk '{print $2}'`
targetDec=`grep $targetID srcpos.dat | awk '{print $3}'`

echo "****** Running xrtpipeline for Target $targetID (RA: $targetRA, Dec: $targetDec) ********" #> $outdir/out$1.log
date #>> $outdir/out$1.log
echo #>> $outdir/out$1.log
echo #>> $outdir/out$1.log

xrtpipeline indir=./data/$1 clobber=yes outdir=$outdir datamode=PC \
steminputs=sw$1 stemoutputs=DEFAULT  plotdevice="ps" \
srcra=$targetRA srcdec=$targetDec createexpomap=yes #>> out$1.log


#gtiexpr="CCDTemp>=-102&&CCDTemp=<-50" >> out$1.log
#srcra=OBJECT srcdec=OBJECT
