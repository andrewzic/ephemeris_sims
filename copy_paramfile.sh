#!/bin/bash

for p in `cat parameters.dat`; do echo $p; lp=$(echo $p | awk '{print tolower($0)}'); cp /flush5/zic006/ephemeris_sims/params/params_blah_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.dat /flush5/zic006/ephemeris_sims/params/params_${lp}_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.dat; sed -i 's|BLAH|'$p'|g' /flush5/zic006/ephemeris_sims/params/params_${lp}_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.dat; sed -i 's|blah|'$lp'|g' /flush5/zic006/ephemeris_sims/params/params_${lp}_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.dat; done

for p in `cat parameters.dat`; do echo $p; lp=$(echo $p | awk '{print tolower($0)}'); cp /flush5/zic006/ephemeris_sims/slurm/slurm_blah_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.sh /flush5/zic006/ephemeris_sims/slurm/slurm_${lp}_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.sh; sed -i 's|BLAH|'$p'|g' /flush5/zic006/ephemeris_sims/slurm/slurm_${lp}_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.sh; sed -i 's|blah|'$lp'|g' /flush5/zic006/ephemeris_sims/slurm/slurm_${lp}_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210428.sh; done