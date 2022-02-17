#!/bin/bash -l
#SBATCH --partition=devel
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/reocde12_plink2cp_introgrtession_108_%j
#SBATCH -o /scratch/jgoncal1/logs/reocde12_plink2cp_introgrtession_108_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/GeneFlow/code/




for i in {1..15};
do

/projects/jgoncal1/tools/bin/fs_4.1.1/plink2chromopainter.pl \
-p ../data/processed//plink_phased_VCF_angsd_tuberculatus_Scaffold_${i}.ped \
-m ../data/processed/plink_phased_VCF_angsd_tuberculatus_Scaffold_${i}.map \
-o ../data/processed/plink_phased_VCF_angsd_tuberculatus_Scaffold_${i}.phase

done

# PED_FILE="../data/processed/plink_phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.ped"
# MAP_FILE="../data/processed/plink_phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.map"
# OUTPUT_FILE="../data/processed/plink_phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.phase"