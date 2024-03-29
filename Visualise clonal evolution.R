library(timescape)
prev <- read.table("02_prev.txt", header=TRUE)
edges <- read.table("02_edges.txt", header=TRUE)
mutations <- read.table("02_mutations.txt", header=TRUE)
perturbations1 <- data.frame( pert_name = c("CAF..(Paclitaxel+Carboplatin)"), prev_tp = c("Biopsy"))
perturbations2 <- data.frame( pert_name = c("RT"), prev_tp = c("Surgery"))
perturbations3 <- data.frame( pert_name = c("Capecitabine"), prev_tp = c("Rec_1"))
perturbations4 <- data.frame( pert_name = c("Gemicitabine +Cisplatin"), prev_tp = c("Rec_2"))
perturbations<-rbind(perturbations1,perturbations2,perturbations3,perturbations4)
timescape(clonal_prev = prev, tree_edges = edges,perturbations = perturbations, mutations = mutations,alpha=5)

perturbations1 <- data.frame( pert_name = c("CEF"), prev_tp = c("Biopsy"))
perturbations2 <- data.frame( pert_name = c("Gemcitabine +Carboplatin"), prev_tp = c("Rec_1"))
perturbations3 <- data.frame( pert_name = c("Capecitabine"), prev_tp = c("Rec_2"))
perturbations4 <- data.frame( pert_name = c("Cyclophoshamide + Methotrexate+ FU"), prev_tp = c("Rec_3"))

