open IN, "$ARGV[0]";
open OUT, ">$ARGV[1]";

my $chr="B00";
my $start=0;
my $end=0;
my $score=0;
my $norm=0;
my $num=1;

while(<IN>){
	chomp;
	my @array = split /\t/,$_;
	my $new_pos = $array[2]-1;
	if($new_pos eq $end){
		$score = $score + $array[11];
		$norm = $norm + $array[12];
		$num = $num +1;
		$end = $array[3];
		if(eof(IN)){
			my $avg_score = $score/$num;
			my $avg_norm = $norm/$num;
			my $size = $end-$start+1;
                        print OUT "$chr\t$start\t$end\t$size\t$avg_score\t$avg_norm\txpclr\n";
                }
		
	}else{
		my $avg_score = $score/$num;
		my $avg_norm = $norm/$num;
		my $size =$end-$start+1;
		print OUT "$chr\t$start\t$end\t$size\t$avg_score\t$avg_norm\txpclr\n";
		$chr = $array[1];
		$start = $array[2];
		$end = $array[3];
		$score = $array[11];
		$norm = $array[12];
		$num = 1;
		if(eof(IN)){
			$size =$end-$start+1;
			print OUT "$chr\t$start\t$end\t$size\t$score\t$norm\txpclr\n";
		}
	}
}

system(`sed -i 's/B.*/CHR\tStart\tEnd\tSize\txpclr\tnorm_xpclr\tsource/g' $ARGV[1]`)
