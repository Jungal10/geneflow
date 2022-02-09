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
reheadered_angsd_VCF=reheader_$(basename $angsd_VCF)
phased_VCF=phased_$(basename $reheadered_angsd_VCF | cut -f1 -d'.')
annotated_VCF=annotated_$(basename phased_VCF | cut -f1 -d'.')
echo "anotated VCF: ../data/processed/"$annotated_VCF

echo "..."
tabix -p vcf $angsd_VCF

echo "finishing tabix angsd vcf"

echo "fixing headers"

 bcftools reheader -s $samplesnames $angsd_VCF | bcftools view -Oz -o  ../data/processed/$reheadered_angsd_VCF
echo "reheadered_VCF: "$reheadered_angsd_VCF

 tabix -p vcf ../data/processed/$reheadered_angsd_VCF

echo "tabix rehedered VCF: "$reheadered_angsd_VCF".tbi"

echo "phasing file"

java -Xmx60000m -jar /projects/jgoncal1/tools/bin/beagle.28Jun21.220.jar \
gt=../data/processed/$reheadered_angsd_VCF \
out=../data/processed/$phased_VCF

echo "phased_VCF done: ../data/processed/"$phased_VCF".vcf.gz"
tabix -f -p vcf ../data/processed/$phased_VCF.vcf.gz

echo "annotating VCF"

bcftools annotate --set-id +'%CHROM\_%POS' ../data/processed/$phased_VCF.vcf.gz | bcftools view -O z -o ../data/processed/$annotated_VCF.vcf.gz

echo "done anotated VCF: ../data/processed/"$annotated_VCF.vcf.gz

