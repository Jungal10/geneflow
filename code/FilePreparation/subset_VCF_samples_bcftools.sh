#!/bin/bash -l
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=84gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/bcf_susbet_force_109%j
#SBATCH -o /scratch/jgoncal1/logs/bcf_susbet_force_109%j
#SBATCH -D /projects/ag-stetter/jdias/projects/introgression_files/

source /home/jgo ncal1/.bashrc
module load gnu/4.8.2


bcftools view -Oz -S data/raw/samples_introgression_109 data/raw/variant_calls/all_pop.vcf.gz --force-samples -m2  > data/processed/bcf_susbet_force_109.vcf.gz
