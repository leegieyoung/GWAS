#!/bin/sh
if [ $# -ne 1 ];then
        echo "Please enter Sample_Name"
               exit
fi
#Sample = AD_14 등으로 기록되어있어야 함
#beagle 진행시Same position 제거를 안했을 경우 사용하는 코드
Sample=$1
GWAS_path="/scratch/hpc46a05/GWAS/result"
code_path="/scratch/hpc46a05/GWAS/Code/plink_code_folder"
mkdir ${GWAS_path}/QC_Imputed_${Sample}
result_folder="${GWAS_path}/QC_Imputed_${Sample}"
#imputed_sample folder
beagle_folder="/scratch/hpc46a05/GWAS/beagle_result"
Sample_folder="${beagle_folder}/3.${Sample}_imputed_${Sample}"
raw_folder="/scratch/hpc46a05/GWAS/raw_data/"
#beagle_folder="/scratch/x1997a11/GWAS/pdxen_AD/beagle/Result_folder"

#1.SampleQC(geno mind impute-sex hwe)
mkdir ${result_folder}/raw_merge
mkdir ${result_folder}/QC
mkdir ${result_folder}/MaMi
mkdir ${result_folder}/dosage

echo '================================'
echo '                                '
echo '      Do making dosage file  '
echo '        Frq is all dataset '
echo '                                '
echo '================================'
plink --bfile ${result_folder}/MaMi/QC_Imputed_${Sample} \
 --keep-allele-order \
 --freq \
 --out ${result_folder}/dosage/raw_QC_Imputed_${Sample}_freq

awk '{print $1, $2, $3 ,$4, $5}' ${result_folder}/dosage/raw_QC_Imputed_${Sample}_freq.frq > ${result_folder}/dosage/QC_Imputed_${Sample}_freq.frq

plink --bfile ${result_folder}/MaMi/QC_Imputed_${Sample} \
 --recode vcf-iid \
 --keep-allele-order \
 --out ${result_folder}/dosage/raw_QC_Imputed_${Sample}

grep -v "^##" ${result_folder}/dosage/raw_QC_Imputed_${Sample}.vcf > ${result_folder}/dosage/QC_Imputed_${Sample}.vcf
cat ${result_folder}/dosage/QC_Imputed_${Sample}.vcf | colrm 1 9 > ${result_folder}/dosage/raw_QC_Imputed_${Sample}.dosage
sed -i -e 's/0\/0/0/g' -e 's/0\/1/1/g' -e 's/1\/1/2/g' ${result_folder}/dosage/raw_QC_Imputed_${Sample}.dosage
paste -d ' ' ${result_folder}/dosage/QC_Imputed_${Sample}_freq.frq ${result_folder}/dosage/raw_QC_Imputed_${Sample}.dosage > ${result_folder}/dosage/QC_Imputed_${Sample}.dosage

sed -n '1p' ${result_folder}/dosage/QC_Imputed_${Sample}.dosage > ${result_folder}/dosage/dosage.head
for A in $(seq 1 22)
do
grep -w "^${A}" ${result_folder}/dosage/QC_Imputed_${Sample}.dosage > ${result_folder}/dosage/raw_QC_Imputed_chr${A}_${Sample}.dosage
cat ${result_folder}/dosage/dosage.head ${result_folder}/dosage/raw_QC_Imputed_chr${A}_${Sample}.dosage > ${result_folder}/dosage/QC_Imputed_chr${A}_${Sample}.dosage
yes n | gzip ${result_folder}/dosage/QC_Imputed_chr${A}_${Sample}.dosage
done

