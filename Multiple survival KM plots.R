x<-read.table("Data1.txt",header=T,row.names=1)
for(i in 1:(ncol(x)-2))
{
x$gene_class[x[,i]<=median(x[,i])]<-"Down"
x$gene_class[x[,i]>=median(x[,i])]<-"Up"
d<-x$gene_class
x1<-survfit(Surv(OS,status)~d)
x2<-survdiff(Surv(OS,status)~d)
p.val <- 1 - pchisq(x2$chisq, length(x2$n) - 1)
file<-as.matrix(read.table("Data1.txt"))
infile <- paste(file[1,(i+1)],".png",sep="")
png(infile)
plot(x1,col=c("red","blue"),xlab="Overall survival",ylab="Probability of survival",lwd=2,cex.axis=1,cex.lab=1,main=p.val)
#legend("bottomleft","p-Value="p.val,cex=1.3)
legend("topright",c("Down","Up"),cex=1.3,col=c("red","blue"),lty=1,lwd=3)
dev.off()
}