open IN, "$ARGV[0]";
open OUT, ">$ARGV[1]";

print OUT "CHR\tStart\tEnd\tSize\tMax_XPCLR\tMean_XPCLR\tSource\n";

while(<IN>){
	chomp;
	if($_ =~/^#/){
		next;
	}else{
		my @array = split /\t/,$_;
		if ($array[0] == 10){
			print OUT "A$array[0]\t$array[2]\t$array[3]\t$array[4]\t$array[5]\t$array[6]\tXPCLR\n";
		}else{
			print OUT "A0$array[0]\t$array[2]\t$array[3]\t$array[4]\t$array[5]\t$array[6]\tXPCLR\n";
		}
	}
}
