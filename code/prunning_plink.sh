#!/bin/bash -l
#SBATCH --partition=devel
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/prun_plink_treemix_%j
#SBATCH -o /scratch/jgoncal1/logs/prun_plink_treemix_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/GeneFlow/code/




VCF_FILE='../data/processed/pahsein_vcf_all_unprunned.vcf.gz'
CLUST_FILE='../data/processed/list_files/all_121_samples_species.clust'
PRUNE_IN_FILE="../data/processed/prunned_pahsein_vcf_all_unprunned.prune.in"
OUTFILE='../data/processed/annotated_prunned_pahsein_vcf_all_unprunned'



plink --vcf $VCF_FILE \
--double-id \
--freq \
--allow-extra-chr \
--extract $PRUNE_IN_FILE \
--within $CLUST_FILE \
--make-bed \
--pca \
--geno \
--mind 0.7 \
--recode vcf \
--out $OUTFILE


``