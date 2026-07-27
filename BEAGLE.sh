#!/bin/bash
#SBATCH --job-name="beagle"   #name of this job
#SBATCH -p ceres              #name of the partition (queue) you are submitting to
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 16                 #number of cores/tasks in this job, you get all 20 physical cores with 2 threads per core with hyper-threading
#SBATCH -t 4-24:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mem 1000G
#SBATCH -o "log.vcf.%j.%N"     # standard output, %j adds job number to output file name and %N adds the node name
#SBATCH -e "log.vcf.%j.%N"     #optional, prints our standard error
#SBATCH --account sugar_beet_genetic_improvement
module load miniconda
source activate
conda activate MSA_Gen

name=`echo $1 | cut -f 1 -d "."`


vcftools --gzvcf $1 --max-missing 0.1 --stdout --recode --recode-INFO-all > ${name}.Binput.vcf
pbgzip ${name}.Binput.vcf
tabix ${name}.Binput.vcf.gz
conda activate beagle

java -Xmx1000g -jar  /project/sugar_beet_genetic_improvement/Evan.Long/.conda/envs/beagle/share/beagle-5.5_27Feb25.75f-0/beagle.jar \
    gt=${name}.Binput.vcf.gz \
    out=${name}.phased \
    nthreads=16 
tabix ${name}.phased.vcf.gz
