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


bcftools filter --set-GTs . ../data/processed/reheader_prunned_sc16.vcf.gz -O u | bcftools view -U -i 'TYPE=="snp" & MAC >= 2' -O z > ../data/processed/filtered_reheader_prunned_sc16.vcf.gz

python parseVCF.py -i filtered_reheader_prunned_sc16.vcf.gz --skipIndels| gzip > output_filtered_reheader_prunned_sc16.geno.gz

python phyml_sliding_windows.py -T 10 -g input.phased.geno.gz --prefix output.phyml_bionj.w50 -w 50 --windType sites --model GTR --optimise n



python twisst.py -t output.sc16_withoutgroup.phyml_bionj.w50.trees.gz -w weights_output.sc16_withoutgroup.csv.gz --outputTopos trees_output.sc16_withoutgroup  -g caudatus -g cruentus -g hypochondriacus -g hybridus_CA -g hybridus_SA -g quitensis --outgroup ERR3220318_A --groupsFile ../../code/file_lists/samples_twist_tuberculatus
