# Documentation gene flow project

## Table of Contents

- [Documentation gene flow project](#documentation-gene-flow-project)
  - [Table of Contents](#table-of-contents)
  - [Data sampling](#data-sampling)
  - [Variant Calling](#variant-calling)
    - [Create VCF file](#create-vcf-file)
    - [Data phasing](#data-phasing)




## Data sampling

For the stufy a total of 108 samples were included — 33 *A. caudatus*, 21 *A. cruentus*, 5 *A. hybridus* from Central America, 4 *A. hybridus* from South America, 21 *A. hypochondriacus*. 24 *A. quitensis*. The resquncing data was obtaqined from Stetter et.a, 2020. Furhtermore, 1 individual was used as the outgroup, *A. tuberculatus*. The fastq file was obtained from Kreiner et al., 2019 and later aligned with the amaranth reference genome (Lightfoot et.al 2017) using bwa-mem.

Full list of samples available [here](https://docs.google.com/spreadsheets/d/1c-KKXu28MmEhc_AtrKWpN_J8-6mtg-mLBQvmc0PgugE/edit?usp=sharing)


## Variant Calling

### Create VCF file

For calling variants, ANGSD v.0921 (Korilussen et. al 2014) was used.

Current parameters (still running out of memory)

- **b** -> file with the paths for the bam files in use (preferentialy use the outgroup as last)
- **out** -> output file prefix name
- **ref** -> file with the fast file for the reference  genome (used A. hypochondriacus from Lightfoot et. al 2017)
- **doCounts 1** -> count the number of A,C,G,T. All sites, All samples — necessary for filtering 
- **doGeno 3** -> call minor and major genotypes and print the called genotype 
- **dovcf 1**-> outputs a vcf file (wrapper around -gl -dopost -domajorminor -domaf)
- **gl 2** -> calculaiute genotype likelihhod based on GATK method 
- **dopost 2**  -> estimate the posterior genotype probability assuming a uniform prior 
- **domajorminor 1**-> assume diallelic sites. Infers major and minor alle from Genotype Likelihood 
- **domaf 1**  -> relative allele frquency of an allele dor a site. Utilizes major and minor alleles defined by domajorminor and gl
- **checkBamHeaders 0** -> skip BAM header verification. Usefull when combining bam files form different origins (such as tubarcualtus)
- **minInd 73** -> mininum number of individuals with the defgined setMinDepthInd (default 1) 
- **minQ 20** -> minimum base quality score 
- **minMapQ 30** -> miminum mapping quality 
- **only_proper_pairs 1** Include only proper pairs (pairs of read with both mates mapped correctly
- **trim 0**  -> Number of based to discard at both ends of the reads ;
- **SNP_pval 1e-6** 
- **C 50** -> Adjust mapQ for excessive mismatches \
- **setMaxDepthInd 150** -> Discard site if individual depth is above 150.
- **setminDepth 73** -> Discard individual if sequencing depth for an individual is below 73 (combined with minIND 73, means that at least a minimum 73 individuals with a indDepth of 1 would be consdered)

The output was indexed using tabix


*Previously used parameters (including all WGS samples and multiple outgroups on the vcf file)*

```bash
angsd -b $INPUT_BAM \
-P 5 \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-remove_bads 1 \
-only_proper_pairs 1 \
-trim 0  \
-C 50  \
-minMapQ 30 \
-minQ 30 \
-doCounts 1 \
-setMinDepth 5 \
-setMaxDepth 150 \
-doGeno 3 \
-dovcf 1 \
-gl 2 \
-dopost 2 \
-domajorminor 1 \
-domaf 1 \
-snp_pval 1e-6 \
-checkBamHeaders 0 \
-out $OUTPUT_FILE
```

It output 1,776,146 sites, distributed this way per chromossome:

 165,675 Scaffold_1
 103,119 Scaffold_10
 104,534 Scaffold_11
 103,542 Scaffold_12
  98,028 Scaffold_13
  81,469 Scaffold_14
  75,238 Scaffold_15
  73,733 Scaffold_16
 151,870 Scaffold_2
 128,947 Scaffold_3
 123,464 Scaffold_4
 112,882 Scaffold_5
 113,046 Scaffold_6
 102,703 Scaffold_7
 101,294 Scaffold_8
 104,457 Scaffold_9


### Data phasing

For dataphasing, Beagle(v5.2) was used using the following command:

```bash
java -Xmx60000m -jar ../../../tools/beagle.29May21.d6d.jar \
gt=prepared_vcf_file \
out=phasedVCF  
```
