#!/bin/bash

#for instance nu90502616001
basename=$1

# basename used 
outfile=${basename}_ALL_sr

ls ${basename}*_sr.pha > phafilelist.dat
addspec infil=phafilelist.dat clobber=yes outfil=$outfile qaddrmf=yes qsubback=yes

grppha infile=$outfile.pha outfile=!$outfile.grp comm="bad 0-35 & bad 1922-4095 & group min 30 & exit"
