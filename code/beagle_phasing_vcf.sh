#!/bin/bash -l
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/beagle_phasing_angsd_%j
#SBATCH -o /scratch/jgoncal1/logs/beagle_phasing_angsd_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code


source /home/jgoncal1/.bashrc
module load openjdk/1.8.0_60



java -Xmx60000m -jar /projects/jgoncal1/tools/bin/beagle.28Jun21.220.jar \
gt=../data/processed/subsampled_minmaf0005.vcf.gz \
out=../data/processed/phased_subsampled_minmaf0005 
