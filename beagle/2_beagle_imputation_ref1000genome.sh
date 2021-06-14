#!/bin/sh
#raw 데이터는 모두 준비가 되어 있어야 함
#raw.vcf 면 됨
if [ $# -ne 2 ];then
	echo "Please enter ##"
		exit
fi
input=$1
Sample=QC_${input}
Chrom=$2
Beagle_Code_folder="/scratch/x1997a11/GWAS/pdxen_AD/beagle/Code_folder"
Sample_folder="/scratch/x1997a11/GWAS/pdxen_AD/beagle/Sample_folder/${Sample}"
Reference_folder="/scratch/x1997a11/REFERENCE/Microarray/1000genomes"
Reference_bref3="/scratch/x1997a11/REFERENCE/Microarray/1000genomes"
Result_folder="/scratch/x1997a11/GWAS/pdxen_AD/beagle/Result_folder"

mkdir ${Result_folder}/conform-gt_${Sample}
java -Xmx64g -jar ${Beagle_Code_folder}/conform-gt.24May16.cee.jar \
 ref=${Reference_folder}/chr${Chrom}.1kg.phase3.v5a.vcf.gz \
 gt=${Sample_folder}/CHR${Chrom}_${Sample}_noIndel_rmDupID.vcf.gz \
 chrom=${Chrom} \
 out=${Result_folder}/conform-gt_${Sample}/raw_CHR${Chrom}_${Sample}_noIndel_rmDupID_beagle \
 match=POS

mkdir ${Result_folder}/imputed_${Sample}
java -Xmx64g -jar ${Beagle_Code_folder}/beagle.18May20.d20.jar \
 ref=${Reference_bref3}/chr${Chrom}.1kg.phase3.v5a.b37.bref3 \
 gt=${Result_folder}/conform-gt_${Sample}/raw_CHR${Chrom}_${Sample}_noIndel_rmDupID_beagle.vcf.gz \
 chrom=${Chrom} \
 out=${Result_folder}/imputed_${Sample}/CHR${Chrom}_${Sample}_noIndel_rmDupID_beagle \
 impute=true ap=true window=30
