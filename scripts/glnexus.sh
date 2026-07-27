#!/bin/bash
#SBATCH --job-name="GL_Nexus"   #name of this job
#SBATCH -p medium           #name of the partition (queue) you are submitting to
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 15                 #number of cores/tasks in this job, you get all 20 physical cores with 2 threads per core with hyper-threading
#SBATCH -t 60:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mem 300g
#SBATCH -o "log.vcf.%j.%N"     # standard output, %j adds job number to output file name and %N adds the node name
#SBATCH -e "log.vcf.%j.%N"     #optional, prints our standard error
# Module load
module load miniconda
source activate
conda activate  glnexus

#mkdir out_${1}

glnexus_cli \
-c DeepVariantWGS \
--dir out_${1} \
SRR*/*$1.gvcf.gz > mitchseq_${1}.bcf

# Convert bcf into gvcf
bcftools view mitchseq_${1}.bcf | bgzip -@ 15 -c > mitchseq_${1}.vcf.gz
