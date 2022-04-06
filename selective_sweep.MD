# B. rapa selective sweep analysis

## Phase SNPs with [Beagle](https://faculty.washington.edu/browning/beagle/beagle.html#download)
### Search and download the published genetic map, reformat it and manually check the genetic map is in an increasing order:
```
A01bin001	0	400000	0.00	1.37
A01bin002	400000	700000	1.37	2.02
A01bin003	700000	900000	2.02	2.70
...
A01bin088	29200000	29500000	106.84
```


with cross population methods   

## Use [selscan](https://github.com/szpiech/selscan): XP-nSL or XP-EHH   
### Extract vcf file for each group
```
sbatch -n 1 --mem 8G -t 2:00:00 --wrap="sh extract_vcf.sh group.file"
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

### Run selscan
```

```

## Use [xpclr](https://github.com/hardingnj/xpclr)    













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
