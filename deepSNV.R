library(deepSNV)
library(GenomicRanges)
x<-read.table("IAA10300_166_Designed.bed",header=T)
df <- data.frame(chr=x$chr, start=x$start, end=x$stop)
regions<-makeGRangesFromDataFrame(df)
HIVmix <- deepSNV(test ="02_Surgery_fixmate_sorted.bam", control ="02_Blood_fixmate_sorted.bam",regions=regions,q=10)
data(HIVmix) 
show(HIVmix)
control(HIVmix)[100:110,]
test(HIVmix)[100:110,]

SNVs <- summary(HIVmix, sig.level=0.05, adjust.method="BH")
write.table(SNVs,"/scratch/rohannew/Nilesh/Analysis/Mapping/ultradeep/based_on_exome_data/07_Rec3/07_Rec3_significant_SNPs.txt",sep="\t")

a<-(test(HIVmix))
write.table(a,"02_Surgery_counts.txt",sep="\t")

b<-(control(HIVmix))
write.table(b,"02_Blood_counts.txt",sep="\t")

write.table(data.frame(p.adjust(p.val(HIVmix))),"02_Surgery_Adj_p_values.txt",sep="\t")
write.table(data.frame(p.val(HIVmix)),"02_Surgery_p_values.txt",sep="\t")


