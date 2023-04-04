#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/chr_splitter_angsd_vcf_tuberculatus_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/chr_splitter_angsd_vcf_tuberculatus_%j

source /home/jgoncal1/.bashrc
conda activate base_jgd
 module load vcftools

VCF_FILE="../data/processed/phased_subsampled_minmaf0005.vcf.gz"

for i in $(seq 1 16); do
for chr in "Scaffold_"$i; do

# for i in $(seq 1 16); do

echo $chr

 vcftools  --gzvcf  $VCF_FILE  --chr $chr  --recode --recode-INFO-all --out  ../data/processed/VCF_angsd_tuberculatus_$chr;
done
done
