#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/plink2cp_create_phase_file_%j
#SBATCH -o /scratch/jgoncal1/logs/plink2cp_create_phase_file_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="plink2cp_create_phase_file_"



source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate fscp



/projects/jgoncal1/tools/bin/fs_4.1.1/plink2chromopainter.pl \
-p ../data/processed/plink_phased_susbset_filtered_reheader_prunned_sc9.ped \
-m ../data/processed/plink_phased_susbset_filtered_reheader_prunned_sc9.map \
-o ../data/processed/plink_phased_susbset_filtered_reheader_prunned_sc9.phase


# PED_FILE="../data/processed/plink_phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.ped"
# MAP_FILE="../data/processed/plink_phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.map"
# OUTPUT_FILE="../data/processed/plink_phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.phase"