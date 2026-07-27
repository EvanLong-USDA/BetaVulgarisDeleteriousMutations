#!/bin/bash
#SBATCH --job-name="vcf-filter"   #name of this job
#SBATCH -p ceres              #name of the partition (queue) you are submitting to
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 3                 #number of cores/tasks in this job, you get all 20 physical cores with 2 threads per core with hyper-threading
#SBATCH -t 24:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mem 30G
#SBATCH -o "log.vcf.%j.%N"     # standard output, %j adds job number to output file name and %N adds the node name
#SBATCH -e "log.vcf.%j.%N"     #optional, prints our standard error
#SBATCH --account sugar_beet_genetic_improvement
module load miniconda
source activate
conda activate MSA_Gen

name=`echo $1 | cut -f 1 -d "."`
vcftools --gzvcf $1 --minDP 5 --minGQ 20 --max-missing 0.1 --stdout --recode > filtered_nomaf/${name}.vcf
pbgzip -f filtered_nomaf/${name}.vcf
