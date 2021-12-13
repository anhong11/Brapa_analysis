# Brassica rapa analysis
with a SLURM system

## Run [SNPhylo](https://github.com/thlee/SNPhylo) to filter SNPs mainly based on LD
```bash

##make sure the CHR column only contains number: change A01...A10 to 1...10
module load r/3.6.3

##python /home/hongan/data/biosoft/snphylo/SNPhylo-master/scripts/remove_low_depth_genotype_data.py brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.no4298.g0.1m0.05.SNP.vcf 5 5 > brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.no4298.g0.1m0.05.SNP.flt.vcf
R --slave --vanilla --file=/home/hongan/data/biosoft/snphylo/SNPhylo-master/scripts/generate_snp_sequence.R --args -v brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.fasta -l 0.1 -m 0.05 -M 0.1 -o brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo -a 10 -t 14

```
Afterthat:
## Run [raxml](https://cme.h-its.org/exelixis/web/software/raxml/) if the dataset is not very big

```bash
##Run wit ASC_GTRGAMMA model for SNP data
sbatch -n 24 --mem 196G -t 1-23:00 -p Lewis,BioCompute --wrap="raxml -f a -x 12345 -p 12345 -# 100 -m ASC_GTRGAMMA --asc-corr=lewis -s brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.fasta -n brapa_outgrp_asc -T 24"

#If invarious sites found in the fasta file, then:
grep '^Site' slurm-xxxxxxx.out > invar_site.txt
sed -i 's/Site //g' invar_site.txt
sed -i 's/ //g' invar_site.txt

perl rmInvar4raxml.pl invar_site.txt brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.fasta brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.var.fasta

sbatch -n 24 --mem 196G -t 1-23:00 -p Lewis,BioCompute --wrap="raxml -f a -x 12345 -p 12345 -# 100 -m ASC_GTRGAMMA --asc-corr=lewis -s brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.var.fasta -n brapa_outgrp_asc -T 24"
```
## Run [IQ-TREE2](http://www.iqtree.org/) is another opinion
```bash
sbatch -n 14 --mem 196G -t 2-00:00 -p Lewis,BioCompute --wrap="iqtree2 -s brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.fasta -m GTR+G+ASC -nt AUTO -ntmax 14 -B 1000 -st DNA"

##if have invariant sites, iqtree will report the error and creat a phylip file that only has variant site. Rerun iqtree with this new phylip file
sbatch -n 14 --mem 196G -t 2-00:00 -p Lewis,BioCompute --wrap="iqtree2 -s brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.fasta.varsites.phy -m GTR+G+ASC -nt AUTO -ntmax 14 -B 1000 -st DNA"
```

## Run [raxml-ng_v1.0.3](https://github.com/amkozlov/raxml-ng) if the dataset is very big

```bash
### install
mkdir raxml-ng && cd raxml-ng
wget https://github.com/amkozlov/raxml-ng/releases/download/1.0.3/raxml-ng_v1.0.3_linux_x86_64_MPI.zip
module load cmake
module load gcc
sh ./install.sh

### check input file (do not run this if want to specify your own model)
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="raxml-ng --parse --msa brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.no4298.g0.1m0.05.SNP.3.fa --model GTR+G --prefix T2"

### if have invariant sites in the alignment, follow the above raxml steps or iqtree step to remove the invariant sites, and write down the number of invariant sites (here we have 1302)

### run a non-bootstrap tree
sbatch -n 18 --mem 240G -t 2-00:00 -p Lewis,BioCompute --wrap="raxml-ng --msa brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.var.fasta --model GTR+G+ASC_FELS{1302} --prefix ASC_T2 --threads 18 --seed 2 --tree pars{50},rand{50}"

### run a bootstrap tree
  ### with default parameters
sbatch -n 24 --mem 360G -t 2-00:00 -p Lewis,BioCompute --wrap="raxml-ng --bootstrap --msa brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.var.fasta --model GTR+G+ASC_FELS{1302} --prefix ASC_T3 --threads 24 --seed 2"
  ### check bsconverge
sbatch -n 14 --mem 140G -t 2-00:00 -p Lewis,BioCompute --wrap="raxml-ng --bsconverge --bs-trees ASC_T3.raxml.bootstraps --prefix ASC_T3check --seed 2 --threads 14 --bs-cutoff 0.03"
  ### if bsconverge is NO, run bootstrap with more bootstraps
sbatch -n 24 --mem 360G -t 7-00:00 --qos biolong -p Lewis,BioCompute --wrap="raxml-ng --bootstrap --msa brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo.var.fasta --model GTR+G+ASC_FELS{1302} --prefix ASC_T4 --threads 24 --seed 333 --bs-trees 800" 
 ### check bsconverge again
  sbatch -n 14 --mem 140G -t 2-00:00 -p Lewis,BioCompute --wrap="raxml-ng --bsconverge --bs-trees T4.raxml.bootstraps --prefix ASC_T4check --seed 2 --threads 14 --bs-cutoff 0.03"

### compute bootstrap support
raxml-ng --support --tree T?.raxml.bestTree --bs-trees allbootstraps --prefix T?+1 --threads 14 --bs-metric tbe
```

## Other
### Covert vcf to phylip and fasta with [vcf2phylip](https://github.com/edgardomortiz/vcf2phylip)
```bash
sbatch -n 14 --mem 96G -t 12:00:00 -p Lewis,BioCompute --wrap="python3 vcf2phylip.py -i brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf -f"
```
