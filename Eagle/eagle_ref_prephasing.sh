#!/bin/sh
input=$1
path="/scratch/hpc46a05/GWAS/Code/Eagle2_code_folder"
REFERENCE="/scratch/hpc46a05/GWAS/1000G/b37.bcf"
raw_data_folder="/scratch/hpc46a05/GWAS/raw_data/Eagle/${input}"
Output_folder="/scratch/hpc46a05/GWAS/Eagle2_result"


for A in {1..22}
do
${path}/eagle \
 --vcfRef=${REFERENCE}/ALL.chr$A.phase3_integrated.20130502.genotypes.bcf \
 --vcfTarget=${raw_data_folder}/${input}_chr$A.vcf.gz \
 --geneticMapFile=${path}/genetic_map_hg19.txt.gz \
 --allowRefAltSwap \
 --outPrefix=${Output_folder}/${input}_chr$A.phased 
done
