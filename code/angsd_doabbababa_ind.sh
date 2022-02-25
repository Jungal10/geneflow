#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --mem=84gb
#SBATCH --time=72:00:00
#SBATCH --account=UniKoeln
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/abbababa_ind_full_genome_minmaf002_%j.err 
#SBATCH --output=/scratch/jgoncal1/logs/abbababa_ind_full_genome_minmaf002_%j.out 
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="abbababa_ind_full_genome_minmaf002" 

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env
 
INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/abbababa_ind_full_genome_minmaf002.Angsd'


angsd -doAbbababa 1 \
-bam $INPUT_BAM \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-doCounts 1 \
-doMaf 1 \
-domajorminor 1 \
-useLast 1 \
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
-minMaf 0.02 