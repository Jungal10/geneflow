#!/bin/bash -l
#SBATCH -D /scratch/asingh3/Fastsimcoal2/MODELS
#SBATCH -o /scratch/asingh3/Fastsimcoal2/MODELSlogs/Fastsimcoal-4popSplit-1migration-Log-%j.txt
#SBATCH -e /scratch/asingh3/Fastsimcoal2/MODELS/logs/Fastsimcoal-4popSplit-1migration-Log-%j.err
#SBATCH -t 2-12:00:00
#SBATCH -J 4pop-Split-1migration
#SBATCH --partition=smp-rh7
#SBATCH --cpus-per-task=5
#SBATCH --mem 96g
#SBATCH --array=0-99
#SBATCH --mail-type=ALL # if you want emails, otherwise remove
#SBATCH --account=UniKoeln
#SBATCH --mail-user=asingh3@uni-koeln.de # receive an email with updates


PREFIX="4PopSplit-1migration"
   mkdir ${PREFIX}_run$SLURM_ARRAY_TASK_ID
   cp ${PREFIX}.tpl ${PREFIX}.est ${PREFIX}_jointMAFpop*.obs ${PREFIX}_run$SLURM_ARRAY_TASK_ID"/"
   cd ${PREFIX}_run$SLURM_ARRAY_TASK_ID
   /home/asingh3/TOOLS/fsc27_linux64/fsc27093 -t ${PREFIX}.tpl -n200000 -m -e ${PREFIX}.est -M -L 40  -C 10 -c 4 --removeZeroSFS
   cd ..

