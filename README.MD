# Run [raxml-ng_v1.0.3](https://github.com/amkozlov/raxml-ng) 

```bash
### check input file
sbatch -n 14 --mem 96G -t 2-00:00 -p Lewis,BioCompute --wrap="raxml-ng --parse --msa brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.no4298.g0.1m0.05.SNP.3.fa --model GTR+G --prefix T2"

