#!/bin/bash -l
#SBATCH --partition=devel-rh7
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=46gb
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/reocde12_plink2cp_full_genome_%j
#SBATCH -o /scratch/jgoncal1/logs/reocde12_plink2cp_full_genome_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/code/




# for i in {1..16};
# do

# /projects/jgoncal1/tools/bin/fs_4.1.1/plink2chromopainter.pl \
# -p ../data/processed/fscp_input_files/plink_geneflowsamples_Scaffold_${i}.ped \
# -m ../data/processed/fscp_input_files/plink_geneflowsamples_Scaffold_${i}.map \
# -o ../data/processed/fscp_input_files/plink_geneflowsamples_Scaffold_${i}.phase

# done



PED_FILE="../data/processed/plink_ready_dovcf_geneflowsamples_all_chr.ped"
MAP_FILE="../data/processed/plink_ready_dovcf_geneflowsamples_all_chr.map"
OUTPUT_FILE="../data/processed/plink_ready_dovcf_geneflowsamples_all_chr.phase"


/projects/jgoncal1/tools/bin/fs_4.1.1/plink2chromopainter.pl \
-p $PED_FILE
-m $MAP_FILE
-o $OUTPUT_FILE
