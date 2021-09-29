#!/bin/sh
wget -O- ftp://ftp.1001genomes.ebi.ac.uk/vol1/ftp/technical/reference/human_g1k_v37.fasta.gz | \
  gzip -d > human_g1k_v37.fasta
samtools faidx human_g1k_v37.fasta

for chr in {1..22}
do
wget http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/ALL.chr$chr.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
wget http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/ALL.chr$chr.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz.tbi
done

for chr in {1..22}
do
bcftools view --no-version -Ou -c 2 ALL.chr$chr.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz | \
bcftools norm --no-version -Ou -m -any | \
bcftools norm --no-version -Ob -o ALL.chr$chr.phase3_integrated.20130502.genotypes.bcf -d none -f human_g1k_v37.fasta
bcftools index -f ALL.chr${chr}.phase3_integrated.20130502.genotypes.bcf
done

