#!/bin/bash -l
#SBATCH --cpus-per-task=6
#SBATCH --partition=smp-rh7 
#SBATCH --mem=252gb
#SBATCH --time=96:00:00
#SBATCH --account=UniKoeln
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/pop_abbababa_geneflow_tuberculatus_%j.err 
#SBATCH --output=/scratch/jgoncal1/logs/pop_abbababa_geneflow_tuberculatus_%J.out 
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="pop_abbababa_geneflow_tuberculatus" 

source /home/jgoncal1/.bashrc
module load gnu/7.4.0
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
SIZE_FILE='file_lists/gene_flow_tuberculatus.size'
OUTPUT_FILE='../data/processed/abbababa2_geneflow_tuberculatus_nodepthfilter.Angsd'


angsd -doAbbababa2 1 \
-P 6  \
-bam $INPUT_BAM \
-sizeFile $SIZE_FILE \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-doCounts 1 \
-doMaf 1 \
-doMajorMinor 1 \
-GL 2 \
-useLast 1 \
-checkBamHeaders 0 \
-minInd 73 \
-minQ 20 \
-minMapQ 30 \
-only_proper_pairs 1 \
-trim 0  \
-SNP_pval 1e-6 \
-C 50