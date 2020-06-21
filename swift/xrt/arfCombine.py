#!/usr/bin/env python

from astropy.io import fits
import sys
import os
import numpy as np
import glob


targetID=sys.argv[1]
outfile="./results" + targetID + "/arf_" + targetID + ".arf"
print("Creating output file:", outfile)

filelist = glob.glob("out000" + targetID + "*/*pc*arf")
filelist = np.loadtxt(filelist,dtype=str)

expos = []

for f in filelist:
  obsid = f.split("/")[0][3:]

  filename = "out{obsid}/sw{obsid}xpcw3po_cl.evt".format(obsid=obsid)
  hdu_list = fits.open(filename)

  header = hdu_list[0].header
  expos.append(header['EXPOSURE'])

totalExp = np.sum(expos)

wline=""

for e in expos:
 wline += str(e/totalExp) + " "


fline=""

for f in filelist:
  fline += f + " "

cmd="addarf " + "'" + fline[:-1] + "'" + " '" + wline[:-1] + "'" + " " + outfile 
os.system(cmd)
#print(cmd)

