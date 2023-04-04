#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=devel-rh7 
#SBATCH --time=1:00:00
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/plink_pca_ancient_nofilters_original_header_%j
#SBATCH -o /scratch/jgoncal1/logs/plink_pca_ancient_nofilters_original_header_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="plink_pca_ancient_nofilters_original_header"



source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd


VCF_FILE="../data/processed/dobcf_geneflow_ancient_samples_sc_16.vcf.gz"

plink --vcf $VCF_FILE \
--double-id \
--allow-extra-chr \
--make-bed \
--pca \
--maf 0.07 \
--out ../data/processed/plink_pca_ancient_nofilters_sc16_maf007
