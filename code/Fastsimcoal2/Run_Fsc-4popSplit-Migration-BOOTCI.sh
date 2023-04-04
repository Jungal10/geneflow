#!/bin/bash -l
#SBATCH -D /scratch/asingh3/Fastsimcoal2/VCF-Subsample-Boot/
#SBATCH -o /scratch/asingh3/Fastsimcoal2/VCF-Subsample-Boot/logs/BOOT_CI_Estimation-Log-%j.txt
#SBATCH -e /scratch/asingh3/Fastsimcoal2/VCF-Subsample-Boot/logs/BOOT_CI_Estimation-Log-%j.err
#SBATCH -t 20-24:00:00
#SBATCH -J Boot_CI_Estimation
#SBATCH --partition=smp-rh7
#SBATCH --mem 8g
#SBATCH --array=1-50
#SBATCH --mail-type=ALL # if you want emails, otherwise remove
#SBATCH --account=UniKoeln
#SBATCH --mail-user=asingh3@uni-koeln.de # receive an email with updates


PREFIX="4PopSplit-migration_bootCI"
   cd bs$SLURM_ARRAY_TASK_ID
   for Rep in {1..50}
     do
       mkdir run${Rep}
       cp ${PREFIX}.tpl ${PREFIX}.est ${PREFIX}_jointMAFpop*.obs run${Rep}"/"
       cd run${Rep}
   /home/asingh3/TOOLS/fsc27_linux64/fsc27093 -t ${PREFIX}.tpl -n200000 -m -e ${PREFIX}.est -M -L 40  -C 10 -c 4 --removeZeroSFS
   cd ..
   done

