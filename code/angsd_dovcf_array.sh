#!/bin/bash -l
#SBATCH --cpus-per-task=5
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --array=16-16
#SBATCH --time=14:00:00
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/dovcf_geneflowsamples_%j
#SBATCH -o /scratch/jgoncal1/logs/dovcf_geneflowsamples_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="angsd_dovcf_geneflowsamples_sc16"


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/dovcf_geneflowsamples_'$SLURM_ARRAY_TASK_ID


angsd -b $INPUT_BAM \
-P 5 \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-remove_bads 1 \
-minMapQ 30 \
-minQ 30 \
-gl 2 \
-doCounts 1 \
-doGeno 3 \
-dopost 2 \
-domajorminor 1 \
-domaf 1 \
-dovcf 1 \
-snp_pval 1e-6 \
-checkBamHeaders 0 \
-minInd 73 \
-only_proper_pairs 1 \
-trim 0 \
-setMinDepth 73 \
-setMaxDepthInd 150 \
-r Scaffold_$SLURM_ARRAY_TASK_ID: \
-out $OUTPUT_FILE
