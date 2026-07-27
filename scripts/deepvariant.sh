#!/bin/bash
#SBATCH --job-name="DeepVariantCPU"   #name of this job
#SBATCH -p medium           #name of the partition (queue) you are submitting to
#SBATCH -N 1                  #number of nodes in this job
#SBATCH -n 8                 #number of cores/tasks in this job, you get all 20 physical cores with 2 threads per core with hyper-threading
#SBATCH -t 3-00:00:00           #time allocated for this job hours:mins:seconds
#SBATCH --mem 55g
#SBATCH -o "log.vcf.%j.%N"     # standard output, %j adds job number to output file name and %N adds the node name
#SBATCH -e "log.vcf.%j.%N"     #optional, prints our standard error
SRR=$1 # The accession number of the reads to generate reports of

# A variable can hold the path to the reference genome fasta file
REF=/project/sugar_beet_genetic_improvement/Evan.Long/References/EL10.2_2/assembly/Bvulgarisssp_vulgaris_782_EL10.2.fa

#eval "$(conda shell.bash hook)"
#conda activate deepvariant
#echo $SRR

#module load apptainer 

mkdir $SRR
mkdir $SRR/tmp
mv ${SRR}_sorted.fix.markdup.bam* $SRR

module load apptainer

# Command-line arguments

singularity exec deepvariant_latest.sif run_deepvariant \
   --model_type=WGS \
  --vcf_stats_report=true \
  --ref=$REF \
  --reads=$SRR/${SRR}_sorted.fix.markdup.bam \
  --intermediate_results_dir=$SRR/tmp \
  --output_vcf=$SRR/$SRR.vcf.gz \
  --output_gvcf=$SRR/$SRR.gvcf.gz \
  --num_shards=8


