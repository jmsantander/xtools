#!/bin/bash

id=$1

instid=$2

mkdir products

inst=FPM${instid}

echo "Running stage 3 for instrument ${inst}"

nuproducts \
instrument=${inst} \
indir=./out \
outdir=./products \
steminputs=nu${id} \
rungrppha=yes \
srcregionfile=src.reg \
bkgregionfile=bkg.reg \
grpmincounts=30 \
grppibadlow=35 \
grppibadhigh=1909 \
clobber=yes \
binsize=2000 



