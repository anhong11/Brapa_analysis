# Brassica rapa analysis

## Run [raxml-ng_v1.0.3](https://github.com/amkozlov/raxml-ng) 

```bash
### install
mkdir raxml-ng && cd raxml-ng
wget https://github.com/amkozlov/raxml-ng/releases/download/1.0.3/raxml-ng_v1.0.3_linux_x86_64_MPI.zip
module load cmake
module load gcc
sh ./install.sh

### check input file
sbatch -n 14 --mem 96G -t 2-00:00 -p Lewis,BioCompute --wrap="raxml-ng --parse --msa brapa_outgrpSRA_gatk.vcfutils.DP10MQ30.no4298.g0.1m0.05.SNP.3.fa --model GTR+G --prefix T2"

### 
