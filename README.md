# xtools

X-ray analysis scripts for NuSTAR and Swift XRT


## General notes

### Calculating upper limits

Upper limits can be derived first on the count rate of the image using
[XIMAGE](https://heasarc.gsfc.nasa.gov/docs/xanadu/ximage/manual/ximage.html). A region can be specified with

`XIMAGE> read_ima something.img`
`XIMAGE> disp`
`XIMAGE> uplimit/sigma=3` Set the upper limit to 3 sigma.
`XIMAGE> uplimit source.reg`

Then this can be converted to a flux using [WebPIMMS](https://heasarc.gsfc.nasa.gov/cgi-bin/Tools/w3pimms/w3pimms.pl) using the correct
energy range, a spectral index and the correct satellite.
