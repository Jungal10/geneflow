#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=126gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/Dsuite_Dtrios_full_genome_%j.err
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/Dsuite_Dtrios_full_genome_%j.log
#SBATCH --job-name="Dsuite_Dtrios_full_genome_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd
module load gnu/7.4.0

Dsuite Dtrios \
../data/processed/vcf_files/ready_dovcf_geneflowsamples_all_chr.vcf.gz \
file_lists/list_amaranth_geneflow_samples_populations.txt  \
-n full_genome \
-o ../data/processed/Dtrios -c
