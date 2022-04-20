open IN, "$ARGV[0]";
open OUT, ">$ARGV[1]";

my $chr="B00";
my $start=0;
my $end=0;
my $score=0;
my $frac=0;
my $num=1;

while(<IN>){
        chomp;
        my @array = split /\t/,$_;
        my $new_pos = $array[1];
        if($new_pos eq $end){
                if($array[8] > $score){
                        $score = $array[8];
                }
                $frac = $frac + $array[4];
                $num = $num +1;
                $end = $array[2];
                if(eof(IN)){
                        my $avg_frac = $frac/$num;
                        my $size =$end-$start;
                        print OUT "$chr\t$start\t$end\t$size\t$score\t$avg_frac\txpnsl\n";
                }
                
        }else{
                my $avg_frac = $frac/$num;
                my $size =$end-$start;
                print OUT "$chr\t$start\t$end\t$size\t$score\t$avg_frac\txpnsl\n";
                $chr = $array[0];
                $start = $array[1];
                $end = $array[2];
                $score = $array[8];
                $frac = $array[4];
                $num = 1;
                if(eof(IN)){
                        $size = $end-$start;
                        print OUT "$chr\t$start\t$end\t$size\t$score\t$frac\txpnsl\n";
                }
        }
}


system(`sed -i 's/B.*/CHR\tStart\tEnd\tSize\txpclr\tnorm_xpclr\tSource/g' $ARGV[1]`)
