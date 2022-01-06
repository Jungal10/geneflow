#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --mem=400gb
#SBATCH --time=120:00:00
#SBATCH --account=UniKoeln
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/abbababa_ind_geneflow_tuberculatus_nosnppvalue_depth1500_mindepth5_%j.err 
#SBATCH --output=/scratch/jgoncal1/logs/abbababa_ind_geneflow_tuberculatus_nosnppvalue_depth1500_mindepth5_%J.out 
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="abbababa_ind_geneflow_tuberculatus_nosnppvalue_depth1500_max_mem_time_mindepth5" 

source /home/jgoncal1/.bashrc
module load gnu/7.4.0
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/abbababa_ind_geneflow_tuberculatus_nosnppvalue_depth1500_mindepth_5.Angsd'


angsd -doAbbababa 1 \
-bam $INPUT_BAM \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-doCounts 1 \
-useLast 1 \
-checkBamHeaders 0 \
-minInd 73 \
-minQ 20 \
-minMapQ 30 \
-only_proper_pairs 1 \
-trim 0  \
-setMaxDepth 1500 \
-C 50 \
-setMinDepth 5

# -GL 2 \
# -doMaf 1 \
# -doMajorMinor 1 \
# -SNP_pval 1e-6 \
