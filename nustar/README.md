To combine spectra from both FPMs you need to use [addspec](https://heasarc.gsfc.nasa.gov/docs/nustar/nustar_faq.html).

Need to check first that the cross-calibration between both FPMs is within the 5% systematic uncertainty claimed by NuSTAR.
This is done by fitting separately in XSPEC for each module and checking the normalizations. 
This is mainly done for bright sources where the systematics dominate over statistics.

