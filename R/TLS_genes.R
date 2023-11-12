# ccrcc bulk RNA-seq

load('tcga-ccrcc.Rdata')
med.exp<-median(cancer_name[,'ARHGAP9'])
#print(head(med.exp))
more.med.exp.index<-which(cancer_name[,'ARHGAP9']>=med.exp)
less.med.exp.index<-which(cancer_name[,'ARHGAP9']<med.exp)
#print(head(more.med.exp.index))
cancer_name$Group<-cancer_name[,'ARHGAP9']
cancer_name$Group[more.med.exp.index]<-paste0('ARHGAP9 ','high expression')  
cancer_name$Group[less.med.exp.index]<-paste0('ARHGAP9 ','low expression')
my_comparisons <- list( c(paste0('ARHGAP9 ','high expression'),paste0('ARHGAP9 ','low expression')) )
#my_comparisons <- list( c(paste0('ARHGAP9 ','low expression'),paste0('ARHGAP9 ','high expression') ))

library(ggpubr) 
library(ggplot2) 
library(dplyr)
sec_gene<-c('CCR6','CD1D','CD79B','PTGDS','RBP5','SKAP1')


# Violin diagram

for (gene in sec_gene){
    P2<- ggplot(cancer_name, aes(x=Group, y=cancer_name[,gene],fill=Group)) + 
        geom_violin(trim=FALSE,color="white",alpha=0.5) + 
        geom_boxplot(width=0.2,position=position_dodge(0.9))+ 
        stat_compare_means(comparisons = my_comparisons,method = "t.test", label = "p.signif",size=7)+ 
        scale_fill_manual(values = c("#5bc276", "#4870be"))+ 
        theme_bw()+       theme(axis.text.x=element_text(angle=0,colour="black",size=18), 
                                axis.text.y=element_text(size=22), 
                                axis.title.x=element_text(size = 23),
                                axis.title.y=element_text(size = 22), 
                                panel.border = element_blank(),axis.line = element_line(colour = "black",size=1), 
                                legend.text=element_text(colour="black",  
                                                          size=22),
                                legend.title=element_text(colour="black", 
                                                          size=25),
                                panel.grid.major = element_blank(),   
                                panel.grid.minor = element_blank())+  
        ylab(paste0(gene,' expression'))+xlab("")+theme(legend.position = "none")

    ggsave(paste0("/kirc-ARHGAP9-TLS-",gene,'.pdf',sep = ""),p2,width = 4.5,height = 5)
    }