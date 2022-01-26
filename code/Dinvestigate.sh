#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=8:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/DInvestiagte_gatk_test_correct_trios_%j.err
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/DInvestiagte_gatk_test_correct_trios_%j.log
#SBATCH --job-name="DInvestiagte_w50_test_correct_trios" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
conda activate base_jgd
module load gnu/7.4.0

Dsuite Dinvestigate \
-w 50,1 \
-n Dsuite_Dinvestigate_w50 \
../data/processed/phased_subsampled_minmaf0005.vcf.gz \
file_lists/list_amaranth_geneflow_samples_populations.txt \
file_lists/correct_trios.txt 
