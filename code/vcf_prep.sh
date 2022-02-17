#!/bin/bash -l
#SBATCH --partition=devel
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
module load openjdk/
conda activate base_jgd 


if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` [samples_list] [VCF_FILE]"
  exit 0
fi


samplesnames=$1
echo "File list:
"
echo "samples: "$samplesnames
angsd_VCF=$2 # 
echo "angsd vcf:" $angsd_VCF
reheadered_angsd_VCF=tmp_reheader_$(basename $angsd_VCF)
annotated_VCF=tmp_annotated_$(basename $reheadered_angsd_VCF | cut -f1 -d'.')
clust_VCF=tmp_clust_$(basename $annotated_VCF | cut -f1 -d'.')
CLUST_FILE="file_lists/samples_geneflow.clust"
phased_VCF=phased_$(basename $angsd_VCF | cut -f1 -d'.')
reheadered_clust_VCF=tmp_reheader_$(basename $clust_VCF)



echo "..."
tabix -f -p vcf $angsd_VCF

echo "finishing tabix angsd vcf"

echo "fixing headers"

 bcftools reheader -s $samplesnames $angsd_VCF | bcftools view -Oz -o  ../data/processed/$reheadered_angsd_VCF
echo "reheadered_VCF: "$reheadered_angsd_VCF

 tabix -p vcf ../data/processed/$reheadered_angsd_VCF

echo "tabix rehedered VCF: "$reheadered_angsd_VCF".tbi"

echo "annotating VCF"

bcftools annotate --set-id +'%CHROM\_%POS' ../data/processed/$reheadered_angsd_VCF | bcftools view -O z -o ../data/processed/$annotated_VCF.vcf.gz

echo "done annotated VCF: ../data/processed/"$annotated_VCF.vcf.gz

echo "doing tabix on annotated VCF: ../data/processed/"$annotated_VCF.vcf.gz

tabix -f -p vcf ../data/processed/$annotated_VCF.vcf.gz

echo "done tabix on annotated VCF: ../data/processed/"$annotated_VCF.vcf.gz

echo "doing plink clust"

plink --vcf ../data/processed/$annotated_VCF.vcf.gz \
--double-id \
--freq \
--allow-extra-chr \
--within $CLUST_FILE \
--make-bed \
--pca \
--geno \
--mind 0.7 \
--maf 0.02 \
--recode vcf \
--out ../data/processed/$clust_VCF


echo "done plink clust"

echo "bgzip on ../data/processed/"$clust_VCF.vcf

bgzip ../data/processed/$clust_VCF.vcf


echo "doing tabix on clust VCF: ../data/processed/"$clust_VCF.vcf.gz

tabix -f -p vcf ../data/processed/$clust_VCF.vcf.gz

echo "performing reheadering to fix double naming provoked by plink"

bcftools reheader -s $samplesnames  ../data/processed/$clust_VCF.vcf.gz | bcftools view -Oz -o  ../data/processed/$reheadered_clust_VCF.vcf.gz

echo "reheadered_clust_VCF: "$reheadered_clust_VCF.vcf.gz

tabix -p vcf ../data/processed/$reheadered_clust_VCF.vcf.gz

echo "tabix rehedered VCF: "$reheadered_clust_VCF".tbi"



echo "phasing file"

java -Xmx60000m -jar /projects/jgoncal1/tools/bin/beagle.28Jun21.220.jar \
gt=../data/processed/$reheadered_clust_VCF.vcf.gz \
out=../data/processed/$phased_VCF

echo "phased_VCF done: ../data/processed/"$phased_VCF
tabix -f -p vcf ../data/processed/$phased_VCF.vcf.gz

echo "file ready ../data/processed/"$phased_VCF.vcf.gz
echo "removing temporary intermediate files:" 
ll ../data/processed/tmp_*
rm ../data/processed/tmp_*
