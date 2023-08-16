source('CIBERSORT.R')
library(dplyr) 
load("TCGA-KIRC.Rdata")
paad<-filter(mixdata,Cancer == 'KIRC')
rownames(paad)<-paad$ID
mydata<-paad[,-(1:9)]

mydata<-as.data.frame(t(mydata))


mydata$GENE<-rownames(mydata)
mydata <- mydata %>% select(GENE, everything())
write.table(mydata,file="./kirc-ffpe51-tcga-allgenes1.txt",row.names=F,sep="\t",quote=F) 

result1 <- CIBERSORT("./expr-ffpe51-nmf.txt",'./kirc-tcga-allgenes.txt', perm = 1000, QN = T)