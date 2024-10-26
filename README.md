# BiocHybrid

Bioconductor data structures frequently combine R-based data
components for interactivity and self-descriptiveness, and
external data components that enhance performance.  This
package provides an overview of the strategy.

## Objectives

- Improve awareness of the strategy of coupling external resources to R
via functions and packages

- Provide a framework for evaluating format choices and accelerating
adoption of superior formats and methods

- Promote thinking on updating APIs for key resource access and use

## Basic plan

|Bioinformatic concept|"Tags"|External format|Size on disk|Typical query|
|---------------------|:---|:---------------:|:------------:|-------------|
|Reference Genome|hg38,T2T|[2bit](https://genome.ucsc.edu/goldenpath/help/twoBit.html)|~1GB(Hs)|genomic content in region|
|Genetic variant catalogs|SNPlocs,dbSNP|sharded RDS|6+GB(dbSNP 155)|"snpsBy..."|
|Variant pathogenicity|AlphaMissenseR, CADD|parquet, ...|
|Gene models|TxDb,EnsDb|
|Functional annotation|Encode, GO, Reactome|
|PPI|
|Cell "atlas"|
|Spatial transcriptomics|

