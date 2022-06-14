#!/bin/bash -l
#SBATCH --partition=devel
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/prepare_prunnning_%j
#SBATCH -o /scratch/jgoncal1/logs/prepare_prunnning_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/introgression_files/code/




VCF_FILE='../data/processed/anno_reheader_filtered_angsd_vcf_file.vcf.gz'


plink --vcf $VCF_FILE \
--double-id \
--allow-extra-chr \
--indep-pairwise 50 5 0.3 \
--out ../data/processed/plink_prunned/prunned_anno_angsd_vcf_file_50_5_03