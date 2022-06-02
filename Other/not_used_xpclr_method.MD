### Run [xpclr](https://github.com/hardingnj/xpclr) (need to run for each chr)
#### 1. install xpclr via conda
```
conda install xpclr -c bioconda
```
#### 2. add gen_dist to QUAL of vcf file
```
grep "^#" bra_only_phased.vcf > bra_only_phased.head
grep "^A" bra_only_phased.vcf > bra_only_phased.body

awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' bra_only_phased.body > fake_vcf.txt
awk '{print $3}' beagle_phase/bra_only_beagle.map > gen_dist.txt

paste fake_vcf.txt gen_dist.txt > fake_vcf_gendist.txt
sed -i 's/$/\tGT\t0|0/g' fake_vcf_gendist.txt

# Add chr infomation and modify bra_only_phased.head, only keep one sample in #CHR line, and save as fake_gendist.head
#chr info:
	#contig=<ID=A01,length=29595527>
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
#### 3. run xpclr
```
sbatch -n 12 --mem 96G -t 12:00:00 -p Lewis,BioCompute --wrap="sh xpclr_napa.sh ../chr.name"

```
and the _xpclr_napa.sh_:
```
while read line
do
	xpclr -Sa ../napa.txt -Sb ../wild.txt -C $line -I ../bra_only_phased_gendist2.vcf -O ~/napa_wild_"$line".txt --phased --gdistkey QUAL
	mv ~/napa_wild_"$line".txt /home/hongan/htc/hongan_htc/bra_resequence/ten_cover/3_selective/xpclr/ 
done<$1

mkdir napa
mv napa*txt napa/
```
Then, do the other groups in the same way.   
Tips: Use the modified _util.py_ in this scripts folder to replace the original _util.py_ in the xpclr package xpclr folder
#### 4. cat all chr together and finalize the selected region
```
sh after_xpclr_merge.sh folder.name

#Caculate the number of top 5% of the select-detect regions: num="wc -l napa_wild_all.txt", and then num*0.05; decide "head -n 742"
```
And the _after_xpclr_merge.sh_:
```
while read line
do
	cd $line
	grep '^A' "$line"_wild_A* > "$line"_wild_all.txt
	sed -i 's/[a-z].*_wild_A[0-1][0-9]\.txt://g' "$line"_wild_all.txt
	sort -k12,12nr "$line"_wild_all.txt | head -n 742 | awk '{if($12>0) print}' - | sort -k2,2 -k3,3n > "$line"_wild_all_score_select.txt
	#sort -k13,13nr "$line"_wild_all.txt | sed '/\t0\t0\t/d' - | head -n 742 - | sort -k2,2 -k3,3n > "$line"_wild_all_norm_select.txt
	perl ../merge_xpclr_region.pl "$line"_wild_all_score_select.txt "$line"_wild_all_score_select_merged.txt
	cd ..
done<$1
```


## Two new software: [RAiSD](https://github.com/alachins/raisd) and [LASSI-Plus](https://github.com/szpiech/lassip)
1. install RAiSD
```
wget https://github.com/alachins/raisd/archive/master.zip
unzip master.zip

cd raisd-master

module load gcc
module load gsl

sh install-RAiSD.sh
```
2. download LASSI-Plus
```
git clone https://github.com/szpiech/lassip
##then it is ready to use
```

```
module load gcc
lassip 

module load gsl
RAiSD
```
