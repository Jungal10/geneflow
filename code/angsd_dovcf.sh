#!/bin/bash -l
#SBATCH --cpus-per-task=5
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=720:00:00
#SBATCH --mem=500gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/angsd_dovcf_geneflow_allchr_depth1500_maxmem_time__%j
#SBATCH -o /scratch/jgoncal1/logs/angsd_dovcf_geneflow_allchr_depth1500_maxmem_time__%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="angsd_dovcf_geneflow_allchr_depth_1500_maxmem_time"


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/angsd_dovcf_108_samples_allchr_depth1500_maxmem_time'


angsd -b $INPUT_BAM \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-P 5 \
-doCounts 1 \
-doGeno 3 \
-dovcf 1 \
-gl 2 \
-dopost 2 \
-domajorminor 1 \
-domaf 1 \
-checkBamHeaders 0 \
-minInd 73 \
-minQ 20 \
-minMapQ 30 \
-only_proper_pairs 1 \
-trim 0  \
-SNP_pval 1e-6 \
-C 50 \
-setMaxDepthInd 1500 \
-setMinDepth 73 \
-SNP_pval 1e-6 
