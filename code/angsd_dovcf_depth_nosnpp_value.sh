#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=144:00:00
#SBATCH --mem=400gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/angsd_dovcf_geneflow_allchr_depth1500_mindepth5___nosnppvalue%j
#SBATCH -o /scratch/jgoncal1/logs/angsd_dovcf_geneflow_allchr_depth1500_mmindepth5__nosnppvalue%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="angsd_dovcf_geneflow_allchr_depth_1500_mindepth5__nosnppvalue"


source /home/jgoncal1/.bashrc
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/angsd_dovcf_108_samples_allchr_depth1500_mindepth_5_nosnppvalue'


angsd -b $INPUT_BAM \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-gl 2 \
-doMajorMinor 1 \
-doMaf 1 \
-doCounts 1 \
-doGeno 3 \
-dovcf 1 \
-dopost 2 \
-checkBamHeaders 0 \
-minInd 73 \
-minQ 20 \
-minMapQ 30 \
-only_proper_pairs 1 \
-trim 0  \
-C 50 \
-setMaxDepth 1500 \
-setMinDepth 5 
