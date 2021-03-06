#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=16gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/fbranch_%j.err
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/fbranch_%j.log
#SBATCH --job-name="fbranch_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd
module load gnu/7.4.0

Dsuite Fbranch file_lists/trees_fbranch.nwk ../data/processed/Dtrios_with_trees_devel_tress_full_genome_tree.txt