mkdir FINAL
mkdir FINAL/PerChromosome

#Convert maf to vcf for all species
maffilter param=maffilter_paramFile.txt 
cat msa_pipeline/results/gerp/Scaffold_*.gerp.final.bed > All_Scaffold_gerp.final.bed
sort -V -k1,1 -k2,2 All_Scaffold_gerp.final.bed | awk 'NR > 16 {print $0}' > FINAL/All-Scaffold.gerp.final-noheader.bed

#### Extract only four species for finding ansestral state and only 16 chromosomes
vcftools --gzvcf All-Species_snp.vcf.gz --indv Bvulgaris --indv Cquinoa --indv MonoeViroflay --recode --recode-INFO-all --chr Scaffold_1 --chr Scaffold_2 --chr Scaffold_3 --chr Scaffold_4 --chr Scaffold_5 --chr Scaffold_6 --chr Scaffold_7 --chr Scaffold_8 --chr Scaffold_9 --chr Scaffold_10 --chr Scaffold_11 --chr Scaffold_12 --chr Scaffold_13 --chr Scaffold_14 --chr Scaffold_15 --chr Scaffold_16 --stdout | bgzip -c > All-16Chr-4species.vcf.gz
######3 Convert vcf to table format
gunzip -c All-16Chr-4species.vcf.gz | awk 'OFS="\t" {print $1,$2,$4,$5,$10,$11,$12}' > All-CHR-only4species-Table.txt
awk 'NR>6 {print $0}' All-CHR-only4species-Table.txt > All-CHR-only4species-Table-noheader.txt

#### Assigning Alleles in ATCG format #####
awk '{OFS="\t";if($5=="0"){print $1,$2,$3,$4,$3,$6,$7} \
 if($5=="1"){print $1,$2,$3,$4,substr($4,1,1),$6,$7} \
 if($5=="."){print $1,$2,$3,$4,$5,$6,$7} \
 if($5=="2"){print $1,$2,$3,$4,substr($4,3,1),$6,$7}\
 if($5=="3"){print $1,$2,$3,$4,substr($4,5,1),$6,$7}}' All-CHR-only4species-Table-noheader.txt > Bvulgaris-edited.txt
awk '{OFS="\t";if($6=="0"){print $1,$2,$3,$4,$5,$3,$7} \
 if($6=="1"){print $1,$2,$3,$4,$5,substr($4,1,1),$7} \
 if($6=="."){print $1,$2,$3,$4,$5,$6,$7} \
 if($6=="2"){print $1,$2,$3,$4,$5,substr($4,3,1),$7}\
 if($6=="3"){print $1,$2,$3,$4,$5,substr($4,5,1),$7}}' Bvulgaris-edited.txt > Bvulgaris_Cquinoua-edited.txt
awk '{OFS="\t";if($7=="0"){print $1,$2,$3,$4,$5,$6,$3} \
 if($7=="1"){print $1,$2,$3,$4,$5,$6,substr($4,1,1)} \
 if($7=="."){print $1,$2,$3,$4,$5,$6,$7} \
 if($7=="2"){print $1,$2,$3,$4,$5,$6,substr($4,3,1)}\
 if($7=="3"){print $1,$2,$3,$4,$5,$6,substr($4,5,1)}}' Bvulgaris_Cquinoua-edited.txt > Bvulgaris_Cquinoua_Spinich-edited.txt

########## Replacing missing with N and preparing input for ancestral allele format

sed 's|[.]|N|g' Bvulgaris_Cquinoua_Spinich-edited.txt > Bvulgaris_Cquinoua_Spinich-edited-N.txt 
awk 'OFS="\t" {print $1,$2,$3,$4,$5$6$7}' Bvulgaris_Cquinoua_Spinich-edited-N.txt > Bvulgaris_Cquinoua_Spinich-edited-N-joined.txt

########### AA assignment ####
# AncestralAlleleAssignment.sh
IFS=$'\n' Comb=($(cat PossibleCombinations.txt))
IFS=$'\n' AA=($(cat AlternateAncestralAllele.txt))

  for ((i=0;i<${#Comb[@]};++i));
   do
 	awk -v var="${Comb[i]}" -v allele="${AA[i]}" '{OFS="\t"; if($5 ~ var){print $0,allele}}' Bvulgaris_Cquinoua_Spinich-edited-N-joined.txt >> Bvulgaris_Cquinoua_Spinich-edited-N-joined-AAtag.txt
 	
   done 

awk 'OFS="\t" {print $1,$2,$3,$4,substr($5,1,1),substr($5,2,1),substr($5,3,1),$6}' Bvulgaris_Cquinoua_Spinich-edited-N-joined-AAtag.txt > FINAL/Bvulgaris_Cquinoua_Spinich-edited-N-joined-AAtag-FINAL.txt
cd FINAL/
########## Convert it into bed file with 1-based coordinates (as this would be used to compare with the vcf where positions are based on 1-coordinates) ###########
awk 'OFS="\t" {print $1,$2,$2+1,$3,$4,$5,$6,$7,$8}' Bvulgaris_Cquinoua_Spinich-edited-N-joined-AAtag-FINAL.txt > Bvulgaris_Cquinoua_Spinich-edited-N-joined-AAtag-FINAL-1-based.bed 
 ##### Convert the GERP file to 1 based coordinates bed file for overlap with Ancestral allele files and finally used for vcf overlap ####
awk 'OFS="\t" {print $1,$3,$3+1,$4,$5,$6}' All-Scaffold.gerp.final-noheader.bed > All_Scaffold_gerp.final-1-based.bed
######### used bedtools intersect to merge the files with GERP score and AA, but before need to split Chr wise as the file size is too big to overlap 
for CHR in {1..16};
  do
  	awk -v var="Scaffold_"${CHR} '$1 == var {print $0}' All_Scaffold_gerp.final-1-based.bed > PerChromosome/Scaffold_${CHR}_gerp.bed
  	awk -v var="Scaffold_"${CHR} '$1 == var {print $0}' Bvulgaris_Cquinoua_Spinich-edited-N-joined-AAtag-FINAL-1-based.bed | sort -n -k2 > PerChromosome/Scaffold_${CHR}_AA.bed
	bedtools intersect -wa -wb -a PerChromosome/Scaffold_${CHR}_gerp.bed -b PerChromosome/Scaffold_${CHR}_AA.bed > PerChromosome/Scaffold${CHR}-GERP-AA.bed
  	bedtools intersect -v -a PerChromosome/Scaffold_${CHR}_gerp.bed -b PerChromosome/Scaffold_${CHR}_AA.bed >> Scaffold2-16-GERP-NotPresentInAA.bed 
  done
  #### the sites listed in Scaffold2-16-GERP-NotPresentInAA.bed  are those not present in AA file for some unknown reason (probably filter tag 'unk'??) so fill them manually from the vcf file and then merge them to original file#
  cat /home/alle/Desktop/GERP-Test/msa_pipeline/results-FINAL/Summary/FINAL/PerChromosome/Scaffold*-GERP-AA.bed Scaffold2-16-GERP-NotPresentInAA.bed > AllScaffold-GERP-AA.bed
  ### Filter out the sites where AA cannot be annotated
  awk '$15 !~ "NA" && $15 !~ "N" {print $0}' AllScaffold-GERP-AA.bed > AllScaffold-GERP-AA-noNAN.bed
  
