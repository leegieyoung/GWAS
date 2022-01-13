#!/bin/sh
awk '{print $1, $3, $4, $5, $6}' test.eigenvec > raw_PCA.csv
awk '{print $1}' raw_PCA.csv > sample.txt
sed -i '1i\sample' sample.txt
awk '$1="Case" {print $0}' raw_PCA.csv > raw_PCA.txt
sed -i '1i\name PC1 PC2 PC3 PC4' raw_PCA.txt
paste -d ' ' raw_PCA.txt sample.txt > PCA.txt

