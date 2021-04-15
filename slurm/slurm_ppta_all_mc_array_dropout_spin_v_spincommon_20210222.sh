#!/bin/bash
#SBATCH --job-name=snall_30nf_all_pe_cplvarsl_factor_drop
#SBATCH --output=/flush5/zic006/ppta_analysis_logs/ppta_all_mc_array_dropout_spin_v_spincommon_20210222_%A_%a.log
#SBATCH --ntasks=4
#SBATCH --time=1-21:30
#SBATCH --mem-per-cpu=7G
#SBATCH --tmp=8G
#SBATCH --array=0-25

# pyv="$(python -c 'import sys; print(sys.version_info[0])')"
# if [ "$pyv" == 2 ]
# then
#     echo "$pyv"
#     module load numpy/1.16.3-python-2.7.14
# fi


module load singularity

singularity exec /home/zic006/psr_gwb.sif which python
singularity exec /home/zic006/psr_gwb.sif echo $TEMPO2
singularity exec /home/zic006/psr_gwb.sif echo $TEMPO2_CLOCK_DIR

singularity exec /home/zic006/psr_gwb.sif python3 /flush5/zic006/ppta_analysis/run_analysis.py --prfile "/flush5/zic006/ppta_analysis/params/params_ppta_all_mc_array_dropout_spin_v_spincommon_20210222.dat" --drop 1 --num $SLURM_ARRAY_TASK_ID
