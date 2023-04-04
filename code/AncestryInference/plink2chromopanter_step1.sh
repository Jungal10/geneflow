#!/bin/bash -l
#SBATCH --partition=smp-rh7
#SBATCH --time=4:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --mail-type=ALL
#SBATCH --error /scratch/jgoncal1/logs/errors/reocde_full_genome_plink2cp_%j
#SBATCH -o /scratch/jgoncal1/logs/reocde_full_genome_plink2cp_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="reocde_full_genome_plink2cp_" # a nice readable name to give your job so you know what it is when you see it in the queue, instead of just numbers

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd



VCF_FILE='../data/output/ready_dovcf_geneflowsamples_all_chr.vcf.gz'

OUTFILE='../data/processed/plink_ready_dovcf_geneflowsamples_all_chr'

# for i in {1..16}; 
# do

# plink --vcf ../data/processed/vcf_files/q1ready_dovcf_geneflowsamples_Scaffold_${i}.vcf.gz \
# --double-id \
# --allow-extra-chr \
# --mind 0.7 \
# --recode 12 \
# --maf 0.02 \
# --out ../data/processed/fscp_input_files/plink_geneflowsamples_Scaffold_${i}

# done

plink --vcf $VCF_FILE \
--double-id \
--allow-extra-chr \
--mind 0.7 \
--recode 12 \
--maf 0.02 \
--out $OUTFILE
