#!/usr/bin/csh

set PAT="/DATA/CETUS_3/zic006/ssb/ptasim/DE990_sims/"
set template=$PAT/ptasim_init_files/ptasim_DE990_ppta_template.input

foreach param_label (`cat $PAT/parameters.dat`)
    set ptasim_inp=$PAT/ptasim_init_files/ptasim_ppta_DE990_${param_label}.input
    if (! -f $ptasim_inp) then
	cp $template $ptasim_inp
	sed -i 's|BLAH|'${param_label}'|g' $ptasim_inp
    endif
    
    cd $PAT/data/$param_label
    #if (-f output/real_0/J0437-4715.tim) then
	#echo ${param_label} already done. Continuing...
	#cd $PAT
	#continue
    #endif
    echo $ptasim_inp
    ptaSimulate $ptasim_inp
    source ${param_label}_perturb_ppta/scripts/runScripts_master
    #echo `basename $param_label`_perturb_v2/scripts/runScripts_master
    echo "all done for "${param_label}
    cd $PAT
end

# foreach i (`ls -d $PAT/DE4*`)
#     cd $param_label
#     set PTASIM_SET=`find $param_label -name "*DE4*.txt"`
#     echo `basename $param_label`
#     ptaSimulate $PTASIM_SET
#     source `basename $param_label`_perturb/scripts/runScripts_master
#     echo "DONESKIES"
# end




