BetaVulgarisDeleteriousMutations
This repository contains scripts and data used for a manuscript investigating deleterious mutations across the Beta vulgaris genome.
It includes:

A genotyping pipeline (FASTQ → SNPs → imputation → PCA)
A conservation & deleterious‑mutation pipeline (MSA → conservation scoring → deleteriousness prediction)
Processed tables used for generating manuscript figures


Genotyping Pipeline
Overview
A high‑confidence whole‑genome sequencing (WGS) pipeline for SNP calling, joint genotyping, imputation, and population structure analysis.
Built on DeepVariant, GLnexus, BEAGLE, and TASSEL.

Pipeline Steps & Scripts
• Download SRA Reads & Read Processing
Scripts:

iseq.sh
Process_Reads.sh

Includes:

SRA FASTQ retrieval
Quality trimming
Adapter removal
Alignment to the reference genome


• Variant Calling
Script:

deepvariant.sh

Generates highly accurate single‑sample SNP and indel calls using DeepVariant.

• Joint Genotyping
Script:

glnexus.sh

Merges DeepVariant gVCFs into a unified cohort VCF using GLnexus.

• Variant Filtering
Script:

vcf_filter.sh

Applies SNP QC filtering:

Depth filtering
QUAL score thresholds
Genotype quality (GQ)
Missingness filtering


• Imputation & Phasing
Script:

BEAGLE.sh

Performs genotype imputation and phasing using BEAGLE.

• PCA / Population Structure
Script:

PCA_Tassel.sh

Runs PCA in TASSEL to explore population structure of the filtered SNP dataset.

Genomic Conservation & Deleterious Mutation Pipeline
Overview
Workflow for computing evolutionary conservation and predicting deleterious mutations across coding sequences.
Integrates:

Codon‑aware gene alignments
Phylogenetic conservation (PhyloP, PhastCons)
Substitution‑rate models (EST)
Machine‑learning predictions (PlantCAD2)


Pipeline Steps & Scripts
• Multiple Sequence Alignment (MSA)
Codon‑aware gene MSAs generated using the published pipeline:
p_reelgene: https://bitbucket.org/bucklerlab/p_reelgene/

• Conservation Scoring
Scripts:

phastcons.sh
EST.sh
EST_prep.R

Computes conservation scores:

PhastCons
EST (Evolutionary Substitution‑based Thresholding)


• Deleteriousness Annotation
Script:

PlantCAD2.sh

Predicts deleterious amino‑acid substitutions using PlantCAD2.

• Variant Integration
Integrates variant calls from:

DeepVariant
PhastCons
PhyloP
EST
PlantCAD2

Produces a genome‑wide deleterious mutation annotation table.

Citation & Dependencies
External Software

DeepVariant
GLnexus
BEAGLE
TASSEL
PHAST (phastCons, phyloFit, phyloP)
PlantCAD2
EST (Buckler Lab)

Gene Alignment Reference
If using codon‑aware alignments:

Multiple sequence alignments were generated using the bucklerlab/p_reelgene pipeline:
https://bitbucket.org/bucklerlab/p_reelgene
