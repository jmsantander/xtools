#!/usr/bin/env python

import xspec as xs
import os
import numpy as np
import pylab as pl
from glob import glob

import sys

#xs.AllData += "nu90502616001A01_sr.grp"
#xs.AllData += "nu90502616001B01_sr.grp"

#xs.AllData += "nu90502616001A01_sr_15.grp"
xs.AllData += sys.argv[1] #"results13536/comb_pc_13536.grp"
#xs.AllData += "out00013536002/sw00013536002xpcw3posr.pha"
#xs.AllData += "spectrum00013535001/sw00013535001xpcw3posr.pha"

xs.Plot.setRebin(2, 6)
xs.Plot.xAxis = "keV"
xs.Plot.yLog = True

xs.AllData.ignore("0.0-0.3 10.0-**")
xs.AllData.ignore("bad")

print("Area:", xs.AllData(1).areaScale)

m1 = xs.Model("phabs*powerlaw")
#m1 = xs.Model("powerlaw")

comp1 = m1.phabs
comp2 = m1.powerlaw
# Parameter objects are accessible-by-name as Component object attributes:
par1 = m1.phabs.nH
# ...and we can modify their values:
par1.values = 4.07e-2 #  4.07E+20
par1.frozen = True

par2 = comp2.PhoIndex
par2.values = 2.5
par2.frozen = False

par3 = comp2.norm
par3.values = 1e-2
par3.frozen = False

#xs.AllModels.setEnergies("0.3 10.0 50 log")

# https://heasarc.gsfc.nasa.gov/cgi-bin/Tools/w3nh/w3nh.pl?Entry=1RXS+J223249.5-202232&NR=GRB%2FSIMBAD%2BSesame%2FNED&CoordSys=Equatorial&equinox=2000&radius=0.1&usemap=0

xs.Fit.nIterations = 100000
xs.Fit.statMethod = "cstat"
xs.Fit.statTest = "chi"

xs.Fit.perform()
xs.AllModels.calcFlux("0.3 7. err")


#xs.AllModels.calcFlux("2 20. err")

#xs.Fit.perform()

'''

Emin = 3.5
Emax = 30.
Nbins = 4
logE = np.logspace(np.log10(Emin), np.log10(Emax), Nbins+1)

outfile = open("sed.dat", "w")
outfile.write("#Emin Emax nuFnu nuFnu_lo nuFnu_hi Fphot Fphot_lo Fphot_hi\n")

for i in range(len(logE) - 1):
  lowE = logE[i]
  hiE = logE[i+1]

  strFlux = str(lowE) + " " + str(hiE) + " err"
  xs.AllModels.calcFlux(strFlux)
  flux = list(xs.AllData(1).flux)
  line = "{:.4f} {:.4f} {:.4E} {:.4E} {:.4E} {:.4E} {:.4E} {:.4E}\n".format(lowE, hiE, flux[0], flux[1], flux[2], flux[3], flux[4], flux[5])
  outfile.write(line)
'''

xs.Plot.device = "/xs"
xs.Plot.addCommand("rescale y 1.0e-4 0.05")
#xs.Plot("data","model","resid")
xs.Plot("data","resid")

#xs.Plot("data")
#xs.Plot("eeufspec")
#outfile.close()
