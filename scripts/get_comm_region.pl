open PI, "$ARGV[0]"; #pi result
open OUT, ">$ARGV[2]";

my %hash;
while (<PI>){
	chomp;
	my ($chr, $start, $end)= split /\t/, $_;
	my $id="$chr"."_$start";
	$hash{$id} = $end;
}

while(($key, $value) = each %hash){
	my ($chr_pi, $start_pi)=split /_/, $key;
	#print "$start_pi\n";i
	my $end_pi=$value;
	my ($start_out, $end_out);
	open XP, "$ARGV[1]"; #xpclr result
	while (<XP>){
		chomp;
		if (/#/){next};
		my ($chr_xp, $grp, $start_xp, $end_xp)=split /\t/,$_;
		#print "$chr_xp\t$chr_pi\n";
		if ($chr_xp ne $chr_pi) {next};
		if ($start_xp>=$start_pi and $end_xp<=$end_pi){
			$start_out=$start_xp;
			$end_out=$end_xp;
		}
		if ($start_xp<=$start_pi and $end_xp>=$end_pi){
			$start_out=$start_pi;
			$end_out=$end_pi;
		}
		if ($start_xp<=$start_pi and $end_xp<=$end_pi and $end_xp>=$start_pi){
			$start_out=$start_pi;
			$end_out=$end_xp;
		}
		if ($start_xp>=$start_pi and $start_xp<=$end_pi and $end_xp>=$end_pi){
			$start_out=$start_xp;
			$end_out=$end_pi;
		}
		if ($start_out>0 and $end_out>0){
			$range= $end_out-$start_out+1;
			print OUT "$chr_xp\t$start_out\t$end_out\t$range\n";
			$start_out=0;
			$end_out=0;
		}
	}
	close XP;
}

system("sort -k1,1n -k2,2n $ARGV[2] > a");
system("mv a $ARGV[2]");
