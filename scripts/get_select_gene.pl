##Usage: perl get_select_gene.pl geneloc_from_gff select_region.txt output 

open GFF, "$ARGV[0]";
open OUT, ">$ARGV[2]";

my %hash;
while (<GFF>){
	chomp;
	my ($chr, $start, $end, $name)=split /\t/,$_;
	if ($start>$end){($start,$end)=($end,$start)};
	my $id = "$chr"."_$start"."_$end";
	$hash{$id}=$name;
}

while(($key, $value) = each %hash){
	my ($chr_gff, $start_gff, $end_gff)=split /_/,$key;
	open SLT, "$ARGV[1]";
	while (<SLT>){
		chomp;
		my ($chr_slt, $start_slt, $end_slt)=split /\t/,$_;
		if ($chr_slt ne $chr_gff){next};
		if ($start_slt<=$start_gff and $end_slt>=$end_gff){
			print OUT "$_\t$value\n";
			next;
		}
	}
	close SLT;
}

close OUT;
close GFF;

system("sort -k1,1 -k2,2n $ARGV[2] > a");
system("mv a $ARGV[2]");

open IN, "$ARGV[2]";
#open STL, "$ARGV[1]";
open OUT2, ">$ARGV[2]"."_oneline";

my $last_line;
while (<IN>){
	chomp;
	my ($chr_out, $start_out, $end_out, $range, $gene)=split /\t/,$_;
	my $out_id= "$chr_out"."_$start_out"."_$end_out";
	if ($out_id eq $last_line){
		print OUT2 ", $gene";
	}else{
		print OUT2 "\n$_";
	}
	$last_line=$out_id;
} 
close OUT2;

open SLT, "$ARGV[1]";
open ONE, "$ARGV[2]"."_oneline";
open OUT3, ">a";

my $out_file3="$ARGV[2]"."_oneline";

my %hash2;
while (<ONE>){
	chomp;
	my ($chr_one, $start_one, $end_one)=split /\t/,$_;
	my $id_one= "$chr_one"."_$start_one"."_$end_one";
	$hash2{$id_one}=$_;
}

while (<SLT>){
	chomp;
	my ($chr_slt, $start_slt, $end_slt)=split /\t/,$_;
	my $id_slt= "$chr_slt"."_$start_slt"."_$end_slt";
	if (exists $hash2{$id_slt}){
		print OUT3 "$hash2{$id_slt}\n";
	}else{
		print OUT3 "$_\t-\n";
	}
}

system("mv a $out_file3");
