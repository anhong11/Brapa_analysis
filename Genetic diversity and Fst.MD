# Genetic diversity and Fst

## Genetic diversity
```
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out brown --keep brown.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out ca_tn --keep ca_tn.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out ch_oil --keep ch_oil.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out euro_tn --keep euro_tn.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out feral --keep feral.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out grelos --keep grelos.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out jp_veg --keep jp_veg.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out me_tn --keep me_tn.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out napa --keep napa.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out pakchoi --keep pakchoi.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out rapini --keep rapini.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out wild --keep wild.txt"
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out yellow --keep yellow.txt"
```

## Fst with Wild group
```

```
