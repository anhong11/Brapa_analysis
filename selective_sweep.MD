# B. rapa selective sweep analysis

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

## Use [XPCLR](https://github.com/hardingnj/xpclr)    













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
