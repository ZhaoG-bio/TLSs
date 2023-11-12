library(msigdbr)
library(ggplot2)
library(clusterProfiler)
library(org.Hs.eg.db)
library(dplyr)
library(GSVA)

# load('ffpe51-tls-nmf-anno.Rdata')
# load('ffpe51-nmf-markers.Rdata')
ges<-as.character(fs)

ne6<-st
exprs <- AverageExpression(ne6, assay = 'RNA',slot = 'data', group.by = 'SPs')[[1]]    
exprs<-exprs[ges,]
exprs[1:5,1:3]


m_df = msigdbr(species = "Homo sapiens", category = "H")  
kegg_list = split(x = m_df$gene_symbol, f = m_df$gs_name)
#identical(rownames(data1), colnames(expr)[1:length(colnames(exprs))])

#GSVA
exprs=as.matrix(exprs)  
kegg2 <- gsva(exprs,kegg_list, kcdf="Gaussian",method = "gsva",parallel.sz=1)

pheatmap::pheatmap(kegg2, show_colnames = T, 
                   scale = "row",angle_col = "45",
                   color = colorRampPalette(c("navy", "white", "firebrick3"))(50))

gs<-kegg2
gs<-as.data.frame(gs)
gs$ID<-rownames(gs)
gs$ID <- str_replace(gs$ID, "HALLMARK_", "")
rownames(gs)<-gs$ID
gs$ID<-NULL
head(gs)
rownames(gs)<-str_replace_all(rownames(gs),'_',' ')
p<-pheatmap::pheatmap(gs, show_colnames = T, cluster_col = T, 
                   scale = "row",border_color = "white",angle_col = "45",fontsize_col = 12,cluster_cols = FALSE,
                   color = colorRampPalette(c("#40034D",'#217777', "#FFFFCC", "#FFFF99",'#FF9900'))(50))
