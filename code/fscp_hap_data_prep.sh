#!/bin/bash -l
#SBATCH --partition=smp-rh7
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/hap_data_prep_%j
#SBATCH -o /scratch/jgoncal1/logs/hap_data_prep_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="hap_data_prep_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers


csplit -f /scratch/jgd_hap_data/sc3_haplotypes -z <(gunzip -c ../data/processed/full_cp2_geneflow_Scaffold_3.hap1.copyprobsperlocus.out.gz) /HAP/ '{*}'



