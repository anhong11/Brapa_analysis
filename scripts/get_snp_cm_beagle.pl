open IN, "$ARGV[0]";
open OUT, ">$ARGV[1]";

##usage: perl get_snp_cm_beagle.pl bra_merged_cM_snp_sort.txt output.file

my (@array, $start_cm, $start_pos, $end_cm, $end_pos, $cm, $pos);


while (<IN>){
	chomp;
	@array = split /\t/, $_;
	if (exists $array[4] and exists $array[5]){
	$start_cm = $array[4];
	$end_cm = $array[5];
	$start_pos = $array[2];
	$end_pos = $array[3];
	#print OUT "$_\n";
	}elsif(($start_pos>0)and($array[4] eq "")){
		$pos = $array[2];
		my @chr_arr = split /:/, $array[0];
		$cm = $start_cm+($end_cm-$start_cm)/($end_pos-$start_pos)*($pos-$start_pos);
		#print OUT "$_\t$pos\t$start_cm\t$end_cm\t$cm\n";
		#my $cm_6 = sprintf("%.6f", $cm);
		print OUT "$chr_arr[0]\t.\t$cm\t$pos\n";
	}else{
		#print OUT "$_\n";
	}
	
}
