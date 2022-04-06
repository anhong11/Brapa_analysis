###Usage: perl rename_fa.pl fasta.file population.txt output.file
###population.txt example:
###				3009	WEAm
###				2113	WEAm
###				3018	WEAm
###				2129	SK
###				3112	WEAm
###				3048	R

use Bio::SeqIO;

$fasta = $ARGV[0];

#system("sed -i 's/ | locus.*//g' $fasta");

open NAME, "$ARGV[1]";
open OUT, ">$ARGV[2]";

my %hash;
while(<NAME>){
	chomp;
	my ($num, $cluster)= split /\t/,$_;
	$hash{$num}=$cluster;
}

my $in = Bio::SeqIO->new(-file => "$fasta" ,-format => 'fasta');
while(my $obj=$in->next_seq()){
	my $id =$obj->id;
	$id =~ s/ind_//;
	my $desc =$obj->desc;
	$desc =~ s/\| population:Pop_1//;
	$name = "$hash{$id}"."_$id"." | population:$hash{$id}"."$desc";
	#print "$name\n";	
	my $seq = $obj->seq;
	$seq =~ s/\?/N/g;
	print OUT ">$name\n$seq\n";
}
