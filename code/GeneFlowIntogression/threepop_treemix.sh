#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=16:00:00
#SBATCH --mem=126gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/threpop_treemix_sc16_%j
#SBATCH -o /scratch/jgoncal1/logs/threpop_treemix_sc16_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="threpop_treemix_sc16_"


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env
module load boost

INPUT_FILE="../data/processed/treemix_output/treemix_input.gz"
OUTPUT_FILE="../data/processed/treemix_output/treemix_threeop.gz"
threepop -i $INPUT_FILE -k 500 > $OUTPUT_FILE