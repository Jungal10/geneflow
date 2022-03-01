#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/twistt_create_trees_sc3_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/twistt_create_trees_sc3_%j


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd 


python /projects/jgoncal1/tools/bin/genomics_general/phylo/phyml_sliding_windows.py -T 10 -g ../data/processed/twisst/filtered_full_genomeScaffold_3.geno.gz -p ../data/processed/twisst/filtered_Scaffold3_output.phmyl.w100  --outgroup ERR3220318 -w100  --windType sites --model GTR --optimise n
