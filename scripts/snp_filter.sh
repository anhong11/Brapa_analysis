vcfutils.pl varFilter brapa_outgrpAll_gatk.vcf > brapa_outgrpAll_gatk.vcfutils.vcf

grep -v "MQ=NaN" brapa_outgrpAll_gatk.vcfutils.vcf | grep -v "MQ=Infinity" - > a

vcffilter -f "DP > 10 & MQ > 30" a > brapa_outgrpAll_gatk.vcfutils.DP10MQ30.vcf
bcftools view -v snps -O v brapa_outgrpAll_gatk.vcfutils.DP10MQ30.vcf > brapa_outgrpAll_gatk.vcfutils.DP10MQ30.snp.vcf

rm a

vcftools --vcf brapa_outgrpAll_gatk.vcfutils.DP10MQ30.snp.vcf --plink --out brapa_outgrpAll_gatk.vcfutils.DP10MQ30.snp.plink

sed -i 's/^0\t\(A[0-1][0-9]\)/\1\t\1/g' brapa_outgrpAll_gatk.vcfutils.DP10MQ30.snp.plink.map
plink --file brapa_outgrpAll_gatk.vcfutils.DP10MQ30.snp.plink --recode vcf --out brapa_outgrpAll_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp --noweb --geno 0.1 --maf 0.05 --allow-extra-chr
