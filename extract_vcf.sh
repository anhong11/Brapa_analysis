while read line
do
	vcftools --vcf brapa_onlySRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --keep "$line".txt --recode --out $line
	mv "$line".recode.vcf "$line".vcf
done<$1
