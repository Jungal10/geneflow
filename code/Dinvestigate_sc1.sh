#!/bin/bash -l
#SBATCH --partition=devel-rh7 
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/Dsuite_Dinvestigate_w100_sc16_crops_only_devel_%j.err
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/Dsuite_Dinvestigate_w100_sc16_crops_only_devel_%j.log
#SBATCH --job-name="Dsuite_Dinvestigate_w100_sc16_crops_only_devel_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd
module load gnu/7.4.0

Dsuite Dinvestigate -w 100,100 -n Dsuite_Dinvestigate_w100_step_100_sc16_crops_only_devel_ ../data/processed/reheader_dovcf_geneflowsamples_sc16.vcf.gz file_lists/list_amaranth_geneflow_samples_populations.txt file_lists/crops_only.txt
