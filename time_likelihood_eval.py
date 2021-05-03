#!/bin/python

import pandas as pd
import numpy as np
import sys
import os
import bilby
import inspect
from enterprise_warp import enterprise_warp
from enterprise_warp import bilby_warp
from enterprise_warp.enterprise_warp import get_noise_dict
from enterprise_extensions import hypermodel

import ppta_dr2_models

opts = enterprise_warp.parse_commandline()

custom = ppta_dr2_models.PPTADR2Models

params = enterprise_warp.Params(opts.prfile,opts=opts,custom_models_obj=custom)
pta = enterprise_warp.init_pta(params)

s = """\
p.get_lnlikelihood(x0)
"""

import time


def informed_sample(hypermodel, noisedict):


    """
    Yanked from Boris' enterprise_extensions fork.
    Originally was a method of hypermodel class
    now takes a hypermodel object as arg
    
    Take an initial sample from the noise file. Abscent parameters will be
    sampled from the prior.
    """

    x0 = [np.array(p.sample()).ravel().tolist() \
          if p.name not in noisedict.keys() \
          else np.array(noisedict[p.name]).ravel().tolist() \
          for p in hypermodel.models[0].params]
    uniq_params = [str(p) for p in hypermodel.models[0].params]

    for model in hypermodel.models.values():
            param_diffs = np.setdiff1d([str(p) for p  in model.params], \
                                        uniq_params)
            mask = np.array([str(p) in param_diffs for p in model.params])
            x0.extend([np.array(pp.sample()).ravel().tolist() \
                       if pp.name not in noisedict.keys() \
                       else np.array(noisedict[pp.name]).ravel().tolist() \
                       for pp in np.array(model.params)[mask]])

            uniq_params = np.union1d([str(p) for p in model.params], \
                                      uniq_params)

    x0.extend([[0.1]])
            
    return np.array([p for sublist in x0 for p in sublist])



if params.sampler == 'ptmcmcsampler':
    super_model = hypermodel.HyperModel(pta)
    print('Super model parameters: ', super_model.params)
    print('Output directory: ', params.output_dir)
    # Filling in PTMCMCSampler jump covariance matrix
    # if params.mcmc_covm is not None:
    #   ndim = len(super_model.param_names)
    #   identity_covm = np.diag(np.ones(ndim) * 1**2)
    #   identity_covm_df = pd.DataFrame(identity_covm, \
    #                                   index=super_model.param_names, \
    #                                   columns=super_model.param_names)
    #   covm = params.mcmc_covm.combine_first(identity_covm_df)
    #   identity_covm_df.update(covm)
    #   covm = np.array(identity_covm_df)
    # else:
    #   covm = None
    sampler = super_model.setup_sampler(resume=True, outdir=params.output_dir)#, initial_cov=covm)
    N = params.nsamp
    x0 = super_model.initial_sample()
    try:
      noisedict = get_noise_dict(psrlist=[pp.name for pp in params.psrs],
                                 noisefiles=params.noisefiles)
      x0 = informed_sample(super_model, noisedict)
      # Start ORF inference with zero correlation:
      if 'corr_coeff_0' in super_model.param_names and \
         len(x0)==len(super_model.param_names):
        print('Starting sampling free ORF with zeros')
        orf_mask = [True if 'corr_coeff' in prn else False \
                    for prn in super_model.param_names]
        x0[orf_mask] = 0.
    except:
      print('Informed sample is not possible')

    # Remove extra kwargs that Bilby took from PTSampler module, not ".sample"
    ptmcmc_sample_kwargs = inspect.getargspec(sampler.sample).args
    upd_sample_kwargs = {key: val for key, val in params.sampler_kwargs.items()
                                  if key in ptmcmc_sample_kwargs}
    del upd_sample_kwargs['Niter']
    del upd_sample_kwargs['p0']
    if opts.mpi_regime != 1:
        

        times_pta = {}
        for n, p in pta.items():
        #print(p)
            times = []
            
            for _ in range(100):
                t0 = time.perf_counter()
                pta.get_lnlikelihood(x0)
                t1 = time.perf_counter()
                dt = t1 - t0
                times.append(dt)
            print(np.mean(times))
            times_pta[n] = np.mean(times)
            #p.timeit.timeit(stmt = s, number = 100)
            print('time to eval likelihood: {}'.format(np.mean(times)))
        print(times_pta)
      #sampler.sample(x0, N, **upd_sample_kwargs)
    else:
      print('Preparations for the MPI run are complete - now set \
             opts.mpi_regime to 2 and enjoy the speed!')
else:
    priors = bilby_warp.get_bilby_prior_dict(pta[0])
    parameters = dict.fromkeys(priors.keys())
    likelihood = bilby_warp.PTABilbyLikelihood(pta[0],parameters)
    label = os.path.basename(os.path.normpath(params.out))
    if opts.mpi_regime != 1:
      bilby.run_sampler(likelihood=likelihood, priors=priors,
                        outdir=params.output_dir, label=params.label,
                        sampler=params.sampler, **params.sampler_kwargs)
    else:
      print('Preparations for the MPI run are complete - now set \
             opts.mpi_regime to 2 and enjoy the speed!')

with open(params.output_dir + "completed.txt", "a") as myfile:
  myfile.write("completed\n")
print('Finished: ',opts.num)
