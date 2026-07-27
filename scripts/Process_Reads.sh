#!/bin/bash
#SBATCH --job-name="SRR_Process"   #name of this job
#SBATCH -p medium           #name of the partition (queue) you are submitting to
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 2                 #number of cores/tasks in this job, you get all 20 physical cores with 2 threads per core with hyper-threading
#SBATCH -t 6-09:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mem 15g
#SBATCH -o "log.vcf.%j.%N"     # standard output, %j adds job number to output file name and %N adds the node name
#SBATCH -e "log.vcf.%j.%N"     #optional, prints our standard error
SRR=$1 # The accession number of the reads to generate reports of

# A variable can hold the path to the reference genome fasta file
REF=/project/sugar_beet_genetic_improvement/Evan.Long/References/EL10.2_2/assembly/Bvulgarisssp_vulgaris_782_EL10.2.fa

eval "$(conda shell.bash hook)"
conda activate deepvariant
echo $SRR

trimmomatic PE -threads 2 -phred33 \
  ${SRR}_1.fastq ${SRR}_2.fastq \
  ${SRR}_1.trimmed.fastq.gz ${SRR}_1un.trimmed.fastq.gz \
  ${SRR}_2.trimmed.fastq.gz ${SRR}_2un.trimmed.fastq.gz \
  SLIDINGWINDOW:4:20


conda activate mapreads
#Call bwa-mem, and pipe output to samtools. Make output to the bam directory
bwa mem -M -t 2 -R "@RG\tID:$SRR\tSM:$SRR\tPL:ILLUMINA" $REF ${SRR}_1.trimmed.fastq.gz ${SRR}_2.trimmed.fastq.gz | samtools sort -n -@2 -o $SRR.bam

conda activate MSA_Gen

# Fix reads
samtools fixmate -m ${SRR}.bam - | samtools sort -@2 -o ${SRR}_sorted_fix.bam
# Mark duplicates
samtools markdup -@2 -s ${SRR}_sorted_fix.bam - | samtools sort -@2 -o ${SRR}_sorted.fix.markdup.bam
# Generate index file
samtools index ${SRR}_sorted.fix.markdup.bam


