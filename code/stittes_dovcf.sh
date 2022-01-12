#!/bin/bash -l
#SBATCH --cpus-per-task=5
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=72:00:00
#SBATCH --mem=126gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/reprod_angsd_dovcf_129samples_allchr_126gb_72h%j
#SBATCH -o /scratch/jgoncal1/logs/repord_angsd_dovcf_129samples_allchr_126gb_72h%j
#SBATCH -D /projects/ag-stetter/jdias/projects/GeneFlow/code/
#SBATCH --job-name="reprod_129_angsd_tites"



source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env

INPUT_BAM='../data/processed/list_files/bam_files_all_outgroups.txt'
OUTPUT_FILE='../data/processed/reprod_angsd_dovcf_129samples_allchr_126gb_72h'


angsd -b $INPUT_BAM \
-P 5 \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-remove_bads 1 \
-only_proper_pairs 1 \
-trim 0  \
-C 50  \
-minMapQ 30 \
-minQ 30 \
-doCounts 1 \
-setMinDepth 5 \
-setMaxDepth 150 \
-doGeno 3 \
-dovcf 1 \
-gl 2 \
-dopost 2 \
-domajorminor 1 \
-domaf 1 \
-snp_pval 1e-6 \
-checkBamHeaders 0 \
-out $OUTPUT_FILE
