#!/bin/bash

#xrtproducts plotdevice=ps clobber=yes expofile=00035030001 pc filters ex.img
#infile=00035030001 pc filters.evt phafile=00035030001 pc.pha regionfile=src.reg
#outdir=./spectrum/ rmffile=CALDB inarffile=CALDB binsize=-99 arffile=00035030001 pc.arf
#lcfile=00035030001 pc.lc attfile=../../00035030001/auxil/sw00035030001pat.fits.gz
#hdfile=../../00035030001/xrt/hk/sw00035030001xhd.hk.gz > products 00035030001 pc.log

obsID=$1
targetID=`echo $obsID | colrm 9 | colrm 1 3`

basename="out$obsID/sw${obsID}"

echo $basename
outdir=./spectrum$obsID/
mkdir $outdir

expfile="${basename}xpcw3po_ex.img"
infile="${basename}xpcw3po_cl.evt"
srcreg="regions/src${targetID}.reg"
phafile="sw${obsID}xpcw3posr.pha"
arffile="sw${obsID}xpcw3posr.arf"
attfile="$obsID/auxil/sw${obsID}pat.fits.gz"
hdfile="$obsID/xrt/hk/sw${obsID}xhd.hk.gz"

echo $expofile
echo $infile
echo $srcreg
echo $phafile
echo $arffile
echo $attfile
echo $hdfile



xrtproducts plotdevice=ps clobber=yes expofile=$expfile infile=$infile phafile=$phafile regionfile=$srcreg \
outdir=$outdir rmffile=CALDB inarffile=CALDB binsize=-99 arffile=$arffile attfile=$attfile \
hdfile=$hdfile #> $logfile

echo $hola
