#!/bin/bash -l
#SBATCH --partition=gpu-a100
#PLEASE SELECT A QoS
#SBATCH --job-name=PlantCad
#SBATCH --output=JobName.%J.out
#SBATCH --account=sugar_beet_genetic_improvement
#SBATCH --time=2-12:00:00
#SBATCH --nodes=1
#SBATCH --gpus-per-node=1
#SBATCH --ntasks=4



directory=`pwd`

source ~/.bashrc
source Conda_Initiate.sh
conda activate PlantCAD
cd /project/sugar_beet_genetic_improvement/Evan.Long/PlantCad/PlantCaduceus
python src/zero_shot_score.py     -input-vcf  MegaBeet_Codingnomaf_SNPs.vcf     -input-fasta Bvulgarisssp_vulgaris_782_EL10.2.fa     -output MegaBeet_Codingnomaf_scored_snps.vcf     -model 'PlantCAD2-Large-l48-d1536'  -step-size 8   -device 'cuda:0'
python src/zero_shot_score_sv.py     -input-vcf  MegaBeet_Codingnomaf_indel.vcf     -input-fasta Bvulgarisssp_vulgaris_782_EL10.2.fa     -output MegaBeet_Codingnomaf_scored_indel.vcf     -model 'PlantCAD2-Large-l48-d1536'   -device 'cuda:0' -batchSize 16 -contextSize 8192 -flank-size 20

