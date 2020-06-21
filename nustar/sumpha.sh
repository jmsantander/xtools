#!/bin/bash

#for instance nu90502616001
basename=$1

outfile=${basename}_ALL_sr_grp.pha

ls ${basename}*_sr_grp.pha > filelist.dat
sumpha filelist=filelist.dat clobber=yes outfile=$outfile
