#!/bin/bash -l
#SBATCH --nodes=1 # request one node
#SBATCH --partition=devel-rh7 
#SBATCH --time=1:00:00 # ask that the job be allowed to run for 1 hour.
#SBATCH --cpus-per-task=4 # ask for 4 cpua
#SBATCH --mem=42gb # Maximum amount of memory this job will be given, try to estimate this to the best of your ability. This asks for 42 GB of ram.
# everything below this line is optional, but are nice to have quality of life things
#SBATCH --mail-type=ALL
#SBATCH --account=UniKoeln 
#SBATCH --mail-user=jgoncal1@uni-koeln.de # receive an email wiht updates
#SBATCH --error /scratch/jgoncal1/logs/errors/job_%j.err # tell it to store the eroor log console text to a file called job.<assigned job number>.err
#SBATCH --output=/scratch/jgoncal1/logs/job_%J.out # tell it to store the output console text to a file called job.<assigned job number>.out
#SBATCH -D /projects/ag-stetter/jdias/projects/GeneFlow/code/  # working directory
#SBATCH --job-name="this_is_my_job" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
module load gnu/7.4.0

echo "test"
