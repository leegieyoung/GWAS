#!/bin/sh
if [ $# -ne 1 ];then
        echo "Please enter Sample_Name"
               exit
fi
Sample=$1
GWAS_path="/scratch/x1997a11/GWAS/pdxen_AD/result_folder"
code_path="/scratch/x1997a11/GWAS/pdxen_AD/Code_folder"
Sample_folder="${GWAS_path}/QC_${Sample}"
#분석결과를 담을 파일
mkdir ${GWAS_path}/${Sample}_analysis_folder
analysis_folder="/${GWAS_path}/${Sample}_analysis_folder"
Case_pheno="${analysis_folder}/merge/Case_pheno.txt"
Control_pheno="${analysis_folder}/merge/Control_pheno.txt"
inversion="/scratch/x1997a11/GWAS/pdxen_AD/reference_folder/inversion.txt"
#=================================================================
conda activate predixcan

python /scratch/x1997a11/GWAS/PrediXcan/MetaXcan-master/software/SPrediXcan.py --model_db_path /scratch/x1997a11/REFERENCE/prediXcan/weights/gtex_v7_Whole_Blood_imputed_europeans_tw_0.5_signif.db --covariance /scratch/x1997a11/REFERENCE/prediXcan/covar_gtex/gtex_v7_Whole_Blood_imputed_eur_covariances.txt.gz --gwas_folder /scratch/x1997a11/GWAS/pdxen_AD/result_folder/Imputed_ADNI_JBB_1_blood_analysis_folder/merge/logistic/predixcan/ --gwas_file_pattern ".*gz"  --snp_colum rsID --effect_allele_column A1 --non_effect_allele_column A2 --beta_column BETA --pvalue_column P --output_file /scratch/x1997a11/GWAS/pdxen_AD/result_folder/Imputed_ADNI_JBB_1_blood_analysis_folder/merge/logistic/predixcan/test.csv

