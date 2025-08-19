#!/bin/sh

### Template standalone Slurm job submission script for NetLogo BehaviorSpace experiments
### Umit Aslan, 2025
### https://ccl.northwestern.edu

#SBATCH --account=PROJECTID       ### replace PROJECTID with your allocation/project ID number.
#SBATCH --partition=short         ### replace short with medium, long, gengpu, etc if needed.
#SBATCH --time=1:30:00            ### time format is hh:mm:ss
#SBATCH --nodes=1                 ### leave the --nodes as 1 because NetLogo doesn't support running simultanously on multiple physical CPUs
#SBATCH --ntasks-per-node=16      ### replace 16 with the number of CPU cores you will request
#SBATCH --mem=4G                  ### replace 4G with the amount of memory you will request; do not forget to put G after the number.
#SBATCH --job-name=EXAMPLE_JOB    ### replace EXAMPLE_JOB with the name of your job (can be anything)
#SBATCH --output=%x-%j.out        ### automatically generates an output file. Slurm replaces %x with job name you provided in the previous instruction and %j with the unique job id. 
#SBATCH --error=%x-%j.err         ### automatically generates an error file. 
#SBATCH --mail-type=ALL           ### replace ALL with BEGIN, END, or FAIL if you'd like to.
#SBATCH --mail-user=U@SCHOOL.EDU  ### Replace U@SCHOOL.edu with your own email address so that Slurm can send you emails when your job is queed, started, completed, or terminated due to an error.

module purge all
module load java/jdk-17.0.2+8     ### You may need to update this line if your HPC doesn't have the jdk-17.0.2+8 module available.

JVM_OPTS=(-Xmx1024m -server -XX:+UseParallelGC -Dfile.encoding=UTF-8 -Dnetlogo.extensions.dir="${BASE_DIR}/extensions")

### Make sure to update the NetLogo installation path, experiment name, model filename, experiment name and output filename variables in the following command.
java ${JVM_OPTS[@]} -classpath PATH/TO/NETLOGO/lib/app/netlogo-6.4.0.jar org.nlogo.headless.Main --model "MODELFILE.nlogo" --experiment "EXPERIMENT_NAME" --threads 16 --table PATH/TO/OUT/FOLDER/OUTPUTFILE.csv
