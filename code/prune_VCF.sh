#!/bin/bash -l
#SBATCH --partition=smp-rh7
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=84gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/prepare_prunnning_%j
#SBATCH -o /scratch/jgoncal1/logs/prepare_prunnning_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd 
module load openjdk/



if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` [VCF_FILE]"
  exit 0
fi


VCF_FILE=$1
PRUNNED_IN_SITES=../data/processed/forprunning_03_$(basename $VCF_FILE | cut -f1 -d'.')
PRUNNED_VCF=../data/processed/tmp_prunned_$(basename $VCF_FILE | cut -f1 -d'.')
OUTFILE=../data/processed/ready_prunned_$(basename $VCF_FILE | cut -f1 -d'.')

echo "Calculating indep-pairwise for estimating sites to prune"

plink --vcf $VCF_FILE \
--double-id \
--allow-extra-chr \
--maf 0.02 \
--indep-pairwise 50 5 0.3 \
--out $PRUNNED_IN_SITES

echo "finished finidng sites for prunning, file: "$PRUNNED_IN_SITES
echo "prunning VCF"

plink --vcf $VCF_FILE \
--double-id \
--freq \
--allow-extra-chr \
--extract $PRUNNED_IN_SITES.prune.in \
--make-bed \
--pca \
--geno \
--recode vcf \
--out $PRUNNED_VCF

echo "finished prunned vcf" $PRUNNED_VCF.vcf

echo " performing bgzip and tabix" 
bgzip $PRUNNED_VCF.vcf

tabix -p vcf $PRUNNED_VCF.vcf.gz


echo "VCF file pruned and tabix: $PRUNNED_VCF.vcf.gz"

echo "rephasing file"

java -Xmx60000m -jar /projects/jgoncal1/tools/bin/beagle.28Jun21.220.jar \
gt=$PRUNNED_VCF.vcf.gz \
out=$OUTFILE

echo "VCF file rephased : $PRUNNED_VCF.vcf.gz"
echo "performing final tabix"

tabix -p vcf $OUTFILE.vcf.gz

echo "VCF file zipped, rephased, tabix and ready $OUTFILE.vcf.gz"

echo "removing intermideate lifes"
ls ../data/processed/tmp_*
rm ../data/processed/tmp_*

echo "DONE"


