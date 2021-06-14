#!/bin/sh
Sample_path="/scratch/x1997a11/AD_data/BSAD"
s1=$1
s2=$2

plink --bfile ${Sample_path}/${s1} --maf 0.001 --make-bed --out ${Sample_path}/${s2}_maf
plink --bfile ${Sample_path}/${s2}_maf --recode vcf-iid bgz --out ${Sample_path}/${s2}_maf


zcat ${Sample_path}/${s2}_maf.vcf.gz | awk '$4 != "-" && $5 != "-" && $4 != "I" && $5 != "I" && $4 != "D" && $5 != "D" && $4 != "0" && $5 != "0" && $4 != "N" && $5 != "N" && $4 != "." && $5 != "." '  | gzip > ${Sample_path}/${s2}_maf_noINDEL.vcf.gz

bcftools norm -d all -O z -o ${Sample_path}/${s2}_maf_noINDEL_rmDupID.vcf.gz ${Sample_path}/${s2}_maf_noINDEL.vcf.gz 

plink --vcf ${Sample_path}/${s2}_maf_noINDEL_rmDupID.vcf.gz \
 --double-id \
 --make-bed \
 --out ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover

grep -v '^26' ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover.bim > ${Sample_path}/rmother1.bim
grep -v '^25' ${Sample_path}/rmother1.bim > ${Sample_path}/rmother2.bim
grep -v '^24' ${Sample_path}/rmother2.bim > ${Sample_path}/rmother3.bim
grep -v '^23' ${Sample_path}/rmother3.bim > ${Sample_path}/rmother4.bim
grep -v '^MT' ${Sample_path}/rmother4.bim > ${Sample_path}/rmother5.bim
grep -v '^Y' ${Sample_path}/rmother5.bim > ${Sample_path}/rmother6.bim
grep -v '^X' ${Sample_path}/rmother6.bim > ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover.autosomal.bim

awk '{print $2}' ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover.autosomal.bim > ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover.autosomal.txt

plink --bfile ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover \
 --extract ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover.autosomal.txt \
 --make-bed \
 --out ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover.autosomal


for chr in $(seq 1 22)
do
plink --bfile ${Sample_path}/${s2}_maf_noINDEL_rmDupID_noliftover.autosomal --keep-allele-order --chr $chr --double-id --recode vcf-iid bgz --out ${Sample_path}/CHR${chr}_${s2}_noIndel_rmDupID
bcftools index ${Sample_path}/CHR${chr}_${s2}_noIndel_rmDupID.vcf.gz
done

