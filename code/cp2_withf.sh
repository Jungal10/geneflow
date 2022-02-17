#!/bin/bash -l
#SBATCH --time=720:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=21gb
#SBATCH --array=1-16 
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/cp2_subset_introgression_108_hybT_popAmranth_selection_array_%j.error
#SBATCH -o /scratch/jgoncal1/logs/cp2_subset_introgression_108_hybT_popAmranth_selection_array_%j.log
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/sandbox/
#SBATCH --job-name="cp2_subset_introgression_108_hybT_popAmranth_selection_array" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers




source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate fscp




ids="../data/processed/list_files/subset_introgression_108_hybT_popAmranth_selection.ids"

ChromoPainterv2 \
-b -in -iM -i 10 \
-g ../data/processed/plink_phased_VCF_introgression108_Scaffold_$SLURM_ARRAY_TASK_ID.phase \
-r ../data/processed/introgression108_Scaffold_$SLURM_ARRAY_TASK_ID.recombfile \
-t $ids \
-o ../data/processed/full_cp2_withf_introgression_108_hybT_popAmranth_selection_array_$SLURM_ARRAY_TASK_ID.hap1 \
-f ../data/processed/poplist_for_cp.filein 0 0




# recombfile="../data/processed/9each_Scaffold_15.recombfile"
# phasefile="../data/processed/plink_phased_VCF_9each_Scaffold_15.phase"
