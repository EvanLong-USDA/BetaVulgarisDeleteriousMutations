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
conda activate phast

cd MSA_Output_mafft_ungapped/$1

phyloFit --tree RAxML_bestTree.${1}.EL10.2_2_msa.fa --subst-mod REV --out-root modelfile ${1}.EL10.2_2_msa.fa
phyloP --mode CONACC --method LRT --wig-scores modelfile.mod ${1}.EL10.2_2_msa.fa | grep -v fixedStep > phyloPscores.wig
paste ${1}.AncAllele phyloPscores.wig > ${1}.evocon.txt
