#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Std;

# zhanglei, 2016-12-15

our ($opt_i, $opt_s, $opt_w, $opt_o);
getopt("i:s:w:o:");

unless ( $opt_i && $opt_o) {
	&usage;
	exit(1);
}

# default parameters
$opt_w = $opt_w || 20;
$opt_s = $opt_s || 10;

=pod
input format
# chr# grid# #ofSNPs_in_window physical_pos genetic_pos XPCLR_score max_s
# 1 0 3 1426283.000000 0.827476 7.034896 0.003000
=cut

=pod
Mean likelihood score was calculated using 20kb sliding windows with a step size of 10kb across the genome. 
Adjacent windows with XP-CLR values in the top 20% were grouped into a single region. 
Merged regions across the genome with XP-CLR values in the top 5% were identified. 
=cut

# first, get all the results
print "Step1: loading the file...";
open IN, "<$opt_i" or die $!;
my %hash;
while (<IN>) {
	chomp;
	next if /SNPs_in_window/;
	my ($chr, $grid, $number, $pos, $score) = (split)[0, 1, 2, 3, 5];
	next if $number < 3;
	$chr =~ s/LG//;
	$hash{$chr}{$pos} = $score;
}
close IN;
print "done\n";

# second, using a sliding-window method to split genome
my @chr_array = keys %hash;
print "Step2: using a sliding-window method to split genome, " . "chromosome number: " . @chr_array . ", sliding window: $opt_w kb, step size: $opt_s kb.\n";
my %window_hash = ();
$opt_w = $opt_w * 1000;
$opt_s = $opt_s * 1000;
foreach my $chr (sort @chr_array) {
	my $chr_len = (sort {$a <=> $b} keys %{$hash{$chr}})[-1];
	# get the window number, window start, window end
	my $window_num = 0;
	if ($chr_len <= $opt_w) {               #windowsize greater than chro_length
		$window_num = 1;
		($window_hash{$chr}{$window_num}{start}, $window_hash{$chr}{$window_num}{end}) = (1, $chr_len);
	}else{                                  #windowsize less than chro_length
		$chr_len = $chr_len + 0;
		$window_num = &split_genome($chr, $chr_len);
	}
}

# caculate the average XP-CLR score of each window located in each chromosome
print "Step3: caculate the average XP-CLR of each window located in each chromosome\n";
open ALL, ">$opt_o.ALL.window_XP-CLR" or die $!;
print ALL "Chr\tnumber\tmiddle\tstart\tend\tsize\tmean_XP_CLR\n";
my @scores = ();
my %windows;
foreach my $chr (sort {$a <=> $b} @chr_array) {
	print "$chr\n";
	my @array = sort {$a <=> $b} keys %{$hash{$chr}};
	foreach my $window_number (sort {$a <=> $b} keys %{$window_hash{$chr}}) {
		my $average_score = 0;
		my $score_number = 0;
		my ($start, $end) = ($window_hash{$chr}{$window_number}{start}, $window_hash{$chr}{$window_number}{end});
		foreach (@array) {
			next if $_ < $start;
			last if $_ >= $end;
			next if $hash{$chr}{$_} eq "inf";
			$score_number++;
			$average_score += $hash{$chr}{$_};
		}
		$windows{$chr}{$window_number}{start} = $start;
		$windows{$chr}{$window_number}{end}   = $end;
		my $size = $end - $start + 1;
		my $middle = $start + int(($end - $start)/2);
		
		if ($score_number > 0) {
			$average_score = $average_score/$score_number;
#			print "$chr\t$window_number\t$start\t$end\n" unless $average_score =~ /(\d+)/;
			push @scores, $average_score;
		}
		else {
			$average_score = 0;
		}
		$windows{$chr}{$window_number}{score} = $average_score;
		print ALL "$chr\t$window_number\t$middle\t$start\t$end\t$size\t$average_score\n";
	}
}
close ALL;

# get the top 20% of the XP-CLR values
print "Step4, get the top 1st, 5%, 10%, 20% and 50% of the XP-CLR values...";
my $number = scalar @scores;
print "$number windows\n";
my @sorted = sort {$b <=> $a} @scores;
my $top = int(0.05 * $number);
my $threshod_5 = int($sorted[$top]);

$top = int(0.1 * $number);
my $threshod_10 = int($sorted[$top]);

$top = int(0.2 * $number);
my $threshod_20 = int($sorted[$top]);

$top = int(0.5 * $number);
my $threshod_50 = int($sorted[$top]);

my $first = int(shift @sorted);
print "$first\t$threshod_5\t$threshod_10\t$threshod_20\t$threshod_50\n";
open REGION, ">$opt_o.XP-CLR.selected_region";
print REGION "#top 1st: $first\n#5%: $threshod_5\n#10%: $threshod_10\n#20%: $threshod_20\n#50%: $threshod_50\n";

# filter score
my %deleted_windows;
foreach my $chr (sort {$a <=> $b} @chr_array) {
	foreach my $window_number (keys %{$windows{$chr}}) {
		my $score = $windows{$chr}{$window_number}{score};
		if ($score < $threshod_20) {
			delete $windows{$chr}{$window_number};
			$deleted_windows{$chr}{$window_number} = 1;
		}
	}
}

# merge the regions
print "Step5, merge the regions...";
my %merged;
my $ld = 2 * $opt_w;
my $buffer = int($ld/$opt_w);              
foreach my $chr (sort {$a <=> $b} @chr_array) {
	my $group = 1;
	my @window_numbers = sort {$a <=> $b} keys %{$windows{$chr}};
	next if @window_numbers == 0;
	my $query = shift @window_numbers;
	push @{$merged{$chr}{$group}}, $query;
	my $query_buffer = $query + $buffer;
	foreach my $window_number (@window_numbers) {
		if ($window_number <= $query_buffer) {
			push @{$merged{$chr}{$group}}, $window_number;
		}
		else {
			$group++;
			push @{$merged{$chr}{$group}}, $window_number;
		}
		$query = $window_number;
		$query_buffer = $query + $buffer;
	}
}
print "done\n";

# output the results
print "Step6, output the regions...";
my %edited;
print REGION "#chr\tgroup\tstart\tend\tsize\tmax_score\taverage_score\n";
foreach my $chr (sort {$a <=> $b} @chr_array) {
	foreach my $group (sort {$a <=> $b} keys %{$merged{$chr}}) {
		my @window_numbers = sort {$a <=> $b} @{$merged{$chr}{$group}};
		my $middle_number_index = int((scalar @window_numbers)/2);
		my $middle_number = $window_numbers[$middle_number_index];
		my $start = $windows{$chr}{$middle_number}{start};
		my $end = $windows{$chr}{$middle_number}{end};
		my $size = $end - $start + 1;
		my $middle = $start + int(($end - $start)/2);		
		my @scores;
		# only output the highest score
		my $score_total;
		foreach my $window_number (@window_numbers) {
			my $score = $windows{$chr}{$window_number}{score};
			$score_total += $score;
			push @scores, $score;
		}
		my $max_score = (sort {$a <=> $b} @scores)[-1];
		if ($max_score >= $threshod_5) {
			my $line = "$chr\t$middle_number\t$middle\t$start\t$end\t$size\t$max_score";
			$edited{$chr}{$middle_number} = $line;
		}
		
		# output the selected region
		$start = $windows{$chr}{$window_numbers[0]}{start};
		$end   = $windows{$chr}{$window_numbers[-1]}{end};
		$size = $end - $start + 1;
		my $average_score = $score_total/@scores;
		print REGION "$chr\t$group\t$start\t$end\t$size\t$max_score\t$average_score\n" if $max_score >= $threshod_5;
	}
}
close REGION;

open OUT, ">$opt_o.ALL.merged.window_XP-CLR";
open IN, "<$opt_o.ALL.window_XP-CLR";
while (<IN>) {
	chomp;
	print OUT "Chr\tnumber\tmiddle\tstart\tend\tsize\tmean_XP_CLR\n" and next if /number/;
	my ($chr, $number) = (split)[0,1];
	if (exists $edited{$chr}{$number}) {
		my $line = $edited{$chr}{$number};
		print OUT "$line\n";
	}
	else {
		my @array = (split);
#		$array[6] = 0;
		my $line = join("\t", @array);
		print OUT "$line\n";
	}
}
close IN;
close OUT;
print "done\n";

sub split_genome {
	my ($chro_id, $chro_length) = @_;
	my $window_number = 0;
	if((($chro_length - $opt_w)/$opt_s) =~ /^\d+$/){
		$window_number = int(($chro_length - $opt_w)/$opt_s) + 1;
	}else{
		$window_number = int(($chro_length - $opt_w)/$opt_s) + 2;
	}
	my $window_start = $window_hash{$chro_id}{'1'}{start} = 1;                    #the first window
	my $window_end   = $window_hash{$chro_id}{'1'}{end}   = $opt_w;
	for (my $i = 2; $i < $window_number; $i++) {                                  #the middle window
		$window_start += $opt_s;
		$window_end += $opt_s;
		$window_hash{$chro_id}{$i}{start} = $window_start;
		$window_hash{$chro_id}{$i}{end} = $window_end;
	}
	$window_start += $opt_s;      $window_end += $opt_s;                          #the last window
	$window_end = $chro_length if $window_end > $chro_length;
	my $last_window_size = $window_end - $window_hash{$chro_id}{$window_number - 1}{start} + 1;   #check the last window size, if less than 500kb, then merge it to the previous window
	if ($last_window_size <= $opt_w) {
		$window_number = $window_number - 1;
		$window_hash{$chro_id}{$window_number}{end} = $window_end;
	}else{
		($window_hash{$chro_id}{$window_number}{start}, $window_hash{$chro_id}{$window_number}{end}) = ($window_start, $window_end);
	}
	return $window_number;
}

sub usage {
print"Usage: $0 -OPTIONS VALUES
Options:
     -i  YES  file produced by the XP-CLR
     -o  YES  prefix of output file name
     -w  NO   windowsize to caculate the average XP-CLR(kilobase unit), default = 20kb
     -s  NO   step size, should be greater than 0kb and less than windowsize(kilobase unit), default = 10kb 
     \n"
}
