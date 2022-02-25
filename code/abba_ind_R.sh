#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7
#SBATCH --mail-type=ALL
#SBATCH --time=24:00:00
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/ind_R_abba_%j
#SBATCH -o /scratch/jgoncal1/logs/ind_R_abba_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="ind_R_abba_"


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
module load R
conda activate angsd_env

# module load gnu/7.4.0

IND_NAMES="file_lists/samples_geneflow.txt"
ABABABABA_FILE="../data/processed/angsd_abbabaaba_out/abbababa_ind_sc16_minmaf002.Angsd.abbababa"
OUTPUT_FILE="../data/processed/ind_R_abba_c16_maf002_"


Rscript ~/angsd/R/jackKnife.R file=$ABABABABA_FILE indNames=$IND_NAMES outfile=$OUTPUT_FILE