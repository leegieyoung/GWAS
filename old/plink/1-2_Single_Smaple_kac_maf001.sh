#!/bin/sh
if [ $# -ne 1 ];then
        echo "Please enter merge_result/input1"
               exit
fi
#Sample = AD_14 등으로 기록되어있어야 함
OUTPUT=$1
GWAS_path="/scratch/hpc46a05/GWAS/result"
code_path="/scratch/hpc46a05/GWAS/Code/plink_code_folder"
mkdir ${GWAS_path}/QC_Imputed_${OUTPUT}
result_folder="${GWAS_path}/QC_Imputed_${OUTPUT}"
#imputed_sample folder
raw_folder="/data/keeyoung/GWAS/raw_data/"
#beagle_folder="/scratch/x1997a11/GWAS/pdxen_AD/beagle/Result_folder"

#1.SampleQC(geno mind impute-sex hwe)
mkdir ${result_folder}/raw_merge
mkdir ${result_folder}/QC
mkdir ${result_folder}/MaMi


#.mergelist
mv ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}.bed ${result_folder}/QC/raw_NoQC_rmmissnp_Imputed_${OUTPUT}.bed
mv ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}.bim ${result_folder}/QC/raw_NoQC_rmmissnp_Imputed_${OUTPUT}.bim
mv ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}.fam ${result_folder}/QC/raw_NoQC_rmmissnp_Imputed_${OUTPUT}.fam

# QC
plink --bfile ${result_folder}/QC/raw_NoQC_rmmissnp_Imputed_${OUTPUT} \
 --geno 0.2 \
 --keep-allele-order \
 --make-bed \
 --out ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g

plink --bfile ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g \
 --mind 0.2 \
 --keep-allele-order \
 --make-bed \
 --out ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m

plink --bfile ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m \
 --maf 0.05 \
 --keep-allele-order \
 --make-bed \
 --out ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf

plink --bfile ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf \
 --hwe 1e-6 \
 --keep-allele-order \
 --make-bed \
 --out ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf_hwe

mv ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf_hwe.bed ${result_folder}/MaMi/QC_Imputed_${OUTPUT}.bed
mv ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf_hwe.bim ${result_folder}/MaMi/QC_Imputed_${OUTPUT}.bim
mv ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf_hwe.fam ${result_folder}/MaMi/QC_Imputed_${OUTPUT}.fam

rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g.bed
rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g.bim
rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g.fam

rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m.bed
rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m.bim
rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m.fam

rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf.bed
rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf.bim
rm ${result_folder}/QC/raw_NoQC_Imputed_${OUTPUT}_g_m_maf.fam
