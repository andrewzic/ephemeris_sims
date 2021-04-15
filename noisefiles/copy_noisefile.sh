#!/usr/bin/bash

for psr in `cat /DATA/CETUS_3/zic006/ssb/ptasim/psr_set_gb.dat`;
do echo $psr;
   cp noise_template.txt ${psr}_noise.json;
   sed -i 's/PSR/'${psr}'/g' ${psr}_noise.json;
done
