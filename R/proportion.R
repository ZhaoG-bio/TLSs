load('ccrcc-celltype.Rdata')


library(Seurat)
library(ggplot2)
library(dplyr)

table(Idents(scc))
sce<-subset(scc,idents = c('NK cell','Gamma Delta T'))
head(scc@meta.data)
table(sce$orig.ident)

sc <- sce
sc$type<-sce$orig.ident

library(stringr)
sc@meta.data$type=str_replace_all(sc$type,"_"," ")
table(sc$type)


sce<-sc
sce$sample_id<-rownames(sce@meta.data)
cell_types <- FetchData(sce, vars = c("celltype", "type")) %>% 
  mutate(main_cell_type = factor(celltype, levels = names(table(sce$celltype)))) %>% 
  mutate(type = factor(type, levels = rev(names(table(sce$type)))))  

# prop.table(table(sce$celltype,sce$type),2)  

color_m<-c("#FCBF4B","#2B9D8F","#E46E51")

p<-ggplot(data = cell_types) + 
  geom_bar(mapping = aes(x = celltype, fill = type), position = "fill", width = 0.75) +
  scale_fill_manual(values = color_m) +theme_bw()+theme(
        panel.background = element_blank(),
      legend.title = element_blank(),
        panel.grid = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 0.5, vjust = 0.5,color = 'black'), axis.ticks.x = element_line(),
      axis.text.y = element_text(color = 'black')
        )+labs(y = 'Ratio',x = "")+scale_y_continuous(expand = c(0,0))+theme(plot.title=element_text(
                                size=25),legend.title = element_text(size=0), 
          legend.text = element_text(size=16))+ theme(axis.title.x=element_text(  
                                    size=22), 
          axis.title.y=element_text(size=25), 
          axis.text.x=element_text(size=20), legend.position = 'right',
          axis.text.y=element_text(size=20),panel.border = element_rect(size=1.3))