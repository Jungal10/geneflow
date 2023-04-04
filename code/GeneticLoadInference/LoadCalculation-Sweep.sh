####### The files are in 1-based format
########## overlap with the variant polarisedfile having GERP score 
for INDV in caudatus cruentus hybridus hypochondriacus quitensis;
do
	bedtools intersect -wa -wb -a InputFiles/sweeps_${INDV}_top005non_overlapping.txt -b AllScaffold_GERP-012coded.bed > sweep_${INDV}-GERP-all.bed
done

cd SweepRegion
#### caudatus
for COL in {9..41};
  do
    awk -v var=${COL} '{print $var*$122}' sweep_caudatus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Caudatus_Sweep-AdditiveLoad.txt
    awk -v var=${COL} '{print $var*$122}' sweep_caudatus-GERP-all.bed | wc -l >> Caudatus_Sweep-NoOfSites.txt
    awk -v var=${COL} '{print $var*$122}' sweep_caudatus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Caudatus_Sweep-NoOfSites-withload.txt
    awk -v var=${COL} '{print $var*$122,$122}' sweep_caudatus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Caudatus_Sweep-NoOfSites-withgerp0.txt

done
#### cruentus 
for COL in {42..62};
  do
      awk -v var=${COL} '{print $var*$122}' sweep_cruentus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Cruentus_Sweep-AdditiveLoad.txt
      awk -v var=${COL} '{print $var*$122}' sweep_cruentus-GERP-all.bed | wc -l >> Cruentus_Sweep-NoOfSites.txt
      awk -v var=${COL} '{print $var*$122}' sweep_cruentus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Cruentus_Sweep-NoOfSites-withload.txt
      awk -v var=${COL} '{print $var*$122,$122}' sweep_cruentus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Cruentus_Sweep-NoOfSites-withgerp0.txt

done
##### hybridus CA
for COL in {63..67};
  do
     awk -v var=${COL} '{print $var*$122}' sweep_hybridus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Hybridus-CA_Sweep-AdditiveLoad.txt
     awk -v var=${COL} '{print $var*$122}' sweep_hybridus-GERP-all.bed | wc -l >> Hybridus-CA_Sweep-NoOfSites.txt
     awk -v var=${COL} '{print $var*$122}' sweep_hybridus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Hybridus-CA_Sweep-NoOfSites-withload.txt
     awk -v var=${COL} '{print $var*$122,$122}' sweep_hybridus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Hybridus-CA_Sweep-NoOfSites-withgerp0.txt
done
###########hybridus-SA
for COL in {68..71};
  do
    awk -v var=${COL} '{print $var*$122}' sweep_hybridus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Hybridus-SA_Sweep-AdditiveLoad.txt
    awk -v var=${COL} '{print $var*$122}' sweep_hybridus-GERP-all.bed | wc -l >> Hybridus-SA_Sweep-NoOfSites.txt
    awk -v var=${COL} '{print $var*$122}' sweep_hybridus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Hybridus-SA_Sweep-NoOfSites-withload.txt
    awk -v var=${COL} '{print $var*$122,$122}' sweep_hybridus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Hybridus-SA_Sweep-NoOfSites-withgerp0.txt
done
########## hypochondriacus
for COL in {72..92};
  do
    awk -v var=${COL} '{print $var*$122}' sweep_hypochondriacus-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Hypochondriacus_Sweep-AdditiveLoad.txt
    awk -v var=${COL} '{print $var*$122}' sweep_hypochondriacus-GERP-all.bed | wc -l >> Hypochondriacus_Sweep-NoOfSites.txt
    awk -v var=${COL} '{print $var*$122}' sweep_hypochondriacus-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Hypochondriacus_Sweep-NoOfSites-withload.txt
    awk -v var=${COL} '{print $var*$122,$122}' sweep_hypochondriacus-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Hypochondriacus_Sweep-NoOfSites-withgerp0.txt
done
############## quitensis
for COL in {93..116};
  do
    awk -v var=${COL} '{print $var*$122}' sweep_quitensis-GERP-all.bed | awk '{SUM+=$1};END{printf "%.15g\n", SUM}' >> Quitensis_Sweep-AdditiveLoad.txt
    awk -v var=${COL} '{print $var*$122}' sweep_quitensis-GERP-all.bed | wc -l >> Quitensis_Sweep-NoOfSites.txt
    awk -v var=${COL} '{print $var*$122}' sweep_quitensis-GERP-all.bed | awk '$1 > 0 {print $0}' | wc -l >> Quitensis_Sweep-NoOfSites-withload.txt
    awk -v var=${COL} '{print $var*$122,$122}' sweep_quitensis-GERP-all.bed | awk '$2 > 0 {print $0}' | wc -l >> Quitensis_Sweep-NoOfSites-withgerp0.txt
done

cat Caudatus_Sweep-AdditiveLoad.txt Cruentus_Sweep-AdditiveLoad.txt  Hybridus-CA_Sweep-AdditiveLoad.txt Hybridus-SA_Sweep-AdditiveLoad.txt Hypochondriacus_Sweep-AdditiveLoad.txt Quitensis_Sweep-AdditiveLoad.txt > AllPop-Sweep-AdditiveLoad.txt
cat Caudatus_Sweep-NoOfSites.txt Cruentus_Sweep-NoOfSites.txt  Hybridus-CA_Sweep-NoOfSites.txt Hybridus-SA_Sweep-NoOfSites.txt Hypochondriacus_Sweep-NoOfSites.txt Quitensis_Sweep-NoOfSites.txt > AllPop-Sweep-NoOfSites.txt
cat Caudatus_Sweep-NoOfSites-withgerp0.txt Cruentus_Sweep-NoOfSites-withgerp0.txt  Hybridus-CA_Sweep-NoOfSites-withgerp0.txt Hybridus-SA_Sweep-NoOfSites-withgerp0.txt Hypochondriacus_Sweep-NoOfSites-withgerp0.txt Quitensis_Sweep-NoOfSites-withgerp0.txt > AllPop-Sweep-NoOfSites-withgerp0.txt
cat Caudatus_Sweep-NoOfSites-withload.txt Cruentus_Sweep-NoOfSites-withload.txt  Hybridus-CA_Sweep-NoOfSites-withload.txt Hybridus-SA_Sweep-NoOfSites-withload.txt Hypochondriacus_Sweep-NoOfSites-withload.txt Quitensis_Sweep-NoOfSites-withload.txt > AllPop-Sweep-NoOfSites-withload.txt
paste -d "\t" Pops.txt AllPop-Sweep-AdditiveLoad.txt AllPop-Sweep-NoOfSites.txt AllPop-Sweep-NoOfSites-withgerp0.txt AllPop-Sweep-NoOfSites-withload.txt > Sweeps.txt
cat header.txt Sweeps.txt > AllPop-Sweeps-All.txt
awk 'NR>1 {print $0,"\t",$4/$5,"\t",$4/$6,"\t",$4/$7}' AllPop-Sweeps-All.txt > AllPOP-Sweeps-Final.txt
