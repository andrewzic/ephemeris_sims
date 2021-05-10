#!/bin/bash

ptemplate_fn="/DATA/CETUS_3/zic006/ssb/ptasim/DE990_sims/slurm/slurm_blah_ppta_pe_interporf_fixed_gamma_20_nfreq_20210510.sh"


for p in `cat parameters.dat`
do echo $p;
   params_fn=$(echo "$ptemplate_fn" | sed 's|blah|'"$p"'|g')
   echo $params_fn
   cp $ptemplate_fn $params_fn
   sed -i 's|BLAH|'"$p"'|g' $params_fn
   sed -i 's|blah|'"$p"'|g' $params_fn
done
