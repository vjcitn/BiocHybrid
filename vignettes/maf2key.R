#' from a MAF instance create a key with ref, alt and positional information,
#' return in a data.frame with key and gene symbol
#' @param mafinst instance of S4 class MAF from maftools
#' @param altfield character(1) name of field to use for mutation substitution
#' @param donorfield character(1) name of field to use for donor
#' @export
maf2key = function(mafinst, altfield="Tumor_Seq_Allele2", donorfield="Tumor_Sample_Barcode") {
 stopifnot(is(mafinst, "MAF"))
 ld = slot(mafinst, "data")
 stopifnot(all(c("Chromosome", "Start_Position", "Reference_Allele", altfield) %in% names(ld)))
 alt = ld[[altfield]]
 ldclean = ld |> dplyr::filter(nchar(Reference_Allele)==1L,
        nchar(local(alt))==1L)
 alt = ldclean[[altfield]]
 donorid = ldclean[[donorfield]]
 key = with(ldclean, paste(Chromosome, Start_Position, Reference_Allele, alt, sep=":"))
 gene = ldclean$Hugo_Symbol
 tmp = data.frame(key, gene, donor=donorid)
 requireNamespace("org.Hs.eg.db")
 db = org.Hs.eg.db::org.Hs.eg.db
 up = select(db, keys=tmp$gene, keytype="SYMBOL", columns="UNIPROT")
 dplyr::left_join(dplyr::mutate(up, gene=SYMBOL), tmp, by="gene", relationship="many-to-many")
}

#' with AlphaMissenseR data query, build a key for merging pathogenicity score to MAF
#' information from donors, based on gene symbol with mutation
#' @param symbol character(1) gene symbol, will be mapped to UNIPROT ids using org.Hs.eg.db
#' @param build character(1) "hg19" or "hg38"
#' @examples
#' amk = am_key_by_gene("ABCA10", "hg19")
#' dim(amk)
#' head(amk)
#' @export
am_key_by_gene = function(symbol, build) {
 stopifnot( build %in% c("hg19", "hg38"))
 dat = AlphaMissenseR::am_data(build)
 requireNamespace("org.Hs.eg.db")
 db = org.Hs.eg.db::org.Hs.eg.db
 up = select(db, keys=symbol, keytype="SYMBOL", columns="UNIPROT")
 if (nrow(up)==0) {
  message(sprintf("no uniprot for symbol %s, returning NULL", symbol))
  return(NULL)
  }
 hold = dat |> dplyr::filter(uniprot_id %in% local(up$UNIPROT)) |> as.data.frame()
 key = with(hold, paste(gsub("chr", "", CHROM), POS, REF, ALT, sep=":"))
 data.frame(key, symbol, uniprot=hold$uniprot_id, am_score=hold$am_pathogenicity)
}
 

## Source:   table<hg19> [?? x 10]
## Database: DuckDB v1.1.0 [vincentcarey@Darwin 23.6.0:R 4.4.1//Users/vincentcarey/Library/Caches/org.R-project.R/R/BiocFileCache/fc151356572a_fc151356572a]
#   CHROM   POS REF   ALT   genome uniprot_id transcript_id     protein_variant
#   <chr> <dbl> <chr> <chr> <chr>  <chr>      <chr>             <chr>          
# 1 chr1  69094 G     T     hg19   Q8NH21     ENST00000335137.3 V2L            
# 2 chr1  69094 G     C     hg19   Q8NH21     ENST00000335137.3 V2L            
# 3 chr1  69094 G     A     hg19   Q8NH21     ENST00000335137.3 V2M            
# 4 chr1  69095 T     C     hg19   Q8NH21     ENST00000335137.3 V2A            
# 5 chr1  69095 T     A     hg19   Q8NH21     ENST00000335137.3 V2E            
# 6 chr1  69095 T     G     hg19   Q8NH21     ENST00000335137.3 V2G            
# 7 chr1  69097 A     G     hg19   Q8NH21     ENST00000335137.3 T3A            
# 8 chr1  69097 A     C     hg19   Q8NH21     ENST00000335137.3 T3P            
# 9 chr1  69097 A     T     hg19   Q8NH21     ENST00000335137.3 T3S            
#10 chr1  69098 C     A     hg19   Q8NH21     ENST00000335137.3 T3N            
## ℹ more rows
## ℹ 2 more variables: am_pathogenicity <dbl>, am_class <chr>
## ℹ Use `print(n = ...)` to see more rows
#> 

