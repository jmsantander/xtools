#!/bin/bash

id=$1

mkdir out

#inst=FPMA
inst=ALL

nupipeline \
instrument=${inst} \
indir=./${id} \
outdir=./out \
steminputs=nu${id} \
obsmode=SCIENCE \
exitstage=2
