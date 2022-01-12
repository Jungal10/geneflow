To create a VCF FILE with angsd:

install version 0.921

**Parameters:**
- b -> file with the paths for the bam files in use (preferentialy use the outgroup as last)
- out -> output file prefix name
- ref -> file with the fast file for the reference  genome (used A. hypochondriacus from Lightfoot et. al 2017)
- doCounts 1 -> count the number of A,C,G,T. All sites, All samples — necessary for filtering 
- doGeno 5 -> call minor and major genotypes and print the called genotype 
- dovcf 1 -> outputs a vcf file (wrapper around -gl -dopost -domajorminor -domaf)
- gl 2 -> calculaiute genotype likelihhod based on GATK method 
- dopost 2  -> estimate the posterior genotype probability assuming a uniform prior 
- domajorminor 1 -> assume diallelic sites. Infers major and minor alle from Genotype Likelihood 
- domaf 1  -> relative allele frquency of an allele dor a site. Utilizes major and minor alleles defined by domajorminor and gl
- checkBamHeaders 0 -> skip BAM header verification. Usefull when combining bam files form different origins (such as tubarcualtus)
- minInd 73 -> mininum number of individuals with the defgined setMinDepthInd (default 1) 
- minQ 20 -> minimum base quality score 
- minMapQ 30 -> miminum mapping quality 
- only_proper_pairs 1 Include only proper pairs (pairs of read with both mates mapped correctly
- trim 0  -> Number of based to discard at both ends of the reads ;
- SNP_pval 1e-6 
- C 50 -> Adjust mapQ for excessive mismatches \
- setMaxDepth 1500 -> Discard site if total sequencing depth (all individuals added together) is above 1500 (mean + 2SD)
- setminDepth -> Discard individual if sequencing depth for an individual is below 73 (combined with minIND 73, means that at least a minimum 73 individuals with a indDepth of 1 would be consdered)

