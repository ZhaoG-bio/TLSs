library(Seurat)
library(harmony)
library(patchwork)
library(dplyr)
library(ggplot2)


load('ccrcc_scRNA-seq.Rdata')  
scc<-test.seu

scc <- subset(scc,subset = nFeature_RNA > 250 & nFeature_RNA < 6000 & percent.mt < 15 & nCount_RNA > 500 & nCount_RNA < 25000)
scc <- NormalizeData(scc, normalization.method = "LogNormalize", scale.factor = 10000)

s.genes=Seurat::cc.genes.updated.2019$s.genes
g2m.genes=Seurat::cc.genes.updated.2019$g2m.genes
scc <- CellCycleScoring(scc, s.features = s.genes, g2m.features = g2m.genes, set.ident = F)
scc$CC.Difference <- scc$S.Score - scc$G2M.Score

scc <- FindVariableFeatures(scc, selection.method = "vst", nfeatures = 2000)
scc <- ScaleData(scc, vars.to.regress = "CC.Difference", features = rownames(scc))

# SCT
# scc <- SCTransform(scc, return.only.var.genes = F, 
                     vars.to.regress = c( vars.to.regress = c("CC.Difference")))
scc <- RunPCA(scc, npcs = 50, verbose = FALSE)
scc <- RunHarmony(scc, group.by.vars = "patient", assay.use="SCT")
