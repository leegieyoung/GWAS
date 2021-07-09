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

. /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate sumgwas

#mkdir ${OUTPUT}/harmonized_gwas
#python ${GWAS_TOOLS}/gwas_parsing.py \
# -gwas_file ${Input_folder}/${Input}.txt.gz \
# -liftover ${DATA}/liftover/hg19ToHg38.over.chain.gz \
# -snp_reference_metadata ${DATA}/reference_panel_1000G/variant_metadata.txt.gz METADATA \
# -output_column_map SNP variant_id \
# -output_column_map A2 non_effect_allele \
# -output_column_map A1 effect_allele \
# -output_column_map BETA effect_size \
# -output_column_map P pvalue \
# -output_column_map CHR chromosome \
# --chromosome_format \
# -output_column_map BP position \
# -output_column_map MAF frequency \
# --insert_value sample_size 199 --insert_value n_cases 100 \
# -output_order variant_id panel_variant_id chromosome position effect_allele non_effect_allele frequency pvalue zscore effect_size standard_error sample_size n_cases \
# -output ${OUTPUT}/harmonized_gwas/${Input}.txt.gz

mkdir ${OUTPUT}/summary_imputation
for A in $(seq 1 22)
do
echo "========================"
echo "    Start chr ${A}"
echo "========================"
python ${GWAS_TOOLS}/gwas_summary_imputation.py \
 -by_region_file ${DATA}/refCheckedRmDup.ld.bed.gz \
 -gwas_file ${OUTPUT}/harmonized_gwas/${Input}.txt.gz \
 -parquet_genotype ${DATA}/reference_panel_1000G/chr${A}.variants.parquet \
 -parquet_genotype_metadata ${DATA}/reference_panel_1000G/variant_metadata.parquet \
 -window 100000 \
 -parsimony 7 \
 -chromosome ${A} \
 -regularization 0.1 \
 -frequency_filter 0.01 \
 -sub_batches 10 \
 -sub_batch 0 \
 --standardise_dosages \
 -output ${OUTPUT}/summary_imputation/${Input}_chr${A}_sb0_reg0.1_ff0.01_by_region.txt.gz
done


echo "========================"
echo "    Start imputation"
echo "========================"
mkdir ${OUTPUT}/processed_summary_imputation
python ${GWAS_TOOLS}/gwas_summary_imputation_postprocess.py \
 -gwas_file ${OUTPUT}/harmonized_gwas/${Input}.txt.gz\
 -folder ${OUTPUT}/summary_imputation \
 -pattern ${Input}.* \
 -parsimony 7 \
 -output ${OUTPUT}/processed_summary_imputation/imputed_${Input}.txt.gz

. /usr/local/miniconda3/etc/profile.d/conda.sh
conda activate predixcan
#predixcan.sh
echo "========================"
echo "    Start predixcan"
echo "========================"
bash ${Code}/predixcan.sh ${Input}

#
echo "========================"
echo "   Start smultixcan"
echo "========================"
bash ${Code}/smultixcan.sh ${Input}

