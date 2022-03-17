#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=8:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
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
file_lists/list_SA_Dtrios.txt  \
-n trees_full_genome_undersocres_ \
-o ../data/processed/Dtrios_with_trees -c


#--tree=file_lists/trees_fbranch.nwk \
