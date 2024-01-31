library(WGCNA)
setwd("D:/Cell line data analysis/20130209/T47D/WGCNA")
datExpr<-read.table("input.txt",header=T,row.names=1)
############input.txt is gene expression data (which are highly variable) stored in text file where genes are in column and samples are in rows.  
net = blockwiseModules(datExpr, power = 12,networkType="signed", maxBlockSize=5000,minModuleSize=100,reassignThreshold  =  0,  mergeCutHeight  =  0.25,
numericLabels  =  TRUE,  pamRespectsDendro  =  FALSE,
saveTOMs  =  TRUE,
saveTOMFileBase  =  "femaleMouseTOM",
verbose  =  3)


table(net$colors)
sizeGrWindow(12,  9)
#  Convert  labels  to  colors  for  plotting
mergedColors  =  labels2colors(net$colors)
#  Plot  the  dendrogram  and  the  module  colors  underneath
plotDendroAndColors(net$dendrograms[[1]],  mergedColors[net$blockGenes[[1]]],
"Module  colors",
dendroLabels  =  FALSE,  hang  =  0.03,
addGuide  =  TRUE,  guideHang  =  0.05)
moduleLabels  =  net$colors
moduleColors  =  labels2colors(net$colors)
MEs  =  net$MEs;
geneTree  =  net$dendrograms[[1]];
save(MEs,  moduleLabels,  moduleColors,  geneTree,
file  =  "FemaleLiver-02-networkConstruction-auto.RData")
write.table(moduleColors,"col.txt",sep="\t")
write.table(moduleLabels,"lab.txt",sep="\t")
write.table(MEs,"MEs.txt",sep="\t")
write.table(names(datExpr),"name.txt",sep="\t")

lnames = load(file = "FemaleLiver-01-dataInput.RData");
lnames = load(file = "FemaleLiver-02-networkConstruction-auto.RData"); 

traitData = read.table("clin.txt",head=T); 
dim(traitData) 
names(traitData)
# remove columns that hold information we do not need. 
#allTraits = traitData[, -c(31, 16)]; 
allTraits = traitData[, c(1, 3, 4,15,18,22,27:50) ]; 
dim(allTraits) 
names(allTraits)
# Form a data frame analogous to expression data that will hold the clinical traits.
femaleSamples = rownames(datExpr); 
traitRows = match(femaleSamples, allTraits$sample);
datTraits = allTraits[traitRows, -1]; 
rownames(datTraits) = allTraits[traitRows, 1];
#collectGarbage();

# Define numbers of genes and samples 
nGenes = ncol(datExpr); 
nSamples = nrow(datExpr); 
# Recalculate MEs with color labels 
MEs0 = moduleEigengenes(datExpr, moduleColors)$eigengenes 
MEs = orderMEs(MEs0) 
moduleTraitCor = cor(MEs, datTraits, use = "p"); 
moduleTraitPvalue = corPvalueStudent(moduleTraitCor, nSamples);

sizeGrWindow(10,6) 
# Will display correlations and their p-values 
textMatrix = paste(signif(moduleTraitCor, 2), "\n(", signif(moduleTraitPvalue, 1), ")", sep = ""); 
dim(textMatrix) = dim(moduleTraitCor) 
par(mar = c(6, 8.5, 3, 3)); 
# Display the correlation values within a heatmap plot 
labeledHeatmap(Matrix = moduleTraitCor, xLabels = names(datTraits), yLabels = names(MEs), ySymbols = names(MEs), colorLabels = FALSE, colors = greenWhiteRed(50), textMatrix = textMatrix, setStdMargins = FALSE, cex.text = 0.5, zlim = c(-1,1), main = paste("Module-trait relationships"))


days_to_death = as.data.frame(datTraits$days_to_death); 
names(days_to_death) = "days_to_death"
modNames = substring(names(MEs), 3)
geneModuleMembership = as.data.frame(cor(datExpr, MEs, use = "p")); 
MMPvalue = as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nSamples)); 

names(geneModuleMembership) = paste("MM", modNames, sep="");
names(MMPvalue) = paste("p.MM", modNames, sep="");
geneTraitSignificance = as.data.frame(cor(datExpr, days_to_death, use = "p")); 
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples));
names(geneTraitSignificance) = paste("GS.", names(days_to_death), sep=""); 
names(GSPvalue) = paste("p.GS.", names(days_to_death), sep="");

module = "blue" 
column = match(module, modNames); 
moduleGenes = moduleColors==module;
sizeGrWindow(7, 7); 
par(mfrow = c(1,1)); 
verboseScatterplot(abs(geneModuleMembership[moduleGenes, column]),abs(geneTraitSignificance[moduleGenes, 1]), xlab = paste("Module Membership in", module, "module"), ylab = "Gene significance for days to death", main = paste("Module membership vs. gene significance\n"), cex.main = 1.2, cex.lab = 1.2, cex.axis = 1.2, col = module)


probes = names(datExpr) 
geneInfo0 = data.frame(UniqueID = probes, moduleColor = moduleColors, geneTraitSignificance, GSPvalue)
modOrder = order(-abs(cor(MEs, days_to_death, use = "p"))); 
for (mod in 1:ncol(geneModuleMembership)) 
{ oldNames = names(geneInfo0) 
  geneInfo0 = data.frame(geneInfo0, geneModuleMembership[, modOrder[mod]], MMPvalue[, modOrder[mod]]); 
  names(geneInfo0) = c(oldNames, paste("MM.", modNames[modOrder[mod]], sep=""), paste("p.MM.", modNames[modOrder[mod]], sep="")) 
}  
geneOrder = order(geneInfo0$moduleColor, -abs(geneInfo0$GS.days_to_death)); 
geneInfo = geneInfo0[geneOrder, ]


