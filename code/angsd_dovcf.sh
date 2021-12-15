#!/bin/bash -l
#SBATCH --cpus-per-task=6
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=72:00:00
#SBATCH --mem=126gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/angsd_dovcf_129samples_allchr_126gb_72h%j
#SBATCH -o /scratch/jgoncal1/logs/angsd_dovcf_129samples_allchr_126gb_72h%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="129_angsd"


source /home/jgoncal1/.bashrc
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tubercualtus.txt'
OUTPUT_FILE='../data/processed/angsd_dovcf_108_samples_allchr_nodepth_filter'


angsd -b $INPUT_BAM \
-P 5 \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-only_proper_pairs 1 \
-trim 0  \
-C 50  \
-minMapQ 30 \
-minQ 20 \
-doCounts 1 \
-doGeno 3 \
-dovcf 1 \
-gl 2 \
-dopost 2 \
-domajorminor 1 \
-domaf 1 \
-snp_pval 1e-6 \
-checkBamHeaders 0 \
-out $OUTPUT_FILE



#-setMinDepth 5 \
#-setMaxDepth 150 \
