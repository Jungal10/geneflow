#!/bin/bash -l
#SBATCH --nodes=1 # request one node
#SBATCH --time=1:00:00 # ask that the job be allowed to run for 1 hour.
#SBATCH --partition=devel-rh7 #partition devel is only for very small runs or tryouts
#SBATCH --cpus-per-task=1 # ask for 1 cpu
#SBATCH --mem=42gb # Maximum amount of memory this job will be given, try to estimate this to the best of your ability. This asks for 42 GB of ram.
# everything below this line is optional, but are nice to have quality of life things
#SBATCH --mail-type=ALL
#SBATCH --account=UniKoeln 
#SBATCH --mail-user=jgoncal1@uni-koeln.de # receive an email wiht updates
#SBATCH --error /scratch/jgoncal1/logs/errors/job%j.err
#SBATCH --output=/scratch/jgoncal1/logs/job.%J.out # tell it to store the output console text to a file called job.<assigned job number>.out
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/  # working directory


# under this line, we can load any modules if necessary


# source /home/jgoncal1/.bashrc
# module load gnu/7.4.0


source /home/jgoncal1/.bashrc
conda activate base_jgd


echo "test"
