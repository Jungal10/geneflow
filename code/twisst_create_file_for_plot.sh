#!/bin/bash -l
#SBATCH --partition=smp-rh7
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/twisstfinal_step_sc9_%j
#SBATCH -o /scratch/jgoncal1/logs/twisstfinal_step_sc9_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/



source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate ete3


python /projects/jgoncal1/tools/bin/twisst/twisst.py -t ../data/processed/twisst/remake_output_Sc9_full_genome.phmyl.w100.trees.gz -w ../data/processed/twisst/remake_output_Sc9_full_genome.phmyl.w100.data.tsv  --outputTopos ../data/processed/twisst/trees_output_scaffold9  -g caudatus -g hybridus_SA -g quitensis -g Outgroup  --outgroup Outgroup --groupsFile file_lists/all_samples_twisst.txt  --method complete 