#!/bin/bash

### A simple script to automate the slurm job submission process for NetLogo BehaviorSpace experiments
### Umit Aslan, 2025
### https://ccl.northwestern.edu


model=$1
experiment=$2
category=$4
maxtime=$5
threads=$6
ram=$7

# NetLogo cannot divide experiments between multiple physical processors
machines=1

# load the config file to pull the shared variables
source config.sh

### AUTO GENERATE A TEMPORARY SCRIPT TO RUN THE EXPERIMENT
### This approach minimizes the repetitive editing and potential errors 
###  that may arise from trying to manually edit long scripts

totalram=$((ram*threads+4096))
modelpath=${path}/${model}

runfile=run_${experiment}.sh

# if a file with the same name exists, just delete it
if test -f $runfile ; then
    rm $runfile
fi

# create the slurm job definition within the run file
echo "#!/bin/sh" >> $runfile
echo "#SBATCH --account="${project} >> $runfile
echo "#SBATCH --partition="${category} >> $runfile
echo "#SBATCH --time="${maxtime} >> $runfile
echo "#SBATCH --nodes="${machines} >> $runfile 
echo "#SBATCH --ntasks-per-node="${threads} >> $runfile
echo "#SBATCH --mem="$((totalram/1024))G >> $runfile
echo "#SBATCH --job-name="${experiment} >> $runfile
echo "#SBATCH --output=output_%x-%j.out" >> $runfile
echo "#SBATCH --mail-type="ALL >> $runfile
echo "#SBATCH --mail-user="${email} >> $runfile

echo "module purge all" >> $runfile
echo "module load java/jdk-17.0.2+8" >> $runfile

echo "JVM_OPTS=(-Xmx${totalram}m -server -XX:+UseParallelGC -Dfile.encoding=UTF-8 -Dnetlogo.extensions.dir="${BASE_DIR}/extensions")" >> $runfile

echo "java ${JVM_OPTS[@]} -classpath ${path}/netlogo/lib/app/netlogo-6.4.0.jar org.nlogo.headless.Main --model ${modelpath} --setup-file ${path}/xml/${experiment}.xml --threads $threads --table ${path}/csv/${experiment}.csv" >> $runfile

echo "Job ID: "

# submit the job and print the job number
sbatch --parsable $runfile

# remove the temporary run file to keep things clean
rm $runfile