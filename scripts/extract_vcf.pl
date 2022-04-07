open CHR, "$ARGV[0]";

while (<CHR>){
	chomp;
	my $chrom=$_;
	open GRP, "$ARGV[1]";
	while(<GRP>){
		chomp;
		my $group=$_;
		system(`vcftools --vcf bra_only_phased_"$chrom".vcf --keep "$group".txt --recode --out "$group"_"$chrom"; mv "$group"_"$chrom".recode.vcf "$group"_"$chrom".vcf`)
	}
	close GRP;
}
