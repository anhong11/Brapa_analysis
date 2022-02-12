vcfutils.pl varFilter brapa_outgrpAll_gatk.vcf > brapa_outgrpAll_gatk.vcfutils.vcf

grep -v "MQ=NaN" brapa_outgrpAll_gatk.vcfutils.vcf | grep -v "MQ=Infinity" - > a

vcffilter -f "DP > 10 & MQ > 30" a > brapa_outgrpAll_gatk.vcfutils.DP10MQ30.vcf
bcftools view -v snps -O v brapa_outgrpAll_gatk.vcfutils.DP10MQ30.vcf > brapa_outgrpAll_gatk.vcfutils.DP10MQ30.snp.vcf

rm a
