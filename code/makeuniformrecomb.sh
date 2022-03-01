#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/mkaeunirecomb_%j
#SBATCH -o /scratch/jgoncal1/logs/mkaeunirecomb_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/GeneFlow/code/

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate fscp


for i in $(seq 1 16); do
# for chr in "Scaffold_"$i; do
makeuniformrecfile.pl  ../data/processed/fscp_input_files/plink_geneflowsamples_Scaffold_${i}.phase ../data/processed/fscp_input_files/geneflowsamples_Scaffold_${i}.recombfile
done