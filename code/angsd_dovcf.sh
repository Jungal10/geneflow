#!/bin/bash -l
#SBATCH --cpus-per-task=5
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=120:00:00
#SBATCH --mem=168gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/dovcf_geneflowsamples_full_genome_%j
#SBATCH -o /scratch/jgoncal1/logs/dovcf_geneflowsamples_full_genome_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="dovcf_geneflowsamples_full_genome_"


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/dovcf_geneflowsamples_full_genome'


angsd -b $INPUT_BAM \
-P 5 \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-doCounts 1 \
-doGeno 3 \
-dopost 2 \
-domajorminor 1 \
-domaf 1 \
-dovcf 1 \
-snp_pval 1e-6 \
-remove_bads 1 \
-minMapQ 30 \
-minQ 30 \
-gl 2 \
-checkBamHeaders 0 \
-minInd 73 \
-only_proper_pairs 1 \
-trim 0 \
-setMinDepth 73 \
-setMaxDepthInd 150 \
-out $OUTPUT_FILE
