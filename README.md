# Slurm job submission scripts for NetLogo

I developed these sample scripts for Northwestern University's Quest HPC based on [its official user guide](https://services.northwestern.edu/TDClient/30/Portal/KB/ArticleDet?ID=505).

Important notes: 

* I developed these scripts while using NetLogo 6.4 and did not test them with the upcoming 7.0 version yet. 
* Your HPC should provide a compatible `java` module. If you are not sure, you can use the `module available` command to see all the available modules. 
* NetLogo must be installed on your HPC on a path accessible to your user. The easiest way to do this is to download the 64-bit Linux file from [https://www.netlogo.org/downloads/linux/](https://www.netlogo.org/downloads/linux/) and unzip it in your user's home directory.


## `sample_standalone_job.sh`

This is a simple example of how to write Slurm job submission scripts for NetLogo. I left inline comments in this file next to each instruction starting with `###` with explanations for each instruction.

Once you update the variables in this script to match your experiment, you can submit the job as follows:

```
sbatch sample_standalone_job.sh
```


## `generate_and_submit.sh` 

This script makes life much easier (at least for me) when submitting Slurm jobs to run NetLogo Behaviorspace experiments. 

Before using it, make sure to update the `config.sh` file with your email address, allocation/project ID, and the experiment directory.

Then, run this script with the following command line arguments:

* `model file` (including the file extension)
* `experiment name` 
* `category` (short, normal, long, gengpu, etc.)
* `maxtime` (in *hh:mm:ss* format)
* `threads` (number of CPU cores to request)
* `ram` (in megabytes)

It will automatically generates an intermediary bash script, and then use it to submit the job. It will also delete the intermediary file after submission to prevent folder pollution.

Here's an example use:

```
bash generate_and_submit.sh fire.nlogo densityexp short 1:00:00 32 4096
```