#!/bin/bash
#SBATCH --job-name=de5_ppta_pe_hd_fixgam_7nfreq_be_jup_el
#SBATCH --output=/flush5/zic006/ephemeris_sims/slurm_logs/de5_ppta_pe_hd_fixed_gamma_7_nfreq_be_jup_el_20210422_%A_%a.log
#SBATCH --ntasks=4
#SBATCH --time=1-21:30
#SBATCH --mem-per-cpu=7G
#SBATCH --tmp=8G
##SBATCH --array=0-25

# pyv="$(python -c 'import sys; print(sys.version_info[0])')"
# if [ "$pyv" == 2 ]
# then
#     echo "$pyv"
#     module load numpy/1.16.3-python-2.7.14
# fi


module load singularity

singularity exec /home/zic006/psr_gwb.sif which python3
singularity exec /home/zic006/psr_gwb.sif echo $TEMPO2
singularity exec /home/zic006/psr_gwb.sif echo $TEMPO2_CLOCK_DIR

singularity exec /home/zic006/psr_gwb.sif python3 /flush5/zic006/ephemeris_sims/run_analysis.py --prfile "/flush5/zic006/ephemeris_sims/params/params_de5_ppta_pe_fixed_gamma_7_nfreq_be_jup_el_20210422.dat"
