#!/bin/bash -l
#SBATCH --cpus-per-task=5
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --array=16-16
#SBATCH --time=14:00:00
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/pop_R_abba_%j
#SBATCH -o /scratch/jgoncal1/logs/pop_R_abba_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="pop_R_abba_"


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
module load R
conda activate angsd_env

module load R


ABABABABA_FILE="../data/processed/abbababa2_pop_sc16.Angsd"
OUTPUT_FILE="../data/processed/abba_pop_R_sc16"
SIZEFILE="file_lists/gene_flow_tuberculatus.size"
POPNAMES="file_lists/gene_flow_tuberculatus.name"
ERROFILE="file_lists/errorList.error"


Rscript ~/angsd/R/estAvgError.R angsdFile=$ABABABABA_FILE out=$OUTPUT_FILE sizeFile=$SIZEFILE errFile=$ERROFILE nameFile=$POPNAMES