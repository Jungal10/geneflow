#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/bgzip_geneflow_%j
#SBATCH -o /scratch/jgoncal1/logs/bgzip_geneflow_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd 

for chr in {1..16}; do

FILE=../data/processed/filtered_full_genomeScaffold_${chr}
# echo $FILE 

bgzip $FILE 

mv $FILE.gz $FILE.vcf.gz

tabix $FILE.vcf.gz

done