# Documentation gene flow project

## Table of Contents

- [Documentation gene flow project](#documentation-gene-flow-project)
  - [Table of Contents](#table-of-contents)
  - [Data sampling](#data-sampling)
  - [Variant Calling](#variant-calling)
    - [Create VCF file](#create-vcf-file)
    - [VCF file created by angsd assigns wrongly the individuals names.](#vcf-file-created-by-angsd-assigns-wrongly-the-individuals-names)
    - [Data phasing](#data-phasing)
    - [Subsample and filtering](#subsample-and-filtering)
  - [Global gene flow](#global-gene-flow)
    - [ABBA BABA](#abba-baba)
      - [per individual ABBA BABA](#per-individual-abba-baba)
      - [per popualtion ABBA BABA](#per-popualtion-abba-baba)
  - [Local Gene Flow](#local-gene-flow)
    - [D-suite](#d-suite)
      - [Dtrios: D and f4-ratio](#dtrios-d-and-f4-ratio)
      - [Dinvestigate: fd, fdM and f-branch statistics](#dinvestigate-fd-fdm-and-f-branch-statistics)
    - [Topology and twisst](#topology-and-twisst)
  - [Linkage Desiquilibrium](#linkage-desiquilibrium)
    - [popLDecay](#popldecay)
  - [Treemix](#treemix)
    - [File preparation](#file-preparation)



## Data sampling

For the study a total of 108 samples were included — 33 *A. caudatus*, 21 *A. cruentus*, 5 *A. hybridus* from Central America, 4 *A. hybridus* from South America, 21 *A. hypochondriacus*. 24 *A. quitensis*. The resequencing data was obtained from Stetter et.a, 2020. Furthermore, 1 individual was used as the outgroup, *A. tuberculatus*. The fastq file was obtained from Kreiner et al., 2019 and later aligned with the amaranth reference genome (Lightfoot et.al 2017) using bwa-mem.



## Variant Calling

### Create VCF file

For calling variants, ANGSD v.0921 (Korilussen et. al 2014) was used.

- **b** -> file with the paths for the bam files in use (preferentially use the outgroup as last) ```list_bam_files_geneflow_tuberculatus.txt```
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
- **setMaxDepthInd 150** -> Discard site if individual depth is above 150.
- **setminDepth 73** -> Discard individual if sequencing depth for an individual is below 73 (combined with minIND 73, means that at least a minimum 73 individuals with a indDepth of 1 would be consdered)

The output was indexed using ```tabix -p vcf $VCF_FILE```

Previous results:

It output XXX sites, distributed this way per chromossome:



### VCF file created by angsd assigns wrongly the individuals names.
To fix this:

- run bcftools reheader (It will output a BCF file)
```bash
 bcftools reheader -s $SAMPLES_LIST $VCF_FILE > $FIXED_BCF_FILE
``` 
tabix the file:

```bash
tabix -p bcf $BCF_FILE
```


### Data phasing

convert bcf to vcf.gz and tabix for phasing
```bash
bcftools view reheader_dovcf_geneflowsamples_sc16.bcf -O z -o reheader_dovcf_geneflowsamples_sc16.vcf.gz

tabix -p vcf $VCFgzFILE
```



For dataphasing, Beagle(v5.2) was used using the following command:

```bash
java -Xmx60000m -jar ../../../tools/beagle.29May21.d6d.jar \
gt=$prepared_vcf_file \
out=$phasedVCF  
```

### Subsample and filtering

If a subsampling of the VCF is necessary, it can be done with: (requires a list of tha desired samples. Name smust matach with the ones on the header of the VCF. This can be obtained wusing `bcftools qury -l $VCF_FILE`)
```bash
bcftools view -Oz -S data/raw/samples_introgression_109 data/raw/variant_calls/all_pop.vcf.gz --force-samples -m2  > data/processed/bcf_susbet_force_109.vcf.gz
```

## Global gene flow

### ABBA BABA
Calcualtes D-statistic as an estimation of correctness of a 4-branched tree. H1 and H2 are inner nodes, H3 the potential "donor\recipient" of gene flow and H4 as an outgroup. 

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
-checkBamHeaders 0 \
-minQ 30 \
-remove_bads 1 \
-minMapQ 30 \
-minInd 76 
-only_proper_pairs 1 \
-trim 0 \
-setMinDepth 73 \
-setMaxDepthInd 150 
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
-blockSize 500000 \
-useLast 1 \
-checkBamHeaders 0 \
-minQ 30 \
-remove_bads 1 \
-minMapQ 30 \
-minInd 76 
-only_proper_pairs 1 \
-trim 0 \
-setMinDepth 73 \
-setMaxDepthInd 150 
```

## Local Gene Flow

### D-suite

#### Dtrios: D and f4-ratio

Requirments:

- text file (*sets.txt*) with sample-name\tpopulation
Should have the outgroup population written as "Outgroup".
- windows size (e.g 10000, 100) Windows of 10kb with a 100bp sliding window)

#### Dinvestigate: fd, fdM and f-branch statistics

Requires aditionally:
- file *test_trios.txt* for Dinvestigate. One trio of populations/species per line, separated by a tab in the order P1 P2 P3.

```bash
Dsuite Dinvestigate $VCF_FILE  sets.txt  test_trios.txt -w 10000,1
```

### Topology and twisst

For topology inference:

**Requirements:**
- VCF file
- [genomics_general](https://github.com/simonhmartin/genomics_general)
- [twisst](https://github.com/simonhmartin/twisst)
- [ete3](http://etetoolkit.org/download/)
- numpy 

`PYTHON_PATH` must point to the genomics_general folder

**Steps:**
- preparation of VCF file to be accepted by simon_martin VCF parser:

`twisst_01_vcf_prep.sh`

```bash
source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate ete3

export PYTHONPATH=$PYTHONPATH:/projects/jgoncal1/tools/bin/genomics_general/

echo "Preparing vcf for being using in S.Martin pipleine"

VCF_FILE="../data/processed/vcf_files/filtered_full_genome.vcf.gz"
OUTPUT_FILTERED_FILE="../data/processed/vcf_files/filtered_full_genome.vcf.gz"

bcftools filter --set-GTs . $VCF_FILE -O u | bcftools view -U -i 'TYPE=="snp" & MAC >= 2' -O z > $OUTPUT_FILTERED_FILE

#requites a tabix file
```




### Finescture and Chromossome Painting

#### file preparation and setup
- prepare recombfile. If not recombiantion map is available, make uniform recombinatoin file using:

```perl ../../../../tools/bin/fs_4.1.1/makeuniformrecfile.pl  phased_plink_file out_recomb```

- create plink file from phased VCF:

```plink2chromopainter_step1.sh```

```bash
VCF_FILE='../data/processed/phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.vcf.gz'

OUTFILE='../data/processed/plink_phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005'

for i in {1..16}; 
do

plink --vcf ../data/processed/VCF_subset_introgression108_Scaffold_${i}.recode.vcf \
--double-id \
--allow-extra-chr \
--mind 0.7 \
--recode 12 \
--out ../data/processed/plink_phased_VCF_introgression108_Scaffold_${i}

done
```

- convert plink files to chrompainter format

```plink2chromopainter_step2.sh```


- prepare recombfile. If not recombiantion map is available, make uniform recombinatoin file using:

```perl ../../../../tools/bin/fs_4.1.1/makeuniformrecfile.pl  phased_plink_file out_recomb```




After Chrompainter ran through:
#### plot haplotypes

**prepare input files for R**

- split output haplotype file by each haplotype:

```bash
csplit -f hap_files/sc16_haplotypes -z <(gunzip -c cp2_withf_geneflow_spithyb_sc16.hap1.copyprobsperlocus.out.gz)  /HAP/ '{*}' 
```

- transform split files into naming recognized by the Rscript. This script will search for the "HAP 1" pattern on the file and create a seaprate file for each haplotype and each species. It is prepared for being recogneized by the further Rscript.

```parsefile.sh```


## Linkage Desiquilibrium
### popLDecay


- Calculate Linkage Desquiblibrium decay until a window of maximuim 300kb. Note: It should be performed as well for smaller window sizes (10-15kb and 50kn for allowing a better overview of the decay)

```bash
VCF_FILE='../data/output/reheader_filtered_angsd_vcf_file.vcf.gz' # input VCF file
OUTPUT_FILE='../data/processed/LDdecay_hypochondriacus' #output_name
SUB_POP='../data/raw/samples_int_hypochondriacus' # list of samples for the subpopulation bein evaluated 

PopLDdecay -InVCF $VCF_FILE -OutStat $OUTPUT_FILE -SubPop $SUB_POP -MaxDist 300
```

- plot (requites a Multipoplist : list of *stat.gz files generated for each file and its corresponding population for plotting. e.g. `/path/to/file/caudatus.stats.gz"\t"caudatus`


```bash
perl ../../../tools/PopLDdecay/bin/Plot_MultiPop.pl -inList ../data/processed/Multipoplist -output all_species_LD
```



## Treemix
### File preparation
- Create clust file using the format "SampleName"\t"SampleName"\t"Species"
- Use plink to generate stratified frequencies file
`plink_clust.sh`

```bash

source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd


VCF_FILE="../data/processed/filtered_reheader_prnned_sc16.vcf.gz"
CLUST_FILE="file_lists/samples_geneflow_no_outgroup.clust"

plink --vcf $VCF_FILE \
--double-id \
--freq \
--allow-extra-chr \
--within $CLUST_FILE \
--make-bed \
--pca \
--geno \
--mind 0.7 \
--out ../data/processed/clust_annotated_filtered_reheader_prunned_sc16

```
gzip freq file
```

- Convert plink2treemix

```bash
python2.7 /projects/jgoncal1/tools/plink2treemix.py data/processed/plink_prunned/freqs_treemix_pop.frq.gz data/processed/treemix_input.gz
```

Note: In case of error:
Remove "Scaffold_" for preventing ```plink2treemix` parsing errors

```bash
sed 's/Scaffold_//g' $strat_file > $fixed_start_file
```

- run treemix `treemix.sh`

```bash
source /home/jgoncal1/.bashrc
module load miniconda/py38_4.9.2
conda activate base_jgd
module load gnu/7.4.0

for i in {0..6};
do
treemix -i  ../data/processed/treemix_input.gz -k 500 -m $i -o ../data/processed/treemix_output_$i 
done

```

- For plotting:

Use the source code avialble [here](https://rdrr.io/github/andrewparkermorgan/popcorn/src/R/treemix.R)
Note: To acmcomdate labels within the plot boundaries , I altered the code for the geom_text (l.105):
`    p <- p + ggplot2::geom_text(ggplot2::aes(x = xo, y = y, label = pop), vjust="inward",hjust="inward")`

```R
source(file = "/path/to/treemix.R")
tree<-read_treemix("treemix_output")
plot_treemix(tree) 
```