# Genetic diversity and Fst

## Genetic diversity
```
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out brown --keep brown.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out ca_tn --keep ca_tn.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out ch_oil --keep ch_oil.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out euro_tn --keep euro_tn.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out feral --keep feral.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out grelos --keep grelos.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out jp_veg --keep jp_veg.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out me_tn --keep me_tn.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out napa --keep napa.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out pakchoi --keep pakchoi.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out rapini --keep rapini.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out wild --keep wild.txt"
sbatch -n 14 --mem 96G -t 1:00:00 -p Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --window-pi 100000 --window-pi-step 25000 --out yellow --keep yellow.txt"
```

## Fst with Wild group
```
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_brown --weir-fst-pop wild.txt --weir-fst-pop brown.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_ca_tn --weir-fst-pop wild.txt --weir-fst-pop ca_tn.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_ch_oil --weir-fst-pop wild.txt --weir-fst-pop ch_oil.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_euro_tn --weir-fst-pop wild.txt --weir-fst-pop euro_tn.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_feral --weir-fst-pop wild.txt --weir-fst-pop feral.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_grelos --weir-fst-pop wild.txt --weir-fst-pop grelos.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_jp_veg --weir-fst-pop wild.txt --weir-fst-pop jp_veg.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_me_tn --weir-fst-pop wild.txt --weir-fst-pop me_tn.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_napa --weir-fst-pop wild.txt --weir-fst-pop napa.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_pakchoi --weir-fst-pop wild.txt --weir-fst-pop pakchoi.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_rapini --weir-fst-pop wild.txt --weir-fst-pop rapini.txt"
sbatch -n 14 --mem 96G -t 2:00:00 -p General,Lewis,BioCompute --wrap="vcftools --vcf ../brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --fst-window-size 100000 --fst-window-step 25000 --out wild_yellow --weir-fst-pop wild.txt --weir-fst-pop yellow.txt"
```

## PCA plot
1. extract vcf file of used samples from all-sample vcf file with [vcftools](http://vcftools.sourceforge.net/)
```
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.g0.1m0.05.snp.vcf --keep used_only.txt --recode --out used_only.flt.snp"
```
2. covert vcf to plink format, and then covert plink format to evec format for [Genesis](https://github.com/shaze/genesis)
```
sbatch -n 14 --mem 96G -t 1-00:00 -p Lewis,BioCompute --wrap="vcftools --vcf used_only.flt.snp.vcf --plink --out used_only.flt.snp.plink"

sed -i 's/0\t\(A[0-1][0-9]\)/\1\t\1/g' used_only.flt.snp.plink.map

plink --file used_only.flt.snp.plink --make-bed --out used_only.flt.snp.bed --noweb --allow-extra-chr
plink --bfile used_only.flt.snp.bed --pca --out used_only.flt.snp.bed --allow-extra-chr

python plink2evec.py --bfile used_only.flt.snp.bed --out used_only.flt.snp.pca.evec   ##plink2evec.py is in Genesis package

```
