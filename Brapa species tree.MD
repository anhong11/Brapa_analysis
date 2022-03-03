# Brassica rapa species tree with [IQ-TREE2](http://www.iqtree.org/)
with a SLURM system

## Run [vcftools](https://vcftools.github.io/index.html) to only keep used samples
```bash
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf brapa_onlySRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --keep used_outgrp.txt --recode --out used_outgrp.flt.snp"
##used_outgrp.txt is organized based on phylogeny and genetic sturcture result.
```
## Covert VCF file into IQtree CF format
```

