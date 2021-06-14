#!/bin/sh
doing_path="/scratch/x1997a11/AD_data/ADNI/ADNI_expression"
#for A in $(seq 1 48074)
#do

#anno
#sed -n ${A}p ${doing_path}/ADNI_Gene_Expression_Profile.txt > ${doing_path}/temp/${A}.txt 
#grep -oP '\S+' ${doing_path}/temp/${A}.txt > ${doing_path}/transpose/${A}.txt
#done

paste ${doing_path}/transpose/1.txt ${doing_path}/transpose/2.txt >> merge/raw_merge2.txt
#for A in $(seq 3 48074)
#do
#B=$((A-1))
#paste ${doing_path}/merge/raw_merge${B}.txt ${doing_path}/transpose/${A}.txt >> ${doing_path}/merge/raw_merge${A}.txt
#rm ${doing_path}/merge/raw_merge${B}.txt
#done
#mv ${doing_path}/merge/raw_merge48074.txt ${doing_path}/merge.txt
#rm ${doing_path}/merge/raw_merge*

