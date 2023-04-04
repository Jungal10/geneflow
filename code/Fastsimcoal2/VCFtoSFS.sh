  #### exculde all sites that lie in genic region
 vcftools --gzvcf ready_dovcf_geneflowsamples_all_chr.vcf.gz --recode-INFO-all --recode --stdout --exclude-bed Ahypochondriacus_459_v2.1.gene.gff3.bed | bgzip -c > ready_dovcf_geneflowsamples_all_chr_NOGENES.vcf.gz
# Subsample vcf for the individuals to be used in demography inference - here hypochondriacus, caudatus, hybridus_CA, hybridus_SA
vcftools --gzvcf ready_dovcf_geneflowsamples_all_chr_NOGENES.vcf.gz --keep 4Pop.txt --recode --recode-INFO-all --out ready_dovcf_geneflowsamples_all_chr_NOGENES.4POP

#### preview mode of easysFS for converting vcf to SFS
python easySFS/easySFS -i ready_dovcf_geneflowsamples_all_chr_NOGENES.4POP.recode.vcf -p 4Pop.txt --preview

##### Generate the SFS files to be used by fastsimcoal2
 python easySFS/easySFS.py -i ready_dovcf_geneflowsamples_all_chr_NOGENES.4POP.recode.vcf -p 4Pop.txt -a --proj=10,8,42,66 -o SFS_Input_Files --order hybridus_CA,hybridus_SA,hypochondriacus,caudatus
#### Rename and copy the input files in respective directories for respective models and parameter files to be used for fastsimcoal2

