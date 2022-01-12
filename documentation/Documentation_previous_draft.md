# Documentation introgression project

## Table of Contents

- [Documentation introgression project](#documentation-introgression-project)
  - [Table of Contents](#table-of-contents)
  - [Convert VCF to treemix from bam file](#convert-vcf-to-treemix-from-bam-file)
  - [Treemix calculations](#treemix-calculations)
    - [f3](#f3)
    - [f4](#f4)
    - [treeemix](#treeemix)
  - [Linkage Desquiquilibrium](#linkage-desquiquilibrium)
    - [PopLDecay](#popldecay)
  - [ABBA BABA](#abba-baba)
    - [per individual ABBA BABA](#per-individual-abba-baba)
    - [per popualtion ABBA BABA](#per-popualtion-abba-baba)
    - [Data Phasing](#data-phasing)
      - [From VCF file](#from-vcf-file)
  - [Finestrcuture and Chromopainter](#finestrcuture-and-chromopainter)
    
  - [Finestructure and Chromopainter](#finestrcuture-and-chromopainter)

## Convert VCF to treemix from bam file

- Create VCF file with angsd: 
Needs version 0.921 to work

Creata an env for conda and install correct angsd version
```conda create -n angsd_env angsd+0.921```
Extra packages
```conda install -c bioconda htslib ```
```conda install -c anaconda bzip2 ```

In case of any error on libssl or lybcrypto or simlair, it is necessary to get to the conda library and create a symlink for the necessary version. Example:

```cd /projects/ag-stetter/jdias/tools/miniconda3/lib ```
```ln -s libssl.so.1.1 libssl.so.1.0.0```




```bash
source /home/jgoncal1/.bashrc
conda activate angsd_env

INPUT_BAM='file_lists/list_bam_files_geneflow_tuberculatus.txt'
OUTPUT_FILE='../data/processed/angsd_dovcf_108_samples_allchr_depth1500_maxmem_time'


angsd -b $INPUT_BAM \
-out $OUTPUT_FILE \
-ref ../data/raw/genomes/Ahypochondriacus_459_v2.0.fa \
-doCounts 1 \
-doGeno 3 \
-dovcf 1 \
-gl 2 \
-dopost 2 \
-domajorminor 1 \
-domaf 1 \
-checkBamHeaders 0 \
-minInd 73 \
-minQ 20 \
-minMapQ 30 \
-only_proper_pairs 1 \
-trim 0  \
-SNP_pval 1e-6 \
-C 50 \
-setMaxDepth 1500 
```
 
```
bgzip and tabix
```

- Annotate file for being parsed correctly on plink

```bash
VCF_FILE=''
ANNOTATED_VCF_FILE=''

bcftools annotate --set-id +'%CHROM\_%POS' \ $VCF_FILE \ -o $ANNOTATED_VCF_FILE
```

Prune vcf to correct for linkage desiquilibrium:

```bash
VCF='../data/processed/VCF_files/anno_angsd_vcf_file.vcf.gz'
plink --vcf $ANNOTATED_VCF_FILE --double-id --allow-extra-chr 
--indep-pairwise 50 5 0.3 --out $PRUNEED_ANNOTATED_VCF_FILE
```

- Create clust file using the format "SampleName"\t"SampleName"\t"Species"

- Use plink to generate stratified frequencies file
`plink_treemix_prunning.sh`

```bash
PRUNNED_ANNOTATED_VCF_FILE='data/processed/VCF_files/anno_angsd_vcf_file.vcf.gz'

plink --vcf $PRUNNED_ANNOTATED_VCF_FILE 
--double-id 
--freq 
--allow-extra-chr 
--extract data/processed/prunned_anno_angsd_vcf_file_50_5_03.prune.in 
--within data/processed/anno_angsd.clust 
--make-bed 
--pca 
--geno 
--mind 0.7 
--out data/processed/plink_prunned/prunned_anno_angsd_vcf_file_50_5_031
```

- Remove "Scaffold_" for preventing ```plink2treemix` parsing errors

```bash
sed 's/Scaffold_//g' prunned_anno_angsd_vcf_file_50_5_03.frq.strat > freqs_treemix_pop.frq
gzip freq file
```

- Convert plink2treemix

```bash
python2.7 /projects/ag-stetter/jdias/tools/plink2treemix.py data/processed/plink_prunned/freqs_treemix_pop.frq.gz data/processed/treemix_input.gz
```

## Treemix calculations

### f3

Run threepop:

```bash
threepop -i data/processed/treemix_input/gz -k 1000 > data/processed/treemix_output/three_pop_output
```

Output format:

populations used to calculate the f3 statistic |  f3 statistic |  standard error in the f3 statistic |  Z-score
|--|--|--|--|

### f4

```bash
module load boost

fourpop -i ../data/processed/treemix_input__withoutsed_hybridusT.gz -k 500 > ../data/processed/four_pop_treemix_input__withoutsed_hybridusT
```

### treeemix



## Linkage Desquiquilibrium

### PopLDecay

- Calculate Linkage Desquiblibrium decay until a window of maximuim 300kb

```bash
VCF_FILE='../data/output/reheader_filtered_angsd_vcf_file.vcf.gz'
OUTPUT_FILE='../data/processed/LDdecay_hypochondriacus'
SUB_POP='../data/raw/samples_int_hypochondriacus'

PopLDdecay -InVCF $VCF_FILE -OutStat $OUTPUT_FILE -SubPop $SUB_POP -MaxDist 300
```

- plot (needs a list with "path to file"\t"species")

```bash
perl ../../../tools/PopLDdecay/bin/Plot_MultiPop.pl -inList ../data/processed/multi_pop_list -output all_species_LD
```

## ABBA BABA

### per individual ABBA BABA

- run individual abba-baba


```bash
#!/bin/bash -l
#SBATCH --cpus-per-task=1
#SBATCH --mem=42gb
#SBATCH --time=96:00:00
#SBATCH --account=UniKoeln
#SBATCH --mail-user=jgoncal1@uni-koeln.de
#SBATCH --error /scratch/jgoncal1/logs/errors/ind_abba_sc9_500kb_%j
#SBATCH -D /projects/ag-stetter/jdias/projects/introgression_files/sandbox/
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
#SBATCH -D /projects/ag-stetter/jdias/projects/introgression_files/sandbox/
source /home/jgoncal1/.bashrc

# module load gnu/7.4.0
module load R


Rscript ~/angsd/R/jackKnife.R file=../data/processed/ind_abba_region_smalllist_ERR3220318_1M.file.list.Angsd.abbababa \
indNames=../data/raw/list_small_for_tests_R.file.list \
outfile=../data/processed/ind_abba_region_smalllist_ERR3220318_1M_R
```





### per popualtion ABBA BABA

```bash
#!/bin/bash -l
#SBATCH --cpus-per-task=6
#SBATCH --mem=21gb
#SBATCH --time=4:00:00
#SBATCH --account=UniKoeln
#SBATCH --error /scratch/jgoncal1/logs/errors/%j
#SBATCH -D /projects/ag-stetter/jdias/projects/introgression_files/data/processed/
#SBATCH -o /scratch/jgoncal1/logs/%j

source /home/jgoncal1/.bashrc
module load gnu/4.8.2
INPUT_BAM='/projects/ag-stetter/jdias/projects/introgression_files/data/raw/109int_tubercualtus_ERR3220406.file.list'
SIZE_FILE='/projects/ag-stetter/jdias/projects/introgression_files/data/processed/size_cau_cru_hybCA_hybSA_hyp_qui.size'
OUTPUT_FILE='/projects/ag-stetter/jdias/projects/introgression_files/data/processed/109int_tubercualtus_ERR3220406'
ANCESTRAL=''```
~/angsd/angsd -doAbbababa2 1 \
-bam $INPUT_BAM \
-sizeFile $SIZE_FILE \
-doCounts 1 \
-out $OUTPUT_FILE \
-useLast 1 \
-rf /projects/ag-stetter/jdias/projects/introgression_files/sandbox/ch1.txt \
-checkBamHeaders 0 \
-minQ 20 \
-minMapQ 30
```

### Data Phasing

#### From VCF file 
- Annotate file for being parsed correctly on plink

```bash
VCF_FILE="vcf_file"
OUTPUT_FILE="output_file"

bcftools annotate --set-id +'%CHROM\_%POS' $VCF_FILE
-o $OUTPUT_FILE
```
<!-- 
- Prune vcf to correct for linkage desiquilibrium:

```bash
VCF='VCF_file'
plink --vcf $VCF --double-id --allow-extra-chr 
--indep-pairwise 50 5 0.3 --out ../data/processed/prunned_anno_angsd_vcf_file_50_5_03
```

- correct file as only ATCG REF are accepted (2 steps)
  - 1st

```bash
BFILE='plink_file_prefix'
OUTPUT_FILE="output_file"

plink --bfile $BFILE \
--recode vcf \
--double-id \
--allow-extra-chr \
--list-duplicate-vars ids-only suppress-first \
--out $OUTPUT_FILE
```

  - 2nd 
```bash
BFILE='plink_file_prefixs'
OUTPUT_FILE="output_file"

plink --bfile $BFILE \
--recode vcf \
--double-id \
--allow-extra-chr \
--alleleACGT --snps-only just-acgt \
--exclude plink.dupvar \
--make-bed \
--out $OUTPUT_FILE
``` -->

  - Data phasing with beagle

```bash
java -Xmx60000m -jar ../../../tools/beagle.29May21.d6d.jar \
gt=prepared_vcf_file \
out=phasedVCF  

```

**remaining sites 3,187,856**

## Finestrcuture and Chromopainter


- Subset VCF for the samples (also possible for single chromossome using -chr flag)

```vcftools_susbet.sh```

```bash
vcftools --gzvcf ../data/raw/gatk_filter_maxmissing30_max_biallelic.vcf.gz \
--max-missing 0.7  \
--maf .005 \
--recode \
--keep ../data/processed/file_lists/samples_names_introgression.file.list \
--out ../data/processed/vcf_files/allsamples_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005
```

- phase VCF

```beagle_phasing_vcf.sh```

```bash
java -Xmx60000m -jar ../../../tools/beagle.29May21.d6d.jar \
gt=../data/processed/vcf_files/susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.recode.vcf \
out=../data/processed/phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005
```

- split by chromossome

```chr_splitter.sh```

```bash

VCF_FILE="../data/processed/vcf_files/phased_susbset_introgression108_gatk_filter_maxmissing30_max_biallelic_vcftools_maxmissing07_maf005.vcf.gz"

for i in $(seq 1 16); do
for chr in "Scaffold_"$i; do

# for i in $(seq 1 16); do

echo $chr

 vcftools  --gzvcf  $VCF_FILE  --chr $chr  --recode --recode-INFO-all --out  ../data/processed/VCF_subset_introgression108_$chr;
done
done
```

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

- Run chromopainter. Using a 

```cp2_with_f```

```bash
ids="../data/processed/subset_45_new.ids"

ChromoPainterv2 \
-b -in -iM -i 10 \
-g ../data/processed/plink_phased_VCF_9each_Scaffold_$SLURM_ARRAY_TASK_ID.phase \
-r ../data/processed/9each_Scaffold_$SLURM_ARRAY_TASK_ID.recombfile \
-t $ids \
-o ../data/processed/full_cp2_withf_9each_scaffold_$SLURM_ARRAY_TASK_ID.hap1 \
-f ../data/processed/poplist_for_cp.filein 0 0
```

For plotting:

- split files by haplotype

```
 csplit -f sc15_108_haplotypes  -z ../data/processed/sc15_108_all_haplotypes /HAP/ '{*}'
 ```
 
- transform split files into naming recognized by the Rscript


```parsefile.sh```

