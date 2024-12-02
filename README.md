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
<!-- |Reference Genome|hg38,T2T|[2bit](https://genome.ucsc.edu/goldenpath/help/twoBit.html)|~1GB(Hs)|genomic content in region| -->

|Bioinformatic concept|Examples|External format|Size on disk|Typical query|unique IP/month|
|---------------------|:---|:---------------:|:------------:|-------------|:---------------:|
|Reference Genome|hg38,T2T|2bit|~1GB(Hs)|genomic content in region| 4000|
|Genetic variant catalogs|SNPlocs,dbSNP|sharded RDS|6+GB(dbSNP 155)|"snpsBy..."|1000|
|Variant pathogenicity|AlphaMissenseR, CADD|duckdb storage, sharded RLE in RDS|100MB+|structural and functional consequences of DNA changes|20|
|Gene models|TxDb,EnsDb|SQLite|~100MB|transcript id and coordinates|2500|
|Species-level genomcs|OrgDb|SQLite|~300MB|gene to transcript/protein/ontology|20000|
|Ontologies for genomics|EFO, GO, Reactome,CHEBI,...|OWL/OBO|~1-100MB|gene sets, common ancestral terms|20000|
|Single cell genomics|scRNAseq/hca|RDS, HDF5|~1GB+|inference on cell type and function|1900|
|Cell "atlas"|curatedAtlas|parquet|~500MB|cells by donor characteristics|100|
|Spatial transcriptomics|outputs of multiple platforms|HDF5, parquet, Zarr|10GB|Expression patterns in spatially registered tissue images|4000|


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
