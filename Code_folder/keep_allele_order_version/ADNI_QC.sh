#!/bin/sh
if [ $# -ne 1 ];then
        echo "Please enter Sample_Name"
               exit
fi
Sample=$1

GWAS_path="/scratch/x1997a11/GWAS/pdxen_AD/result_folder"
code_path="/scratch/x1997a11/GWAS/pdxen_AD/Code_folder"
mkdir ${GWAS_path}/QC_${Sample}
result_folder="${GWAS_path}/QC_${Sample}"
#Case 원본파일이 담긴 곳
Sample_folder="/scratch/x1997a11/GWAS/pdxen_AD/Sample_folder/${Sample}"
pheno="/scratch/x1997a11/GWAS/pdxen_AD/reference_folder/${Sample}.txt"


#1.SampleQC(geno mind impute-sex hwe)

#Case data 작업폴더
#mkdir ${result_folder}/NoQC
#=======================================================================


echo "=========================================="
echo "             

                    Sample QC_ing... 

"
echo "=========================================+"
#impute-sex 를 사용하지 않는 경우
plink --bfile ${GWAS_path}/QC_Imputed_mergeADNI/MaMi/QC_Imputed_mergeADNI \
 --keep ${result_folder}/MaMi/extract.list \
 --make-bed \
 --keep-allele-order \
 --out ${result_folder}/MaMi/NoQC_${Sample}

plink --bfile ${result_folder}/MaMi/NoQC_${Sample} \
 --geno 0.2 \
 --make-bed \
 --keep-allele-order \
 --out ${result_folder}/MaMi/NoQC_${Sample}_g

plink --bfile ${result_folder}/MaMi/NoQC_${Sample}_g \
 --mind 0.2 \
 --make-bed \
 --keep-allele-order \
 --out ${result_folder}/MaMi/NoQC_${Sample}_g_m
#plink --bfile ${result_folder}/MaMi/NoQC_${Sample}_g_m --impute-sex --make-bed --out ${result_folder}/MaMi/NoQC_${Sample}_g_m_sex

#cp ${result_folder}/MaMi/NoQC_${Sample}_g_m_sex.fam ${result_folder}/MaMi/SEXerror_NoQC_${Sample}_g_m_sex.fam
#awk '{sub(/0/,"2",$5);print > "'${result_folder}'/QC/NoQC_${Sample}_g_m_sex.fam"}' ${result_folder}/MaMi/SEXerror_NoQC_${Sample}_g_m_sex.fam
plink --bfile ${result_folder}/MaMi/NoQC_${Sample}_g_m \
 --maf 0.01 \
 --make-bed \
 --keep-allele-order \
 --out ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf

plink --bfile ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf \
 --hwe 1e-6 \
 --make-bed \
 --keep-allele-order \
 --out ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf_hwe

echo "=========================================="
echo "             

                    Sample QC_end 

"
echo "=========================================+"


#===============================================================================================================================

#Create QC & MaMi/MiMa.binary file 

cp -v ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf_hwe.bim ${result_folder}/MaMi/QC_${Sample}.bim
cp -v ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf_hwe.bed ${result_folder}/MaMi/QC_${Sample}.bed
cp -v ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf_hwe.fam ${result_folder}/MaMi/QC_${Sample}.fam

#/scratch/x1997a11/GWAS/pdxen_AD/Code_folder/keep_allele_order_version/2_Single_CaseControl_analysis_major_kao.sh ${Sample}

#paste -d '\t' ${result_folder}/MiMa/raw_12345bim.bim  ${result_folder}/MaMi/raw_Minor_merge_case.bim > ${result_folder}/MiMa/QC_${Sample}.bim
#cp -v ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf_hwe.bed ${result_folder}/MiMa/QC_${Sample}.bed
#cp -v ${result_folder}/MaMi/NoQC_${Sample}_g_m_maf_hwe.fam ${result_folder}/MiMa/QC_${Sample}.fam
#=============================================================================
#분석에 사용한 데이터 제거
#rm ${result_folder}/MaMi/raw_*
#rm ${result_folder}/MaMi/raw_*
#rm ${result_folder}/MiMa/raw_*

