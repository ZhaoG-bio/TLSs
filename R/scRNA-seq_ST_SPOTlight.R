library(scran)
library(SPOTlight)
library(ggplot2)
library(Seurat)
library(patchwork)
library(dplyr)
library(cowplot)

# loading scrna-seq and ST data
load('ffpe_21-ccrcc.Rdata')  
load('scrna-seq-ccrcc-1.Rdata')
load('subgroup-marker.Rdata')

# Assay
ffpe_21[['RNA']]<-ffpe_21[['Spatial']]

res <- SPOTlight(
    x = scc,
    y = kirc2,
    groups = as.character(scc$celltype),
    mgs = mgs_df,
    hvg = 3000,
    weight_id = "avg_log2FC",
    group_id = "cluster",
    gene_id = "gene",
assay = "SCT")    

mod <- res$NMF  

plotTopicProfiles(
    x = mod,
    y = sc$celltype,
    facet = FALSE,
    min_prop = 0.01,
    ncol = 1) +
    theme(aspect.ratio = 1)


plotTopicProfiles(
    x = mod,
    y = sce$celltype,
    facet = TRUE,
    min_prop = 0.01,
    ncol = 6)

library(NMF)
sign <- basis(mod)
colnames(sign) <- paste0("Topic", seq_len(ncol(sign)))
head(sign)

library(ggcorrplot)
head(mat <- res$mat)[, seq_len(3)] 

plotCorrelationMatrix(mat)  