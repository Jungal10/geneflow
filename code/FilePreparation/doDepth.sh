#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --time=4:00:00
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/angsd_doDepth_allchr_maxD10000_w_filters_%j
#SBATCH -o /scratch/jgoncal1/logs/angsd_doDepth_allchr_maxD10000_wfilters_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env


INPUT_BAM='../../GeneFlow/data/processed/file_lists/bam_files_introgression_updated.txt'
OUTPUT_FILE='../data/processed/depth_files_introgression_allchr_maxD10000_wfilters'


angsd -b $INPUT_BAM \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-doDepth 1 \
-doCounts 1 \
-checkBamHeaders 0 \
-maxDepth 10000 \
-minInd 73 \
-minQ 20 \
-minMapQ 30 \
-only_proper_pairs 1 \
-trim 0  \
-C 50 \
-out $OUTPUT_FILE




