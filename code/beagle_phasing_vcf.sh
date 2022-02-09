#!/bin/bash -l
#SBATCH --time=24:00:00
#SBATCH --partition=smp-rh7
#SBATCH --cpus-per-task=1
#SBATCH --mem=84gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/beagle_phasing_angsd_%j
#SBATCH -o /scratch/jgoncal1/logs/beagle_phasing_angsd_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code


source /home/jgoncal1/.bashrc
module load openjdk/1.8.0_60


#for scaffold in {1..15};do # loop per scaffold


java -Xmx60000m -jar /projects/jgoncal1/tools/bin/beagle.28Jun21.220.jar \
gt=../data/processed/reheader_dovcf_geneflowsamples_all_chr.vcf.gz  \
out=../data/processed/phased_reheader_dovcf_geneflowsamples_all_chr


#done
