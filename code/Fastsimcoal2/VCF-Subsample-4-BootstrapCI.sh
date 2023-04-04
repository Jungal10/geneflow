######## Subsample vcf file for bootstrapping each having ~1Million sites


PREFIX="ready_dovcf_geneflowsamples_all_chr_NOGENES.4POP.recode"
# Get all positions from the vcf removing header
grep -v "^#" $PREFIX.vcf > $PREFIX.allSites

# Get the header to merge later with each of the subsamples vcf files
grep "^#" $PREFIX.vcf > header

split -l 100000 $PREFIX.allSites $PREFIX.sites.

## Generate 50 vcf files each with randomly concatenated blocks and compute the SFS for each:
for i in {1..50}
do
  mkdir bs$i
  cd bs$i
  cat ../header > $PREFIX.bs.$i.vcf

  for r in {1..100}
  do
    cat `shuf -n1 -e ../$PREFIX.sites.*` >> ${PREFIX}.bs.$i.vcf
  done
  gzip ${PREFIX}.bs.$i.vcf

  # Make an SFS from the new bootstrapped file
  python easySFS/easySFS.py -i ${PREFIX}.bs.$i.vcf.gz -p ../4Pop.txt --order hybridus_CA,hybridus_SA,hypochondriacus,caudatus -a -f --proj 10,8,42,66 
  cp ${PREFIX}_jointDAFpop1_0.obs  ${PREFIX}.bs.${i}_jointDAFpop1_0.obs
  cd ..
done


