#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=12gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/treemix_%j
#SBATCH -o /scratch/jgoncal1/logs/treemix_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd
module load gnu/7.4.0


for i in {0..6};
do
treemix -i  ../data/processed/input_treemix_without_tubercualtus.gz -k 500 -m $i -o ../data/processed/treemix_output_without_tubercualtus_$i  
done









