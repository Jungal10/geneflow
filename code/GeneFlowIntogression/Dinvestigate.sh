#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=28:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/Dsuite_Dinvestigate_w1000_1000_1000_full_genome_crops_only_%j.err
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/Dsuite_Dinvestigate_w1000_1000full_genome_crops_only_%j.log
#SBATCH --job-name="Dsuite_Dinvestigate_w1000_1000_full_genome_crops_only_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd
module load gnu/7.4.0

Dsuite Dinvestigate -w 1000,1000 -n Dsuite_Dinvestigate_w1000_1000step_1000_fullgenome_crops_only ../data/processed/ready_dovcf_geneflowsamples_all_chr.vcf.gz file_lists/list_amaranth_geneflow_samples_populations.txt file_lists/crops_only.txt
