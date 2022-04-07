while read line
do
	grep "^$line" bra_only_phased.vcf | cat bra_only_phased.head - > bra_only_phased_"$line".vcf
done<$1
