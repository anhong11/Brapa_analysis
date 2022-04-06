##Use this script to remove the invarious site in FASTA format
##Usage: perl rmInvar4raxml.pl invarious_site_from_raxml_log original_fasta_file output_only_various_fasta

open SNP, "$ARGV[0]";
open OUT, ">$ARGV[2]";

my %hash;

while (<SNP>){
        chomp;
        $hash{$_}=1;
}

use Bio::SeqIO;
my $in = Bio::SeqIO->new(-file => "$ARGV[1]" ,-format => 'fasta');
while(my $obj=$in->next_seq()){
        my $id =$obj->id;
        my $seq = $obj->seq;
        print OUT ">$id\n";
        my $length=length($seq);
        for ($i=0; $i<$length; $i++){
                my $site=$i+1;
                my $bp=substr($seq,$i,1);
                if(exists $hash{$site}){
                }else{
                        print OUT "$bp";
                }
        }
        print OUT "\n";
}
