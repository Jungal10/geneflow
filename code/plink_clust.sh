#!/bin/bash -l
#SBATCH --cpus-per-task=5
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=72:00:00
#SBATCH --mem=126gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/clust_plink_%j
#SBATCH -o /scratch/jgoncal1/logs/clust_plink_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="clust_plink_"



source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd


VCF_FILE="../data/processed/without_tuberculatus.vcf.gz"


plink --vcf $VCF_FILE \
--double-id \
--freq \
--allow-extra-chr \
--within ../data/processed/clust_file_geneflow_without_tuberculatus_samples \
--make-bed \
--pca \
--geno \
--mind 0.7 \
--out ../data/processed/clust_annotated_geneflow_without_tuberculatus
