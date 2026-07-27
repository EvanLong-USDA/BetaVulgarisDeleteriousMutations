# BetaVulgarisDeleteriousMutations

This repository holds scripts used for a manuscript concerning deleterious mutations across the beet genome. Resulting tables needed for manuscript figure generation are also here.

## Genotyping & Genomic Conservation Pipelines

This repository contains two related workflows:

### Genotyping Pipeline
High‑confidence SNP calling, imputation, and population structure analysis.

### Genomic Conservation & Deleterious Mutation Pipeline
Codon‑aware alignments, conservation scoring, and deleterious mutation annotation.

Both pipelines are designed for population genomics, germplasm characterization, and conservation genetics.

## Genotyping Pipeline

### Overview
This workflow processes WGS data from raw FASTQ through variant calling, joint genotyping, imputation, and PCA clustering. It uses DeepVariant, GLnexus, BEAGLE, and TASSEL.

### Pipeline Steps & Scripts

- **Download SRA Reads & Read Processing**

  Scripts:
  - `iseq.sh`
  - `Process_Reads.sh`

  Includes:
  - SRA FASTQ download
  - Quality trimming
  - Adapter removal
  - Alignment to reference genome

- **Variant Calling**

  Script:
  - `deepvariant.sh`

  Generates high‑accuracy single‑sample SNP and indel calls using DeepVariant.

- **Joint Genotyping**

  Script:
  - `glnexus.sh`

  Merges DeepVariant gVCFs into a cohort‑level VCF using GLnexus.

- **Variant Filtering**

  Script:
  - `vcf_filter.sh`

  Applies standard SNP quality filters, including:
  - Depth thresholds
  - QUAL score filtering
  - Genotype quality (GQ)
  - Missingness filtering

- **Imputation & Phasing**

  Script:
  - `BEAGLE.sh`

  Performs genotype imputation and phasing using BEAGLE.

- **PCA / Population Clustering**

  Script:
  - `PCA_Tassel.sh`

  Runs PCA in TASSEL to explore population structure from filtered SNPs.

## Genomic Conservation & Deleterious Mutation Pipeline

### Overview
This workflow annotates evolutionary conservation and deleteriousness across coding sequences. It integrates:
- Codon‑aware sequence alignments
- Phylogenetic conservation (PhyloP, PhastCons)
- Substitution‑rate models (EST)
- Machine‑learning deleteriousness scoring (PlantCAD2)

### Pipeline Steps & Scripts

- **Multiple Sequence Alignment (MSA)**

  Codon‑aware gene MSAs generated using the published pipeline:
  - `p_reelgene`
  - [p_reelgene on Bitbucket](https://bitbucket.org/bucklerlab/p_reelgene/)

- **Conservation Scoring**

  Scripts:
  - `phastcons.sh`
  - `EST.sh`
  - `EST_prep.R`

  Computes conservation metrics:
  - PhastCons
  - EST (Evolutionary Substitution-based Thresholding)

- **Deleteriousness Annotation**

  Script:
  - `PlantCAD2.sh`

  Predicts deleterious amino‑acid substitutions using PlantCAD2.

- **Variant Integration**

  Uses variant calls from `deepvariant.sh` and merges:
  - PhastCons
  - PhyloP
  - EST
  - PlantCAD2
  - DeepVariant SNPs

  Produces a genome‑wide deleterious mutation annotation table.

## Citation & Dependencies

### Key External Software
- DeepVariant
- GLnexus
- BEAGLE
- TASSEL
- PhastCons / phyloFit / phyloP (PHAST)
- PlantCAD2
- EST pipeline (Buckler Lab)

### Reference
If using gene alignments:
- Multiple sequence alignments generated using the bucklerlab p_reelgene pipeline ([p_reelgene on Bitbucket](https://bitbucket.org/bucklerlab/p_reelgene/)).
