#!/bin/bash
Input=$1
Input_folder="/data/keeyoung/predixcan/PrediXcan/ref/input"
GWAS_TOOLS="/data/keeyoung/predixcan/PrediXcan/summary-gwas-imputation-master/src"
predixcan_TOOLS="/data/keeyoung/predixcan/PrediXcan/MetaXcan-master/software"
DATA="/data/keeyoung/predixcan/PrediXcan/MetaXcan_samples/data"
OUTPUT="/data/keeyoung/predixcan/PrediXcan/ref"
Code="/data/keeyoung/predixcan/PrediXcan/ref"
REFERENCE="/data/keeyoung/Reference"
GTEx_v8_eqtl_mashr="/data/keeyoung/Reference/GTEx_v8/MASHR_based_models/eqtl/mashr"

mkdir ${OUTPUT}/spredixcan
mkdir ${OUTPUT}/spredixcan/${Input}
for A in $(cat ${GTEx_v8_eqtl_mashr}/mashr.list)
do
python ${predixcan_TOOLS}/SPrediXcan.py \
 --gwas_file  ${OUTPUT}/processed_summary_imputation/imputed_${Input}.txt.gz \
 --snp_column panel_variant_id \
 --effect_allele_column effect_allele \
 --non_effect_allele_column non_effect_allele \
 --zscore_column zscore \
 --model_db_path ${GTEx_v8_eqtl_mashr}/${A}.db \
 --covariance ${GTEx_v8_eqtl_mashr}/${A}.txt.gz \
 --keep_non_rsid \
 --additional_output \
 --model_db_snp_key varID \
 --throw \
 --output_file ${OUTPUT}/spredixcan/${Input}/${Input}_PM_${A}.csv
done
