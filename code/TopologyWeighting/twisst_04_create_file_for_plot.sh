#!/bin/bash -l
#SBATCH --partition=smp-rh7
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --mail-type=ALL
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/twisstfinal_step_sc9_all_SA_with_pures_%j
#SBATCH -o /scratch/jgoncal1/logs/twisstfinal_step_sc9_all_SA_with_pures_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="twisstfinal_step_sc9_all_SA_with_pures_"




source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate ete3

export PYTHONPATH=$PYTHONPATH:/projects/jgoncal1/tools/bin/genomics_general/


input_trees="../data/processed/twisst/remake_output_Sc9_full_genome.phmyl.w100.trees.gz"
weights_file_output="../data/processed/twisst/twisstfinal_step_sc9_all_SA_with_pures.phmyl.w100.data.csv"
output_topos="../data/processed/twisst/twisstfinal_step_sc9_all_SA_with_pures"
groups_file="file_lists/twisst_altered_hybdSA_cau_qui.txt"

python /projects/jgoncal1/tools/bin/twisst/twisst.py -t $input_trees -w $weights_file_output --outputTopos $output_topos -g caudatus -g quitensis -g p_caudatus -g hybridus_SA -g p_quitensis -g hybridus_CA -g Outgroup --outgroup Outgroup --groupsFile $groups_file --method complete 