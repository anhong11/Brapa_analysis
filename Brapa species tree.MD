# Brassica rapa species tree with IQtree
with a SLURM system

## Run [SNPhylo](https://github.com/thlee/SNPhylo) to filter SNPs mainly based on LD
```bash

##make sure the CHR column only contains number: change A01...A10 to 01...10

sed -i 's/^A//g' brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.rename.vcf

module load r/3.6.3

##python /home/hongan/data/biosoft/snphylo/SNPhylo-master/scripts/remove_low_depth_genotype_data.py brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.no4298.g0.1m0.05.SNP.vcf 5 5 > brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.no4298.g0.1m0.05.SNP.flt.vcf
R --slave --vanilla --file=/home/hongan/data/biosoft/snphylo/SNPhylo-master/scripts/generate_snp_sequence.R --args -v brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.rename.vcf -l 0.5 -m 0.05 -M 0.1 -o brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snphylo -a 10 -t 14

```
