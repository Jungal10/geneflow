### Total load

for COL in {6..114};  ### column 119 is with the GERP scores
  do
    awk -v var=${COL} '{print $var*$119}' AllScaffold_GERP-012coded.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Additive-MutationLoad.txt
    #awk -v var=${COL} '$var == 2 {print ($var-1)*$119}' AllScaffold_GERP-012coded.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> RECESSIVE-MutationLoad.txt
done
paste -d "\t" INDV.txt Additive-MutationLoad.txt > Additive-MutationLoad-FINAL.txt
#paste -d "\t" INDV.txt RECESSIVE-MutationLoad.txt > RECESSIVE-MutationLoad-FINAL.txt


#### Fixed Load and Segregating load calculation

#### Allele frequency calculation for identifying fixed and segregating sites per population

for CHR in {1..16};
  do
	awk 'NR >1 {print $0}' Scaffold_${CHR}.polarise > Scaffold_${CHR}-noheader.polarise
	cut -f1,2,3,4 Scaffold_${CHR}-noheader.polarise > Scaffold_${CHR}.polarise.ChrPosAnDev.txt
	cut --complement -f1,2,3,4 Scaffold_${CHR}-noheader.polarise > Scaffold_${CHR}.polarise.Alleles.txt
	awk 'OFS="\t" {print $1,$2,".",$3,$4,"q30","PASS",".","GT"}' Scaffold_${CHR}.polarise.ChrPosAnDev.txt > Scaffold_${CHR}.polarise.VCF.txt
	paste -d "\t" Scaffold_${CHR}.polarise.VCF.txt Scaffold_${CHR}.polarise.Alleles.txt > Scaffold_${CHR}.polarise.formatVCF.txt
	cat VCF_Header.txt Scaffold_${CHR}.polarise.formatVCF.txt > Scaffold_${CHR}.polarise.vcf
	rm Scaffold_${CHR}.polarise.ChrPosAnDev.txt
	rm Scaffold_${CHR}.polarise.Alleles.txt
	rm Scaffold_${CHR}.polarise.VCF.txt
	rm Scaffold_${CHR}.polarise.formatVCF.txt
	#rm Scaffold_${CHR}.polarise
  done
  vcf-concat Scaffold_1.polarise.vcf Scaffold_2.polarise.vcf Scaffold_3.polarise.vcf Scaffold_4.polarise.vcf Scaffold_5.polarise.vcf Scaffold_6.polarise.vcf Scaffold_7.polarise.vcf Scaffold_8.polarise.vcf Scaffold_9.polarise.vcf Scaffold_10.polarise.vcf Scaffold_11.polarise.vcf Scaffold_12.polarise.vcf Scaffold_13.polarise.vcf Scaffold_14.polarise.vcf Scaffold_15.polarise.vcf Scaffold_16.polarise.vcf > AllScaffold_polarise.vcf

for INDV in Caudatus Cruentus Hybridus-CA Hybridus-SA Hypochondriacus Quitensis;
   do
	vcftools --vcf AllScaffold_polarise.vcf --keep ${INDV}.txt --freq --out ${INDV}AF
        sed 's|:|\t|g' ${INDV}AF.frq > ${INDV}AF-tab.frq
        awk '$8 == 1 {print $0}' ${INDV}AF-tab.frq > ${INDV}-FixedDerived.frq
        awk '$6 == 1 {print $0}' ${INDV}AF-tab.frq > ${INDV}-FixedAncestral.frq
        awk '$8 > 0 && $8 < 1 {print $0}' ${INDV}AF-tab.frq > ${INDV}-Segregating.frq
   done
   
   
wc -l *-FixedAncestral.frq | head -n 7 > AlleleCounts.txt 
wc -l *-FixedDerived.frq | head -n 7 >> AlleleCounts.txt
wc -l *-Segregating.frq | head -n 7 >> AlleleCounts.txt


##### Fixed load calculation
   
   for INDV in Caudatus Cruentus Hybridus-CA Hybridus-SA Hypochondriacus Quitensis;
   do
   	 awk 'OFS="\t" {print $1,$2,$2+1}' ${INDV}-FixedDerived.frq > ${INDV}-FixedDerived.bed
	 for CHR in {1..16};
          do
		awk -v var="Scaffold_"${CHR} '$1 == var {print $0}' ${INDV}-FixedDerived.bed | bedtools intersect -loj -a stdin -b Scaffold_${CHR}_gerp.bed >> ${INDV}-FixedDerived.GERP.bed
 	  done
	awk '{print $8*2}' ${INDV}-FixedDerived.GERP.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> FixedDerived-Load.txt
	
   done
   
######## Segregating Load
   for INDV in Caudatus Cruentus Hybridus-CA Hybridus-SA Hypochondriacus Quitensis;
   do
   	awk 'OFS="\t" {print $1,$2,$2+1}' ${INDV}-Segregating.frq > ${INDV}-Segregating.bed
	for CHR in {1..16};
  	do
		awk -v var="Scaffold_"${CHR} '$1 == var {print $0}' ${INDV}-Segregating.bed | bedtools intersect -loj -a stdin -b Scaffold_${CHR}_gerp.bed >> ${INDV}-Segregating.GERP.bed
	done
        awk '{print $8*1}' ${INDV}-Segregating.GERP.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Segregating-Load.txt
   done
 


for INDV in Caudatus Cruentus Hybridus-CA Hybridus-SA Hypochondriacus Quitensis;
   do
   	bedtools intersect -wa -wb -a ${INDV}-Segregating.GERP.bed -b AllScaffold_GERP-012coded.bed > ${INDV}-Segregating-allINDIVIDIALS.bed
	for COL in {14..122};
  	  do
    		awk -v var=${COL} '{print $var*$8}' ${INDV}-Segregating-allINDIVIDIALS.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> ${INDV}-Segregating-MutationLoad-Additive.txt
    		awk -v var=${COL} '$var == 2 {print ($var-1)*$8}' ${INDV}-Segregating-allINDIVIDIALS.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> ${INDV}-Segregating-MutationLoad-Recessive.txt
	done
   	
  done
 
