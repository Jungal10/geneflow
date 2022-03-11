#!/bin/bash -l
#SBATCH --time=240:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=21gb
#SBATCH --array=3-3 
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/cp2_sc3_%j.error
#SBATCH -o /scratch/jgoncal1/logs/cp2_sc3_%j.log
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="cp2_sc3_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate fscp




ids="file_lists/list_geneflow_cp.ids"
poplist="file_lists/poplist_for_cp.filein"


ChromoPainterv2 \
-b -in -iM -i 10 \
-g ../data/processed/fscp_input_files/plink_geneflowsamples_Scaffold_$SLURM_ARRAY_TASK_ID.phase \
-r ../data/processed/fscp_input_files/geneflowsamples_Scaffold_Scaffold_$SLURM_ARRAY_TASK_ID.recombfile \
-t $ids \
-o ../data/processed/full_cp2_geneflow_Scaffold_$SLURM_ARRAY_TASK_ID.hap1 \
-f $poplist 0 0




# recombfile="../data/processed/9each_Scaffold_15.recombfile"
# phasefile="../data/processed/plink_phased_VCF_9each_Scaffold_15.phase"
