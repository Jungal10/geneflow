#!/bin/bash -l
#SBATCH --cpus-per-task=3
#SBATCH --partition=smp-rh7
#SBATCH --mail-type=ALL
#SBATCH --time=48:00:00
#SBATCH --mem=252gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/dobcf_geneflow_ancient_samples_sc_16%j
#SBATCH -o /scratch/jgoncal1/logs/dobcf_geneflow_ancient_samples_sc_16%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="dobcf_geneflow_ancient_samples_sc_16"


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_new

INPUT_BAM='file_lists/list_amaranth_geneflow_ancient_samples_tuberculatus_bam_files.txt'
OUTPUT_FILE='../data/processed/dobcf_geneflow_ancient_samples_sc_16'

angsd -b $INPUT_BAM \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-P 3 \
-r Scaffold_16: \
-doCounts 1 \
-doGeno 3 \
-dobcf 1 \
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
-setMaxDepthInd 150 \
-setMinDepth 73 
