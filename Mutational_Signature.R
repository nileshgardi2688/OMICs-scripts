library(deconstructSigs)
sample.mut.ref<-read.table("02_Rec1.txt",header=T)
sigs.input <- mut.to.sigs.input(mut.ref = sample.mut.ref, 
                                sample.id = "Sample", 
                                chr = "chr", 
                                pos = "pos", 
                                ref = "ref", 
                                alt = "alt")
								
Rec1 = whichSignatures(tumor.ref = sigs.input,
                           signatures.ref = signatures.exome.cosmic.v3.may2019,
                           sample.id = "02_Rec1",
                           contexts.needed = TRUE,
                           tri.counts.method = 'exome2genome')		

plotSignatures(Rec1, sub = '02_Rec1')
makePie(Rec1, sub = '02_Rec1')

sample.mut.ref<-read.table("02_Rec1.txt",header=T)
sigs.input <- mut.to.sigs.input(mut.ref = sample.mut.ref, 
                                sample.id = "Sample", 
                                chr = "chr", 
                                pos = "pos", 
                                ref = "ref", 
                                alt = "alt")
								
Rec1 = whichSignatures(tumor.ref = sigs.input,
                           signatures.ref = signatures.nature2013,
                           sample.id = "02_Rec1",
                           contexts.needed = TRUE,
                           tri.counts.method = 'exome2genome')		

plotSignatures(Rec1, sub = '02_Rec1')
makePie(Rec1, sub = '02_Rec1')							   