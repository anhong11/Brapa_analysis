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

## Use cross population methods [selscan](https://github.com/szpiech/selscan)(XP-nSL) and [xpclr](https://github.com/hardingnj/xpclr) detect selective sweep 

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
sbatch -n 14 --mem 96G -t 2-00:00 -p Lewis,BioCompute --wrap="sh xpnsl_napa.sh ../chr.name"

norm --xpnsl --files napa_wild_A01.xpnsl.out napa_wild_A02.xpnsl.out napa_wild_A03.xpnsl.out napa_wild_A04.xpnsl.out napa_wild_A05.xpnsl.out napa_wild_A06.xpnsl.out napa_wild_A07.xpnsl.out napa_wild_A08.xpnsl.out napa_wild_A09.xpnsl.out napa_wild_A10.xpnsl.out

norm --xpnsl --files napa_wild_A01.xpnsl.out napa_wild_A02.xpnsl.out napa_wild_A03.xpnsl.out napa_wild_A04.xpnsl.out napa_wild_A05.xpnsl.out napa_wild_A06.xpnsl.out napa_wild_A07.xpnsl.out napa_wild_A08.xpnsl.out napa_wild_A09.xpnsl.out napa_wild_A10.xpnsl.out --bp-win

## And the xpnsl_napa.sh:
while read line
do
	selscan --xpnsl --vcf ../vcf_group/napa_"$line".vcf --vcf-ref ../vcf_group/wild_"$line".vcf --out napa_wild_$line --threads 14
done<$1

```

### Run xpclr (need to run for each chr)
#### 1. add gen_dist to INFO of vcf file
```
grep "^#" bra_only_phased.vcf > bra_only_phased.head
grep "^A" bra_only_phased.vcf > bra_only_phased.body

awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' bra_only_phased.body > fake_vcf.txt
awk '{print $3}' beagle_phase/bra_only_beagle.map > gen_dist.txt
sed -i 's/^/gen_dist=/g' gen_dist.txt

paste fake_vcf.txt gen_dist.txt > fake_vcf_gendist.txt
sed -i 's/$/\tGT\t0|0/g' fake_vcf_gendist.txt

# modify bra_only_phased.head, only keep one sample in #CHR line, and save as fake_gendist.head
cat fake_gendist.head fake_vcf_gendist.txt > fake_gendist.vcf

#Transfere INFO from fake vcf to bra_only_phased.vcf

bcftools view fake_gendist.vcf -o fake_gendist.bcf
bcftools view bra_only_phased.vcf -o bra_only_phased_gendist.bcf

bcftools annotate -a fake_gendist.bcf -c INFO bra_only_phased_gendist.bcf
```
```
sbatch -n 12 --mem 96G -t 2-00:00 -p Lewis,BioCompute --wrap="sh xpclr_napa.sh ../chr.name"

```
and the xpclr_napa.sh:
```
while read line
do
	xpclr -Sa ../napa.txt -Sb ../wild.txt -C $line -I ../bra_only_phased.vcf -O napa_wild_"$line".txt
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
