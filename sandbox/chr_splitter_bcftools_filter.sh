#!/bin/bash -l
#SBATCH --partition=smp-rh7 
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/chr_splitter_angsd_vcf_full_genome_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH -o /scratch/jgoncal1/logs/chr_splitter_angsd_vcf_full_genome_%j


source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd

VCF_FILE="../data/processed/vcf_files/filtered_full_genome.vcf.gz"

for i in $(seq 1 16); do
for chr in "Scaffold_"$i; do

echo $chr

 bcftools filter  $VCF_FILE  -r $chr -o  ../data/processed/filtered_full_genome$chr;
done
done
