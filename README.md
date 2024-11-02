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


Interrogate a LoomExperiment from hca package obtained via code like
```
library(hca)
projectId = "53c53cd4-8127-4e12-bc7f-8fe1610a715c"
file_filter <- filters(
    projectId = list(is = projectId),
    fileFormat = list(is = "loom")
)
pfile = files(file_filter)
pfile$projectTitle[1]
#pfile |> files_download()  # can be very slow, retrieves 17 large files
```
```
Formal class 'DelayedMatrix' [package "DelayedArray"] with 1 slot
  ..@ seed:Formal class 'DelayedAperm' [package "DelayedArray"] with 2 slots
  .. .. ..@ perm: int [1:2] 2 1
  .. .. ..@ seed:Formal class 'HDF5ArraySeed' [package "HDF5Array"] with 7 slots
  .. .. .. .. ..@ filepath : chr "/home/exouser/.cache/R/hca/31474194a280f_31474194a280f.loom"
  .. .. .. .. ..@ name     : chr "/matrix"
  .. .. .. .. ..@ as_sparse: logi FALSE
  .. .. .. .. ..@ type     : chr NA
  .. .. .. .. ..@ dim      : int [1:2] 506896 58347
  .. .. .. .. ..@ chunkdim : int [1:2] 64 64
  .. .. .. .. ..@ first_val: int 0
```
