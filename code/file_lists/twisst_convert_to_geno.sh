#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/convert_to_geno_sc16_%j
#SBATCH -o /scratch/jgoncal1/logs/convert_to_geno_sc16_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd 


python /projects/jgoncal1/tools/bin/genomics_general/VCF_processing/parseVCF.py -i ../data/processed/twisst/filtered_full_genomeScaffold_16.vcf.gz --skipIndels | gzip > ../data/processed/filtered_full_genomeScaffold_16.geno.gz