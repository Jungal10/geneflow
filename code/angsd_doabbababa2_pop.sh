#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --partition=smp-rh7 
#SBATCH --mem=200gb
#SBATCH --time=48:00:00
#SBATCH --account=UniKoeln
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/abbababa2_pop_sc16_%j.err 
#SBATCH -o /scratch/jgoncal1/logs/abbababa2_pop_sc16_%j.out 
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name='abbababa2_pop_sc16'


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
SIZE_FILE='file_lists/gene_flow_tuberculatus.size'
OUTPUT_FILE='../data/processed/abbababa2_pop_sc16.Angsd'


angsd -doAbbababa2 1 \
-bam $INPUT_BAM \
-sizeFile $SIZE_FILE \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-doCounts 1 \
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
-r Scaffold_16: 
