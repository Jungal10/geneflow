#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --mem=400gb
#SBATCH --time=140:00:00
#SBATCH --account=UniKoeln
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/abbababa2_pop_geneflow_tuberculatus_nosnppvalue_depth1500_mindepth5_b_%j.err 
#SBATCH --output=/scratch/jgoncal1/logs/abbababa2_pop_geneflow_tuberculatus_nosnppvalue_depth1500_mindepth5_%J.out 
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="abbababa2_pop_geneflow_tuberculatus_nosnppvalue_depth1500_mindepth5" 

source /home/jgoncal1/.bashrc
module load gnu/7.4.0
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
SIZE_FILE='file_lists/gene_flow_tuberculatus.size'
OUTPUT_FILE='../data/processed/abbababa2_pop_geneflow_tuberculatus_nosnppvalue_depth1500_mindepth5_.Angsd'


angsd -doAbbababa2 1 \
-bam $INPUT_BAM \
-sizeFile $SIZE_FILE \
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
-C 50 \
-setMinDepth 5 \
-setMaxDepth 1500

# -SNP_pval 1e-6 \
# -doMaf 1 \
# -doMajorMinor 1 \
# -GL 2 \
