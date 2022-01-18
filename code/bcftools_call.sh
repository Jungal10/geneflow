#!/bin/bash -l
#SBATCH --cpus-per-task=5
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=72:00:00
#SBATCH --mem=126gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/bcftools_snp_calling_.sh%j
#SBATCH -o /scratch/jgoncal1/logs/bcftools_snp_calling_.sh%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="reprod_129_angsd_tites"

source /home/jgoncal1/.bashrc
conda activate base_jgd


INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/VCF_bcftools'

bcftools mpileup -Ou \
--bam-list $INPUT_BAM \
-L 150 \
--min-BQ 30 \
-min-MQ 30 \
--fasta-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
--threads 2 | \
bcftools call -mv \
-O z \
--output $OUTPUT_FILE
