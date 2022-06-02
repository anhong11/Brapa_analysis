###Usage: perl annot_ath.pl Bra2Ath.txt gene.file output
open ANN,"$ARGV[0]";
open IN,"$ARGV[1]";
open OUT,">$ARGV[2]";

my %hash;

while(<ANN>){
	chomp;
	my @array= split /\t/,$_;
	my $athgene = $array[1];
	$athgene =~ s/\.[0-9]+//;
	$hash{$array[0]}="$athgene\t$array[1]";
}

while(<IN>){
	chomp;
	my @array2 = split /\t/,$_;
	if(exists $hash{$array2[4]}){
		print OUT "$_\t$hash{$array2[4]}\n";
	}else{
		print OUT "$_\t-\t-\n";
	}
}
