#!/bin/bash
#SBATCH --job-name="Iseq"   #name of this job
#SBATCH -p medium           #name of the partition (queue) you are submitting to
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 8                 #number of cores/tasks in this job, you get all 20 physical cores with 2 threads per core with hyper-threading
#SBATCH -t 3-00:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mem 55g
#SBATCH -o "log.vcf.%j.%N"     # standard output, %j adds job number to output file name and %N adds the node name
#SBATCH -e "log.vcf.%j.%N"     #optional, prints our standard error
SRR=$1 # The accession number of the reads to generate reports of

# A variable can hold the path to the reference genome fasta file

eval "$(conda shell.bash hook)"
conda activate iseq
#echo $SRR
iseq -i PRJNA815240

#module load apptainer 
