#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/bacftools_reeahder_%j
#SBATCH -o /scratch/jgoncal1/logs/bacftools_rehaeder%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd 

vcf_file="../data/processed/dovcf_geneflow_ancient_samples_full_genome.vcf.gz"
samplesnames="file_lists/samples_geneflow.txt"
output="../data/processed/fied_headers__dovcf_geneflow_ancient_samples_full_genome.vcf.gz"


bcftools reheader -s $samplesnames $vcf_file | bcftools view -Oz -o  $output

tabix -p vcf $output


