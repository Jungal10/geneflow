#!/bin/bash -l
#SBATCH --partition=smp-rh7
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/twisstfinal_step_sc9_altered_samples_SA_%j
#SBATCH -o /scratch/jgoncal1/logs/twisstfinal_step_sc9_altered_samples_SA_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate ete3

export PYTHONPATH=$PYTHONPATH:/projects/jgoncal1/tools/bin/genomics_general/

echo "Preparing vcf for being using in S.Martin pipleine"

VCF_FILE="../data/processed/vcf_files/filtered_full_genome.vcf.gz"
OUTPUT_FILTERED_FILE="../data/processed/vcf_files/filtered_full_genome.vcf.gz"

bcftools filter --set-GTs . $VCF_FILE -O u | bcftools view -U -i 'TYPE=="snp" & MAC >= 2' -O z > $OUTPUT_FILTERED_FILE

#requites a tabix file
