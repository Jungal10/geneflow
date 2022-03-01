#!/bin/bash -l
#SBATCH --cpus-per-task=10
#SBATCH --partition=smp-rh7 
#SBATCH --mail-type=ALL
#SBATCH --time=12:00:00
#SBATCH --mem=42gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/prepare_windows_twisst_sc16_%j
#SBATCH -o /scratch/jgoncal1/logs/prepare_windows_twisst_sc16_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/
#SBATCH --job-name="prepare_windows_twisst_sc16_"



source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd 

export PYTHONPATH=$PYTHONPATH:/projects/jgoncal1/tools/bin/genomics_general/


echo "Preparing vcf for being using in S.Martin pipleine"


bcftools filter --set-GTs . ../data/processed/vcf_files/filtered_full_genome.vcf.gz -O u | bcftools view -U -i 'TYPE=="snp" & MAC >= 2' -O z > ../data/processed/vcf_files/filtered_full_genome.vcf.gz

#requites a tabix file


echo "conversion to genotype fomrmat (slow for bigger files)"

python /projects/jgoncal1/tools/bin/genomics_general/VCF_processing/parseVCF.py -i ../data/processed/twisst/filtered_full_genomeScaffold_16.vcf.gz --skipIndels | gzip > ../data/processed/filtered_full_genomeScaffold_16.geno.gz



python /projects/jgoncal1/tools/bin/genomics_general/phylo/phyml_sliding_windows.py -T 10 -g ../data/processed/filtered_full_genome.geno.gz -p ../data/processed/remake_output.phmyl.w100  -w100  --windType sites --model GTR --optimise n


python twisst.py -t remake_output_Sc16_full_genome.phmyl.w100.trees.gz -wremake_output_Sc16_full_genome.phmyl.w100.data.tsv  --outputTopos trees_output_scaffold16  -g caudatus -g cruentus -g hypochondriacus -g hybridus_CA -g hybridus_SA -g quitensis --outgroup ERR3220318_A,  --outgroup ERR3220318_B --groupsFile ../../../code/file_lists/samples_geneflow_B.txt
