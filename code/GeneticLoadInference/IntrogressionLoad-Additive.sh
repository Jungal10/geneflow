
#### calculate additive load per individual
awk 'OFS="\t" {print $1,$2,$3}' AllScaffold_GERP-012coded.bed > ChrPos.bed
for COL in {6..114};
  do
    awk -v var=${COL} '{print $var*$119}' AllScaffold_GERP-012coded.bed > AdditiveLoad-Indv-${COL}.txt
    
  done

paste -d "\t" ChrPos.bed AdditiveLoad-Indv-*.txt > AdditiveLoadperIndv.txt

for chr in {1..16};
   do
   	echo Procession for Chromosome ${chr}
   	echo Preparaing Input File
   	awk -v var=${chr} 'OFS="\t" {print "Scaffold_"var,$1,$1+1}' AS_list_sc${chr}.txt > chrPos_chr${Chr}.bed
   	cut --complement -f 1,2 AS_list_sc${chr}.txt > Introgression_sc${chr}.txt
   	paste -d "\t" chrPos_chr${Chr}.bed Introgression_sc${chr}.txt | awk 'NR >1 {print $0}' > Scaffold_${chr}_introgression.bed
	
	echo Removing Intermediate Files
	rm chrPos_chr${Chr}.bed 
	rm Introgression_sc${chr}.txt
	
	echo overlapping introgression with additive load
	bedtools intersect -wa -wb -a Scaffold_${chr}_introgression.bed -b AdditiveLoadperINDV.txt >> All16Scaffold_introgression_AdditiveLoad.bed
  done
  
####### Now actual load calculation for introgression sites
mkdir IntrogressedLoads
echo Starting Actual Load Calculation
for COL in {4..111};
#111+4
  do
  for INDV in caudatus cruentus hybridus_CA hybridus_SA hypochondriacus quitensis ambiguous;
  	do
	     awk -v var=${COL} -v ind=${INDV} '$var == ind {counter=var+111 ; printf  "%s\n",  $counter}' All16Scaffold_introgression_AdditiveLoad.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' | awk -v ind=${INDV} '{print ind"\t"$0}' >> IntrogressedLoads/${COL}_MutationLoad.txt
	     awk -v var=${COL} -v ind=${INDV} '$var == ind {counter=var+111 ; printf  "%s\n",  $counter}' All16Scaffold_introgression_AdditiveLoad.bed | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' | awk -v ind=${INDV} '{print ind"\t"$0}' >> IntrogressedLoads/${COL}_MutationLoad-Average.txt
	     awk -v var=${COL} -v ind=${INDV} '$var == ind {counter=var+111 ; printf  "%s\n",  $counter}' All16Scaffold_introgression_AdditiveLoad.bed | awk '$1 > 0 { sum += $1; n++ } END { if (n > 0) print sum / n; }' | awk -v ind=${INDV} '{print ind"\t"$0}' >> IntrogressedLoads/${COL}_MutationLoad-AverageGERPSites.txt
	     awk -v var=${COL} -v ind=${INDV} '$var == ind {n++} END {print ind"\t"n}' All16Scaffold_introgression_AdditiveLoad.bed >> IntrogressedLoads/${COL}_IntrogressedSites.txt
	     
done
datamash transpose < IntrogressedLoads/${COL}_MutationLoad.txt | awk 'NR >1 {print $0}' | paste >> Introgressed_MutationLoad.txt
datamash transpose < IntrogressedLoads/${COL}_MutationLoad-Average.txt | awk 'NR >1 {print $0}' | paste >> Introgressed_MutationLoad-AverageperSite.txt
datamash transpose < IntrogressedLoads/${COL}_MutationLoad-AverageGERPSites.txt | awk 'NR >1 {print $0}' | paste >> Introgressed_MutationLoad-AverageGERPSite.txt
datamash transpose < IntrogressedLoads/${COL}_IntrogressedSites.txt | awk 'NR >1 {print $0}' | paste >> Introgressed_Sites.txt
done


