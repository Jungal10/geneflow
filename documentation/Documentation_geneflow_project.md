# Documentation gene flow project

## Table of Contents

- [Documentation gene flow project](#documentation-gene-flow-project)
  - [Table of Contents](#table-of-contents)
  - [Data sampling](#data-sampling)
  - [Variant Calling](#variant-calling)
    - [Create VCF file](#create-vcf-file)
    - [Data phasing](#data-phasing)
  - [Global gene flow](#global-gene-flow)
    - [ABBA BABA](#abba-baba)
      - [per individual ABBA BABA](#per-individual-abba-baba)
      - [per popualtion ABBA BABA](#per-popualtion-abba-baba)
  - [Local Gene Flow](#local-gene-flow)
    - [D-suite](#d-suite)
      - [Dtrios: D and f4-ratio](#dtrios-d-and-f4-ratio)
      - [Dinvestigate: fd, fdM and f-branch statistics](#dinvestigate-fd-fdm-and-f-branch-statistics)



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

The output was indexed using ```tabix -p vcf $VCF_FILE```


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
gt=$prepared_vcf_file \
out=$phasedVCF  
```


## Global gene flow

### ABBA BABA

#### per individual ABBA BABA

- run individual abba-baba


```bash
#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --time=96:00:00
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/ind_abba_sc9_500kb_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/sandbox/
#SBATCH -o /scratch/jgoncal1/logs/ind_abba_sc9_500kb_%j

source /home/jgoncal1/.bashrc
module load gnu/4.8.2
INPUT_BAM='../data/raw/list_109int_tubercualtus_ERR3220318.file.list'
OUTPUT_FILE='../data/processed/ind_abba_110_ERR3220318.file.list.Angsd'


~/angsd/angsd -doAbbababa 1 \
-bam $INPUT_BAM \
-doCounts 1 \
-out $OUTPUT_FILE \
-blockSize 500000 \
-useLast 1 \
-rf ../data/raw/ch9 \
-checkBamHeaders 0 \
-nInd 110 \
-minQ 20 \
-remove_bads 1 \
-minMapQ 30 \
-minInd 76 
```


- Run Rscript to convert results  into understandable output

``` bash
#!/bin/bash -l
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=24gb#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/ind_R_abba_sc9_%j
#SBATCH -o /scratch/jgoncal1/logs/ind_R_abba_sc9_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/sandbox/
source /home/jgoncal1/.bashrc

# module load gnu/7.4.0
module load R


Rscript ~/angsd/R/jackKnife.R file=../data/processed/ind_abba_region_smalllist_ERR3220318_1M.file.list.Angsd.abbababa \
indNames=../data/raw/list_small_for_tests_R.file.list \
outfile=../data/processed/ind_abba_region_smalllist_ERR3220318_1M_R
```





#### per popualtion ABBA BABA

```bash
#!/bin/bash -l
#SBATCH --cpus-per-task=6
#SBATCH --mem=21gb
#SBATCH --time=4:00:00
#SBATCH --account=UniKoeln
#SBATCH --error /scratch/jgoncal1/logs/errors/%j
#SBATCH -D /projects/ag-stetter/jdias/projects/geneflow/data/processed/
#SBATCH -o /scratch/jgoncal1/logs/%j

source /home/jgoncal1/.bashrc
module load gnu/4.8.2
INPUT_BAM='/projects/ag-stetter/jdias/projects/geneflow/data/raw/109int_tubercualtus_ERR3220406.file.list'
SIZE_FILE='/projects/ag-stetter/jdias/projects/geneflow/data/processed/size_cau_cru_hybCA_hybSA_hyp_qui.size'
OUTPUT_FILE='/projects/ag-stetter/jdias/projects/geneflow/data/processed/109int_tubercualtus_ERR3220406'
ANCESTRAL=''```
~/angsd/angsd -doAbbababa2 1 \
-bam $INPUT_BAM \
-sizeFile $SIZE_FILE \
-doCounts 1 \
-out $OUTPUT_FILE \
-useLast 1 \
-rf /projects/ag-stetter/jdias/projects/geneflow/sandbox/ch1.txt \
-checkBamHeaders 0 \
-minQ 20 \
-minMapQ 30
```

## Local Gene Flow

### D-suite

#### Dtrios: D and f4-ratio

Requirments:

- text file (sets.txt) with sample-name\tpopulation
Should have the outgroup population written as "Outgroup".
- windows size (e.g 10000, 100) Windows of 10kb with a 100bp sliding window)

#### Dinvestigate: fd, fdM and f-branch statistics

Requires aditionally:
- test_trios.txt file for Dinvestigate. One trio of populations/species per line, separated by a tab in the order P1 P2 P3.


```bash
Dsuite Dinvestigate $VCF_FILE  sets.txt  test_trios.txt -w 10000,1
```
