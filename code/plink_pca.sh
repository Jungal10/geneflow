#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=12:00:00
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/plink_pca_%j
#SBATCH -o /scratch/jgoncal1/logs/plink_pca_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="clust_plink_"



source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd


VCF_FILE="../data/processed/vcf_without_outgroup_sc16.vcf.gz"

plink --vcf $VCF_FILE \
--double-id \
--freq \
--allow-extra-chr \
--make-bed \
--pca \
--geno \
--mind 0.7 \
--maf 0.02 \
--out ../data/processed/clust_annotated_filtered_reheader_prunned_sc16_no_outgroup
