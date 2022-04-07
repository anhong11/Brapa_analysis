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
### 4. Split phased vcf in each chr
```
head -n 9 bra_only_phased.vcf > bra_only_phased.head

sbatch -n 1 --mem 16G --wrap="sh extract_chr_vcf.sh chr.name"   ## chr.name: A01...A10, each chr in one line
```

## Use cross population methods [selscan](https://github.com/szpiech/selscan)(XP-nSL or XP-EHH) and [xpclr](https://github.com/hardingnj/xpclr) detect selective sweep 
### Extract vcf file for each group
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

### Run selscan (need to run for each chr)
```
sbatch -n 14 --mem 96G -t 2-00:00 -p Lewis,BioCompute --wrap="sh xpnsl_napa.sh ../chr.name"

## And the xpnsl_napa.sh:
while read line
do
	selscan --xpnsl --vcf ../vcf_group/napa_"$line".vcf --vcf-ref ../vcf_group/wild_"$line".vcf --out napa_wild_$line --threads 14
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
