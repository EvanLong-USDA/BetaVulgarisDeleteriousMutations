#!/bin/bash
#SBATCH --time=2:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=2   # 48 processor core(s) per node X 2 threads per core
#SBATCH --mem=4G   # maximum memory per node
#SBATCH --partition=ceres    # standard node(s)
#SBATCH --job-name="phastcons"
#SBATCH -o "log.PAML.%j.%N"     # standard output, %j adds job number to output file name and %N adds the node name
#SBATCH -e "log.PAML.%j.%N"     #optional, prints our standard error
#SBATCH --account sugar_beet_genetic_improvement


module load miniconda
source activate
conda activate MSA_Gen

cd MSA_Output_mafft_ungapped/$1
cp /90daydata/sugar_beet_genetic_improvement/Evan.Long/Caryophyllales/est-sfs-release-2.04/config* .
cp /90daydata/sugar_beet_genetic_improvement/Evan.Long/Caryophyllales/est-sfs-release-2.04/seedfile.txt .
Rscript /90daydata/sugar_beet_genetic_improvement/Evan.Long/Caryophyllales/EST_prep.R ${1}.evocon.txt  ${1}.gff
paste ${1}.evocon.txt AncestralAllele.txt > ${1}.evocon.AncAllele.txt


