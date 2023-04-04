mkdir SampleFiles
mkdir GERP
mkdir MutationLoad
for CHR in {1..16};
  do
  	awk -v var="Scaffold_"${CHR} '$1 == var {print $0}' Amaranth-AA.txt > Scaffold_${CHR}_AA.txt
  	awk -v var="Scaffold_"${CHR} '$1 == var {print $0}' GERP_Score_Amaranth.bed > GERP/Scaffold_${CHR}_gerp.bed
 	#vcftools --vcf /home/alle/Desktop/GERP-VCF/ready_dovcf_geneflowsamples_onlyCHR1-16.recode.vcf --chr Scaffold_${CHR} --recode --recode-INFO-all --out Scaffold_${CHR}_sample
  	python polarise_beagleVCF.py -i /home/alle/Desktop/GERP-VCF/PolarisePerChr/Scaffold_${CHR}_sample.recode.vcf  -a Scaffold_${CHR}_AA.txt -o Scaffold_${CHR}.polarise
  	rm Scaffold_${CHR}_AA.txt
 	#### INPUT File Processing to bed
 
 	cut -f1,2 Scaffold_${CHR}.polarise  > Scaffold_${CHR}-Pos-polarise.txt
	cut --complement -f1,2 Scaffold_${CHR}.polarise  > Scaffold_${CHR}-Alleles-polarise.txt
 	awk 'OFS="\t" {print $0,$2+1}' Scaffold_${CHR}-Pos-polarise.txt > Scaffold_${CHR}-Pos-polarise.bed  
 	sed 's/[|]//g' Scaffold_${CHR}-Alleles-polarise.txt | sed 's|00|0|g' | sed 's|01|1|g' | sed 's|11|2|g' | sed 's|10|1|g' > Scaffold_${CHR}.polarise_012coded
 	paste -d "\t" Scaffold_${CHR}-Pos-polarise.bed Scaffold_${CHR}.polarise_012coded > Scaffold_${CHR}.polarise_012coded.bed

 
	awk 'NR >1 {print $0}' Scaffold_${CHR}.polarise_012coded.bed > Scaffold_${CHR}.polarise_012coded-noheader.bed
	rm Scaffold_${CHR}-Pos-polarise.txt
	rm Scaffold_${CHR}-Alleles-polarise.txt
	rm Scaffold_${CHR}-Pos-polarise.bed
	rm Scaffold_${CHR}.polarise_012coded.bed
	mv Scaffold_${CHR}.polarise_012coded-noheader.bed SampleFiles/
	bedtools intersect -loj -a SampleFiles/Scaffold_${CHR}.polarise_012coded-noheader.bed -b GERP/Scaffold_${CHR}_gerp.bed >> MutationLoad/AllScaffold_GERP-012coded.bed
	
  done

