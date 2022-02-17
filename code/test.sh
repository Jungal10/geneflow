#!/bin/bash -l
#SBATCH --time=720:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=21gb
#SBATCH --array=1-16 
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/cp2_sc16_%j.error
#SBATCH -o /scratch/jgoncal1/logs/cp2_sc16_%j.log
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/sandbox/
#SBATCH --job-name="cp2_sc16_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers




source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate fscp



phase_file="../data/processed/plink_phased_susbset_filtered_reheader_prunned_sc16.phase"
ids="file_lists/list_geneflow_cp.ids"
recombfile="../data/processed/sc16_phased_prunned.recombfile"
poplist="file_lists/poplist_for_cp.filein"
output_file="/scratch/jgoncal1/fscp_output/cp2_withf_geneflow_spithyb_sc16.hap1"


ChromoPainterv2 -b -in -iM -i 10 -g $phase_file -r $recomb_file -t $ids -o $output_file -f $poplist 0 0