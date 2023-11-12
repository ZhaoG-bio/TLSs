library(Seurat)
library(patchwork)
library(clusterProfiler)
library(org.Hs.eg.db) 
library(tidyverse)
library(dplyr)
library(ggplot2)

load('ffpe_ccrcc.Rdata')

table(ff51$Type)
Idents(ff51)<-ff51$Type
ne6<-subset(ff51,idents = c('TLS'))
head(ne6@meta.data)


expr<-as.matrix(GetAssayData(object = ne6[["RNA"]], slot = "data")) 
expr1<-data.frame(sample = colnames(expr), ARHGAP9 = expr['ARHGAP9',])


cutoff <- median(expr1$ARHGAP9)
expr1$Group <- cut(expr1$ARHGAP9,breaks = c(-Inf, cutoff, Inf),labels = c('low_ARHGAP9','high_ARHGAP9'))
identical(expr1$sample,rownames(ne6@meta.data))


ne6@meta.data$Group<-expr1$Group
head(ne6@meta.data)
table(ne6$Group)


Idents(ne6)<-ne6$Group


pbmc.markers <- FindAllMarkers(ne6, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)
te_top<-pbmc.markers %>%
    group_by(cluster) %>%
    top_n(n = 100, wt = avg_log2FC)
print(tbl_df(te_top), n=320)  

pre_set2<-as_tibble(te_top)

te_top2<-pre_set2 %>%
    group_by(cluster) %>%
    top_n(n = 80, wt = avg_log2FC)

set<-as.data.frame(te_top2)
sce.markers<-set


ids=bitr(sce.markers$gene,'SYMBOL','ENTREZID','org.Hs.eg.db') 
sce.markers=merge(sce.markers,ids,by.x='gene',by.y='SYMBOL')

gcSample=split(sce.markers$ENTREZID, sce.markers$cluster)



options(clusterProfiler.download.method = "wget")


#KEGG
xx <- compareCluster(gcSample,
  fun = "enrichKEGG",
  organism = "hsa", pvalueCutoff = 0.5
)
p <- dotplot(xx)
p1<-p + theme(axis.text.x = element_text(
  angle = 75,
  vjust = 0.8, hjust = 0.8,size=13
),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
panel.background = element_blank())+ scale_color_continuous(low='#497395', high='#F5A852')+labs(x="")
p1

p2+theme(plot.title=element_text(
                                size=25),legend.title = element_text(size=20), 
          legend.text = element_text(size=18))+ theme(axis.title.x=element_text(  
                                    size=18), 
          axis.title.y=element_text(size=22),
          axis.text.y=element_text(size=18),axis.text.x=element_text(size=20),panel.border = element_rect(size=1.3))+scale_x_discrete(labels = c('ARHGAP9- TLS','ARHGAP9+ TLS'))



#GO
xx <- compareCluster(gcSample,
  fun = "enrichGO",
  OrgDb = "org.Hs.eg.db",
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05,
  qvalueCutoff = 0.05
)
p <- dotplot(xx)
p2<-p + theme(axis.text.x = element_text(
  angle = 75,
  vjust = 0.8, hjust = 0.8,size=13
),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
panel.background = element_blank())+ scale_color_continuous(low='#497395', high='#F5A852')+labs(x="")
p2

p2+theme(plot.title=element_text(
                                size=25),legend.title = element_text(size=20), 
          legend.text = element_text(size=18))+ theme(axis.title.x=element_text(  
                                    size=18), 
          axis.title.y=element_text(size=22),
          axis.text.y=element_text(size=18),axis.text.x=element_text(size=20),panel.border = element_rect(size=1.3))+scale_x_discrete(labels = c('ARHGAP9- TLS','ARHGAP9+ TLS'))
