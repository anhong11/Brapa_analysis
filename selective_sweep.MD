# B. rapa selective sweep analysis

## Phase SNPs with [Beagle](https://faculty.washington.edu/browning/beagle/beagle.html#download)
### 1. Search and download the published genetic map, reformat it and manually check the genetic map is in an increasing order
the file is _bra_cM.txt_, format is: marker mean_physical_this_marker mean_physical_next_marker genetic_this_marker genetic_next_marker
```
A01start  A01 1 200000  0.00  0.00 ##add this line for each chr manually
A01bin001	A01 200000	550000	0.00	1.37
A01bin002	A01 550000	800000	1.37	2.02
A01bin003	A01 800000	1000000	2.02	2.70
...
A01bin088	A01 29350000		106.84	
```
### 2. Prepare cM added map file for Beagle
```
grep '^A' brapa_onlySRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf | awk '{print $3"\t"$1"\t"$2}' - > brapa_onlySRA_snp_pos.txt
cat bra_cM.txt brapa_onlySRA_snp_pos.txt > bra_merged_cM_snp.txt
sort -k2,2 -k3,3n bra_merged_cM_snp.txt > bra_merged_cM_snp_sort.txt

perl get_snp_cm_beagle.pl bra_merged_cM_snp_sort.txt bra_only_beagle.map
```
### 3. Run Beagle 
```
sbatch -n 12 --mem 96G -t 2-00:00 -p Lewis,BioCompute --wrap="java -Xmx90G -jar beagle.25Mar22.4f6.jar gt=brapa_onlySRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf out=bra_only_phased map=bra_only_beagle.map nthreads=12"
``` 

## Use cross population methods [selscan](https://github.com/szpiech/selscan)(XP-nSL) and [XPCLR](https://github.com/anhong11/Brapa_analysis/blob/main/scripts/XPCLR.zip) detect selective sweep 

### Run selscan (need to run for each chr)
#### 1. Split phased vcf in each chr
```
head -n 9 bra_only_phased.vcf > bra_only_phased.head

sbatch -n 1 --mem 16G --wrap="sh extract_chr_vcf.sh chr.name"   ## chr.name: A01...A10, each chr in one line
```
#### 2. Extract vcf file for each group
```
sbatch -n 1 --mem 8G -t 2:00:00 --wrap="perl extract_vcf.pl chr.name group.file"
```
group.file looks like:
```
brown
ca_tn
ch_oil
euro_tn
...
```
and match brown.txt, ca_tn.txt ... files which contain accession id
#### 3. Run xpnsl and norm xpnsl results in selscan
```
sbatch -n 8 --mem 64G -t 1-00:00 -p Lewis,BioCompute --wrap="sh xpnsl_napa.sh ../chr.name"
```
And the _xpnsl_napa.sh_:
```
while read line
do
	selscan --xpnsl --vcf ../vcf_group/napa_"$line".vcf --vcf-ref ../vcf_group/wild_"$line".vcf --out napa_wild_$line --threads 8
done<$1

norm --xpnsl --files napa_wild_A01.xpnsl.out napa_wild_A02.xpnsl.out napa_wild_A03.xpnsl.out napa_wild_A04.xpnsl.out napa_wild_A05.xpnsl.out napa_wild_A06.xpnsl.out napa_wild_A07.xpnsl.out napa_wild_A08.xpnsl.out napa_wild_A09.xpnsl.out napa_wild_A10.xpnsl.out --bp-win

mkdir napa
mv napa_wild* napa
```
Then, do the other groups in the same way.   
#### 4. Add chr in each windows outputs, and finalize the selected region
```
sh after_xpnsl_merge.sh folder.name

#top 1% regions of the highest "fraction of XP-nSL scores >2" are defined as selected regions: num="wc -l napa_wild_all_norm.100kb.windows"; num*0.01; decide "head -n 30"

```
And the _after_xpnsl_merge.sh_:
```
while read line
do
	cd $line
	for chr in A01 A02 A03 A04 A05 A06 A07 A08 A09 A10
	do
		sed "s/^/$chr\t/" "$line"_wild_"$chr".xpnsl.out.norm.100kb.windows >> "$line"_wild_all_norm.100kb.windows
	done
	
	sort -k5,5nr "$line"_wild_all_norm.100kb.windows | head -n 30 - | sort -k1,1 -k2,2n - > "$line"_wild_all_norm.100kb.selected.windows
	perl ../merge_xpnsl_region.pl "$line"_wild_all_norm.100kb.selected.windows "$line"_wild_all_norm.100kb.selected.merged.windows
	cd ..
done<$1
```
Tips: header for norm --bp-win output is:
```
<win start> <win end> <# scores in win> <frac scores gt threshold> <frac scores lt threshold> <approx percentile for gt threshold wins> <approx percentile for lt threshold wins> <max score> <min score>
```
and "frac scores gt threshold" means "the fraction of XP-nSL scores >2"

### Run XPCLR (need to run for each chr)
#### 1. Add gen_dist to QUAL of vcf file (not the best way to prepare .map, but already did it for xpclr)
```
grep "^#" bra_only_phased.vcf > bra_only_phased.head
grep "^A" bra_only_phased.vcf > bra_only_phased.body

awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' bra_only_phased.body > fake_vcf.txt
awk '{print $3}' beagle_phase/bra_only_beagle.map > gen_dist.txt

paste fake_vcf.txt gen_dist.txt > fake_vcf_gendist.txt
sed -i 's/$/\tGT\t0|0/g' fake_vcf_gendist.txt

# Add chr infomation and modify bra_only_phased.head, only keep one sample in #CHR line, and save as fake_gendist.head
#chr info:
	##contig=<ID=A01,length=29595527>
	##contig=<ID=A02,length=31442979>
	##contig=<ID=A03,length=38154160>
	##contig=<ID=A04,length=21928416>
	##contig=<ID=A05,length=28493056>
	##contig=<ID=A06,length=29167992>
	##contig=<ID=A07,length=28928902>
	##contig=<ID=A08,length=22981702>
	##contig=<ID=A09,length=45156810>
	##contig=<ID=A10,length=20725698>

cat fake_gendist.head fake_vcf_gendist.txt > fake_gendist.vcf

#Transfere INFO from fake vcf to bra_only_phased.vcf

bcftools view -O b fake_gendist.vcf -o fake_gendist.bcf
bcftools view -O b bra_only_phased.vcf -o bra_only_phased.bcf
bcftools index fake_gendist.bcf 
bcftools index bra_only_phased.bcf

bcftools annotate -a fake_gendist.bcf -c INFO bra_only_phased.bcf > bra_only_phased_gendist.vcf

# Transfere cM from INFO to QUAL column:
sbatch -n 1 --mem 16G -t 2:00:00 --wrap=" sed -i 's/\.\t\PASS\t\([0-9]\+\.[0-9]\+\)\t/\1\t\PASS\t.\t/g' bra_only_phased_gendist.vcf"
sbatch -n 1 --mem 16G -t 2:00:00 --wrap="sed -i 's/\.\t\PASS\t\([0-9]\+\)\t/\1\t\PASS\t.\t/g' bra_only_phased_gendist.vcf"
```
#### 2. Prepare .map file
```
grep '^A' bra_only_phased_gendist.vcf > bra_only_phased_gendist.body
awk '{print $3"\t"$1"\t"$8"\t"$2"\t"$4"\t"$5}' bra_only_phased_gendist.body > bra_only_snp_cM_xpclr.map
sed -i 's/gen_dist=//g' bra_only_snp_cM_xpclr.map
sh get_chr_map.sh chr.name
```
And _get_chr_map.sh_ is:
```
while read line
do
	grep "$line" bra_only_snp_cM_xpclr.map > bra_only_snp_cM_"$line".map
done<$1
```
#### 3. Prepare .geno file
```
sh get_chr_vcf.sh chr.name
sh get_group_vcf.sh chr.name
sh get_geno_xpclr.sh group.name
```
And _get_chr_vcf.sh_ is:
```
while read line
do
	grep "$line" bra_only_phased.vcf | cat bra_only_phased.header - > bra_only_phased_chr"$line".vcf
done<$1
```
And _get_group_vcf.sh_ is:
```
while read line
do
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep ca_tn.txt --recode --out ca_tn_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep euro_tn.txt --recode --out euro_tn_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep feral.txt --recode --out feral_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep grelos.txt --recode --out grelos_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep jp_leaf.txt --recode --out jp_leaf_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep jp_tn.txt --recode --out jp_tn_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep me_tn.txt --recode --out me_tn_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep napa.txt --recode --out napa_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep pakchoi.txt --recode --out pakchoi_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep rapini.txt --recode --out rapini_phased_chr"$line"
	vcftools --vcf bra_only_phased_chr"$line".vcf --keep wild.txt --recode --out wild_phased_chr"$line"
done<$1
```
And _get_geno_xpclr.sh_ is:
```
while read line
do
	for chr in A01 A02 A03 A04 A05 A06 A07 A08 A09 A10
	do
		awk '{if($0!~/^#/){for(i=10;i<=NF;i++) printf $i"\t"FS;print ""}}' "$line"_phased_chr"$chr".vcf > "$line"_chr"$chr".tmp1
		sed 's/\t / /g' "$line"_chr"$chr".tmp1 > "$line"_chr"$chr".tmp2
		sed 's/ $//g' "$line"_chr"$chr".tmp2 > "$line"_chr"$chr".tmp3
		sed 's/\./9/g' "$line"_chr"$chr".tmp3 > "$line"_chr"$chr".tmp4
		sed 's/|/ /g' "$line"_chr"$chr".tmp4 > "$line"_chr"$chr".geno
		rm "$line"_chr"$chr".tmp*
	done
done<$1
```
#### 4. Run XPCLR
```
sh run_xpclr.sh cultivar.name  ###cultivar.name is the same group.name, but delete the line "wild"
sh merge_chr.sh cultivar.name
sh merge_xpclr_region.sh cultivar.name   ###Here we choose top 3% as the selected region
```
And _run_xpclr.sh_ is:
```
while read line
do
	for chr in 2 3 4 5 6 7 8 10
	do
		if [ $chr == 10 ];
		then
			XPCLR -xpclr ./geno_file/"$line"_chrA"$chr".geno ./geno_file/wild_chrA"$chr".geno bra_only_snp_cM_A"$chr".map "$line"_wild_chrA"$chr" -w1 0.005 100 1000 $chr p1 0.7
		else
			XPCLR -xpclr ./geno_file/"$line"_chrA0"$chr".geno ./geno_file/wild_chrA0"$chr".geno bra_only_snp_cM_A0"$chr".map "$line"_wild_chrA0"$chr" -w1 0.005 100 1000 $chr p1 0.7
		fi
	done
	mkdir $line
	mv "$line"_wild_ch* $line
done<$1
```
 _merge_chr.sh_ is:

```
while read line
do
	cd $line
	for chr in A01 A02 A03 A04 A05 A06 A07 A08 A09 A10
	do
		cat "$line"_wild_chr"$chr".xpclr.txt >> "$line"_wild_allchr.xpclr.txt
	done
	cd ..
done<$1
```
_merge_xpclr_region.sh_ is:
```
while read line
do
	cd $line
	perl ../merge_xp_clr_region_top3.pl -i "$line"_wild_allchr.xpclr.txt -o $line
	perl ../refmt_XPCLR_selected_region.pl "$line".XP-CLR.selected_region "$line".XP-CLR.selected_region_fmt
	cd ..
done<$1
```
### Combine the results of two methods
```
grep 'gene' Brapa_genome_v3.0_genes.gff3 | awk '{print $1"\t"$4"\t"$5"\t"$9}' - | sed 's/ID=\(B.*\);Na.*/\1/g' > Bra_geneloc.txt

sh combine_getGene.sh folder.name
```
And the _combine_getGen.sh_:
```
while read line
do
	grep '^A' "$line"* | cat - | sed 's/[a-z].*://g' - | sort -k1,1 -k2,2n - > "$line"_wild_combined.txt
	awk '{print $1"\t"$2"\t"$3"\t"$4}' "$line"_wild_combined.txt > "$line"_wild_combined_fmt.txt
	perl merge_combined.pl "$line"_wild_combined_fmt.txt "$line"_wild_combined_fmt_merge.txt
	perl get_select_gene.pl Bra_geneloc.txt "$line"_wild_combined_fmt_merge.txt "$line"_wild_gene
	mkdir $line
	mv "$line"_wild* $line
done<$1
```
### Annotate the selected gene
```
sh add_annot.sh group.name
```
And the _add_annot.sh_ is:
```
while read line
do
	perl annot_ath.pl Bra2Ath_use.txt "$line"_wild_gene "$line"_wild_gene_annot
done<$1
```
