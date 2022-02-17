#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/reocde12_plink2cp_%j
#SBATCH -o /scratch/jgoncal1/logs/reocde12_plink2cp_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd



VCF_FILE='../data/processed/phased_VCF_angsd_tuberculatus_Scaffold_9.vcf.gz'

OUTFILE='../data/processed/plink_phased_susbset_filtered_reheader_prunned_sc9  '

for i in {1..15}; 
do

plink --vcf ../data/processed/ready_prunned_phased_VCF_angsd_tuberculatus_Scaffold_${i}.vcf.gz \
--double-id \
--allow-extra-chr \
--mind 0.7 \
--recode 12 \
--maf 0.02 \
--out ../data/processed/plink_phased_VCF_angsd_tuberculatus_Scaffold_${i}

done

#plink --vcf $VCF_FILE \
#--out $OUTFILE
