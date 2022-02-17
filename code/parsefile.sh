#!/bin/bash -l


i=0
split_files_prefix="/scratch/jgoncal1/fscp_output/hapdata/sc16_haplotypes"
species="caudatus cruentus hypochondriacus hybridus_CA hybridus_SA quitensis"
for s in $species; do
files=(` grep "HAP 1 $s" $split_files_prefix* | cut -d ":" -f1 `)
index=0
for f in "${files[@]}"; do
index=$(( index + 1 ))
# index=${#files[@]}
    i=$(( i + 1 ))
    echo "species :" $s
    echo "files :" $f
    echo index $s $index
    echo total $i
    echo "- Processing file: $f"
    echo "rename $f into : $split_files_prefix"_"$s$index"
    cp $f $split_files_prefix"_"$s$index
done
done

rm $split_files_prefix[0-9]*
