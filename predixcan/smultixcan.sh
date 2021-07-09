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

mkdir ${OUTPUT}/smultixcan
mkdir ${OUTPUT}/smultixcan/${Input}

python ${predixcan_TOOLS}/SMulTiXcan.py \
 --models_folder ${GTEx_v8_eqtl_mashr} \
 --models_name_pattern "(.*).db" \
 --snp_covariance /data/keeyoung/Reference/GTEx_v8/MASHR_based_models/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz \
 --metaxcan_folder ${OUTPUT}/spredixcan/${Input} \
 --metaxcan_filter "${Input}_PM_(.*).csv" \
 --metaxcan_file_name_parse_pattern "(.*)_PM_(.*).csv" \
 --gwas_file ${OUTPUT}/processed_summary_imputation/imputed_${Input}.txt.gz \
 --snp_column panel_variant_id \
 --effect_allele_column effect_allele \
 --non_effect_allele_column non_effect_allele \
 --zscore_column zscore \
 --keep_non_rsid \
 --model_db_snp_key varID \
 --cutoff_condition_number 30 \
 --verbosity 7 \
 --throw \
 --output ${OUTPUT}/smultixcan/${Input}/${Input}.csv
