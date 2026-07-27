# BetaVulgarisDeleteriousMutations
This repository holds scripts used for a manuscript concerning deleterious mutations across the beet genome. Resulting tables needed for manuscript figure generation are also here.

Genotyping & Genomic Conservation Pipelines

A high‑confidence genotyping workflow (WGS → SNP calling → joint genotyping → filtering -> Imputation).
A genomic conservation & deleterious‑mutation annotation workflow (gene alignment → conservation scoring → pathogenicity prediction).

## 1. Genotyping Pipeline
Overview
This workflow processes whole‑genome sequencing (WGS) reads, performs variant calling with DeepVariant, joint genotyping using GLnexus, filtering of high‑quality SNPs,Imputation using BEAGLE, and PCA‑based clustering using TASSEL.
Workflow Steps & Scripts
1. iseq to download SRA fastq and then Read Processing
iseq.sh
Process_Reads.sh

Quality trimming, adaptor removal, and alignment to the reference genome.
2. Variant Calling
deepvariant.sh

Single‑sample SNP and indel calling using DeepVariant.
3. Joint Genotyping
glnexus.sh

Merges DeepVariant gVCFs into a unified, cohort‑level VCF using GLnexus.
4. VCF Filtering
vcf_filter.sh

Applies standard SNP QC filters (depth, quality, genotype quality, missingness, etc.).
5. Imputation

BEAGLE.sh

performs BEAGLE imputation and phasing.
6. PCA / Population Clustering
PCA_Tassel.sh

Runs TASSEL PCA to explore population structure from filtered SNPs.

## 2. Genomic Conservation & Deleterious Mutation Pipeline
Overview
This workflow annotates evolutionary conservation and predicted deleteriousness across coding sequences, integrating phylogenetic conservation (PhyloP/PhastCons), substitution‑rate models, and machine‑learning deleteriousness scoring (PlantCAD2 and EST‑based metrics).
Workflow Steps & Scripts
1. Multiple Sequence Alignment (MSA) Generation
Uses the previously published bucklerlab/p_reelgene (https://bitbucket.org/bucklerlab/p_reelgene/) workflow to produce codon‑aware MSAs for each gene.
2. Conservation Scoring
phastcons.sh
EST.sh
EST_prep.R

Runs PhastCons and EST evolutionary conservation metrics on aligned gene sequences.
3. Deleteriousness Annotation
PlantCAD2.sh

Applies the PlantCAD2 classifier for deleterious mutations.

5. Combined Annotation Table
Merges:

PhastCons
PhyloP
EST
PlantCAD2
deepvariant SNPs
to produce a genome‑wide deleterious‑mutation annotation table.



## Citation & Dependencies
Key External Software

DeepVariant
GLnexus
BEAGLE
TASSEL
PhastCons / phyloFit / phyloP (PHAST)
PlantCAD2
EST pipeline (Buckler Lab)

Reference
If using gene alignments:

Multiple sequence alignments generated using the bucklerlab p_reelgene pipeline (https://bitbucket.org/bucklerlab/p_reelgene/).
