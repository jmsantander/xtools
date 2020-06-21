#!/bin/bash

################################
# Name definition
################################

targetID=$1
mode="pc"
results="./products/stage2/$targetID/"
stage1="./products/stage1/"

mkdir -p $results

evtfile="$results/evt_${mode}_${targetID}_sum.evt"
imgfile="$results/img_${mode}_${targetID}_sk.img"
skfile="$results/img_${mode}_${targetID}_sk.ps"
expfile="$results/expmap_${mode}_${targetID}.exp"
phafile="$results/pha_${mode}_${targetID}.pha"
srcreg="regions/src${targetID}.reg"
bkgreg="regions/bkg${targetID}.reg"

#respfile="response/swxwt0to2s6_20131212v015.rmf"
respfile="swxpc0to12s6_20130101v014.rmf"

################################
# Process selection
################################

combineEvents="True"
combineExp="True"
createSkymap="True"
calcCentroid="False"
combineARF="True"
extractSpec="True"
rungrppha="True"

################################
# Combine event lists
################################

if [ $combineEvents = "True" ]; then
rm -f $evtfile

ls -1 $stage1/out000${targetID}*/*$mode*cl.evt > $results/evtlist_$targetID.lis
xselect << EOF
session${targetID}
set datadir ./
read eve "@$results/evtlist_$targetID.lis"
yes
extract eve copyall=yes
save eve $evtfile
yes
extract image
save image $imgfile
exit
EOF
fi


################################
# Skymap creation
################################

if [ $createSkymap = "True" ]; then
ximage > $results/ximage_$targetID.log << EOF
read $imgfile
cpd $skfile/ps
disp 
detect/snr=3
EOF
fi

################################
# Combine exposure maps
################################

if [ $combineExp = "True" ]; then
ls -1 $stage1/out000${targetID}*/*$mode*ex.img > $results/explist_$targetID.lis
rm -f $results/ximage_$targetID.xco
rm -f $results/expmap_$targetID.exp

firstFrame="True"

for i in `cat $results/explist_$targetID.lis`; do
  echo "Adding exposure map $i"
  echo "read_ima $i" >> $results/ximage_$targetID.xco
  if [ $firstFrame = "True" ]; then
    firstFrame="False"
  else
    echo "sum_ima" >>  $results/ximage_$targetID.xco
  fi
  echo "save_ima" >>  $results/ximage_$targetID.xco
done

echo "write_ima/file=\"$expfile\"" >>  $results/ximage_$targetID.xco
echo "exit" >>  $results/ximage_$targetID.xco

ximage < $results/ximage_$targetID.xco
fparkey F $expfile+0 VIGNAPP add=yes
fi

################################
# Centroid
################################

if [ $calcCentroid = "True" ]; then
rm -f $results/centroids_${targetID}.log
xrtcentroid infile=$evtfile outfile=$results/centroids_${targetID}.log \
outdir=./ calcpos=yes interactive=no \
boxra="17 02 09.6328953430" boxdec="26 43 14.694396661" boxradius=0.1
fi

################################
# ARF file
################################

if [ $combineARF = "True" ]; then

rm -f $results/arf_$targetID.arf
./arfCombine.py $targetID

fi

################################
# Extract spectrum
################################

if [ $extractSpec = "True" ]; then

rm -f $results/src_${mode}_${targetID}.pi $results/bkg_${mode}_${targetID}.pi

xselect << EOF
session${targetID}_spec
no
set datadir ./
read eve $evtfile
yes 
filter region $srcreg
extract spectrum
save spectrum $results/src_${mode}_${targetID}.pi
clear region
filter region $bkgreg
extract spectrum
save spectrum $results/bkg_${mode}_${targetID}.pi
EOF

fi


################################
# Run grppha
################################

if [ $rungrppha = "True" ]; then

rm -f $results/comb_${mode}_${targetID}.grp 

grppha << EOF
$results/src_${mode}_${targetID}.pi
$results/comb_${mode}_${targetID}.grp
bad 0-29
group min 5 
chkey backfile $results/bkg_${mode}_${targetID}.pi
chkey ancrfile $results/arf_$targetID.arf 
chkey respfile $respfile 
exit
EOF

fi





