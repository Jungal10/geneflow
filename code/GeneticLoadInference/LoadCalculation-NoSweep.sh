### CONTROL CHROMOSOME = COMPLETE CHROMOSOME EXCEPT THE SWEEP REGION ###########

for INDV in caudatus cruentus hybridus hypochondriacus quitensis;
do
############ overlap with the variant polarisedfile having GERP score 
bedtools intersect -v -a AllScaffold_GERP-012coded.bed -b InputFiles/sweeps_${INDV}_top005non_overlapping.txt > ControlChromosome/NoSweepRegion_${INDV}-GERP-all.bed

done

cd ControlChromosome

#### caudatus
for COL in {6..38};
  do
    awk -v var=${COL} '{print $var*$119}' NoSweepRegion_caudatus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Caudatus_NoSweep-AdditiveLoad.txt
    awk -v var=${COL} '{print $var*$119}' NoSweepRegion_caudatus-GERP-all.bed | wc -l >> Caudatus_NoSweep-NoOfSites.txt
    awk -v var=${COL} '{print $var*$119}' NoSweepRegion_caudatus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Caudatus_NoSweep-NoOfSites-withLoad.txt
    awk -v var=${COL} '{print $var*$119,$119}' NoSweepRegion_caudatus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Caudatus_NoSweep-NoOfSites-withgerp0.txt
done
#### cruentus 
for COL in {39..59};
  do
    awk -v var=${COL} '{print $var*$119}' NoSweepRegion_cruentus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Cruentus_NoSweep-AdditiveLoad.txt
    awk -v var=${COL} '{print $var*$119}' NoSweepRegion_cruentus-GERP-all.bed | wc -l >> Cruentus_NoSweep-NoOfSites.txt 
    awk -v var=${COL} '{print $var*$119}' NoSweepRegion_cruentus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Cruentus_NoSweep-NoOfSites-withLoad.txt
    awk -v var=${COL} '{print $var*$119,$119}' NoSweepRegion_cruentus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Cruentus_NoSweep-NoOfSites-withgerp0.txt
done
##### hybridus CA
for COL in {60..64};
  do
     awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hybridus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Hybridus-CA_NoSweep-AdditiveLoad.txt
     awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hybridus-GERP-all.bed | wc -l >> Hybridus-CA_NoSweep-NoOfSites.txt
     awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hybridus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Hybridus-CA_NoSweep-NoOfSites-withLoad.txt
     awk -v var=${COL} '{print $var*$119,$119}' NoSweepRegion_hybridus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Hybridus-CA_NoSweep-NoOfSites-withgerp0.txt
done
###########hybridus-SA
for COL in {65..68};
  do
      awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hybridus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Hybridus-SA_NoSweep-AdditiveLoad.txt
      awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hybridus-GERP-all.bed | wc -l >> Hybridus-SA_NoSweep-NoOfSites.txt
      awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hybridus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Hybridus-SA_NoSweep-NoOfSites-withLoad.txt
      awk -v var=${COL} '{print $var*$119,$119}' NoSweepRegion_hybridus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Hybridus-SA_NoSweep-NoOfSites-withgerp0.txt
done
########## hypochondriacus
for COL in {69..89};
  do
     awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hypochondriacus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Hypochondriacus_NoSweep-AdditiveLoad.txt
     awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hypochondriacus-GERP-all.bed | wc -l >> Hypochondriacus_NoSweep-NoOfSites.txt
     awk -v var=${COL} '{print $var*$119}' NoSweepRegion_hypochondriacus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Hypochondriacus_NoSweep-NoOfSites-withLoad.txt
     awk -v var=${COL} '{print $var*$119,$119}' NoSweepRegion_hypochondriacus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Hypochondriacus_NoSweep-NoOfSites-withgerp0.txt
done
############## quitensis
for COL in {90..113};
  do
      awk -v var=${COL} '{print $var*$119}' NoSweepRegion_quitensis-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Quitensis_NoSweep-AdditiveLoad.txt
      awk -v var=${COL} '{print $var*$119}' NoSweepRegion_quitensis-GERP-all.bed | wc -l >> Quitensis_NoSweep-NoOfSites.txt
      awk -v var=${COL} '{print $var*$119}' NoSweepRegion_quitensis-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Quitensis_NoSweep-NoOfSites-withLoad.txt
      awk -v var=${COL} '{print $var*$119,$119}' NoSweepRegion_quitensis-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Quitensis_NoSweep-NoOfSites-withgerp0.txt
done
cat Caudatus_NoSweep-AdditiveLoad.txt Cruentus_NoSweep-AdditiveLoad.txt  Hybridus-CA_NoSweep-AdditiveLoad.txt Hybridus-SA_NoSweep-AdditiveLoad.txt Hypochondriacus_NoSweep-AdditiveLoad.txt Quitensis_NoSweep-AdditiveLoad.txt > AllPop-NoSweep-AdditiveLoad.txt
cat Caudatus_NoSweep-NoOfSites.txt Cruentus_NoSweep-NoOfSites.txt  Hybridus-CA_NoSweep-NoOfSites.txt Hybridus-SA_NoSweep-NoOfSites.txt Hypochondriacus_NoSweep-NoOfSites.txt Quitensis_NoSweep-NoOfSites.txt > AllPop-NoSweep-NoOfSites.txt
cat Caudatus_NoSweep-NoOfSites-withgerp0.txt Cruentus_NoSweep-NoOfSites-withgerp0.txt  Hybridus-CA_NoSweep-NoOfSites-withgerp0.txt Hybridus-SA_NoSweep-NoOfSites-withgerp0.txt Hypochondriacus_NoSweep-NoOfSites-withgerp0.txt Quitensis_NoSweep-NoOfSites-withgerp0.txt > AllPop-NoSweep-NoOfSites-withgerp0.txt
cat Caudatus_NoSweep-NoOfSites-withLoad.txt Cruentus_NoSweep-NoOfSites-withLoad.txt  Hybridus-CA_NoSweep-NoOfSites-withLoad.txt Hybridus-SA_NoSweep-NoOfSites-withLoad.txt Hypochondriacus_NoSweep-NoOfSites-withLoad.txt Quitensis_NoSweep-NoOfSites-withLoad.txt > AllPop-NoSweep-NoOfSites-withLoad.txt
paste -d "\t" Pops.txt AllPop-NoSweep-AdditiveLoad.txt AllPop-NoSweep-NoOfSites.txt AllPop-NoSweep-NoOfSites-withgerp0.txt AllPop-NoSweep-NoOfSites-withLoad.txt > NoSweeps.txt
cat header.txt NoSweeps.txt > AllPop-NoSweeps-All.txt
awk 'NR>1 {print $0,"\t",$4/$5,"\t",$4/$6,"\t",$4/$7}' AllPop-NoSweeps-All.txt > AllPOP-NoSweeps-Final.txt


