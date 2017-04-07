#### Save the resulted matrix as a Gephi output
## Category names
library(igraph)
library(rgexf)

gexf.from.adj <- function(adjm,attributes=list(),undirected=T,
                          directory="/home/fs0/atsokos/scratch/gephi/",
                          filename="graph.gexf") {
    adjm <- unname(adjm)
    if(undirected) {
        v <- adjm[lower.tri(adjm,diag=T)]
        adjm <- abs(adjm)
        adj.igraph <- graph.adjacency(adjm,weighted=T,mode="upper")
        E(adj.igraph)$Direction <- sign(v[v!=0])
    } else {
        v <- adjm[,]
        adjm <- abs(adjm)
        adj.igraph <- graph.adjacency(adjm,weighted=T)
        E(adj.igraph)$Direction <- sign(v[v!=0])
    }
    p <- nrow(adjm)
    if(length(attributes)>0) {
        for(i in 1:length(attributes)) {
        adj.igraph <- set.vertex.attribute(adj.igraph,names(attributes)[i],1:p,attributes[[i]])
        }
    }
    setwd(directory)
    adj.gexf <- igraph.to.gexf(adj.igraph)
    print(adj.gexf,file=filename)
    adj.gexf
}


## make categories ##

catsmrf <- c("Diet",
           "Supplements",
           "Supplements",
           "Supplements",
           "Supplements",
           "Supplements",
           "Smoking",
           "Smoking",
           "Alcohol",
           "Physical Activity",
           "Physical Activity",
           "Physical Activity",
           "Sleep",
           "Sleep",
           "Sleep",
           "Psychological Status",
           "Physical Measures",
           "Blood Pressure",
           "Blood Pressure",
           "Blood Pressure",
           "Diagnosis",
           "Social",
           "Social",
           "Hearing",
           "Hearing",
           "Hearing",
           "Cognitive Measures",
           "Cognitive Measures",
           "Cognitive Measures",
           "Cognitive Measures",
           "Demographics",
           "Demographics",
           "Demographics",
           "Demographics",
           "Demographics",
           "Inflammation",
           "Inflammation",
           "Cholesterol",
           "Cholesterol",
           "MRI Confound",
           "Diagnosis")




catsidp <- c("SW1",
              "rfMRI con 25",
              "rfMRI con 25",
              "dMRI Prob",
              "rfMRI con 100",
              "rfMRI con 25",
              "dMRI TBSS",
              "dMRI TBSS",
              "rfMRI con 25",
              "rfMRI con 25",
              "rfMRI con 25",
              "dMRI Prob",
              "tfMRI",
              "dMRI Prob",
              "dMRI Prob",
              "SW1",
              "dMRI Prob",
              "dMRI TBSS",
              "dMRI TBSS",
              "dMRI TBSS",
              "dMRI TBSS",
              "rfMRI con 25",
              "dMRI Prob",
              "rfMRI amp 100",
              "rfMRI con 100",
              "rfMRI con 25",
              "T1_SIENAX",
              "dMRI Prob",
              "rfMRI con 25",
              "dMRI TBSS",
              "dMRI TBSS",
              "tfMRI",
              "rfMRI con 25",
              "dMRI Prob",
              "dMRI TBSS",
              "rfMRI con 25",
              "T1_SIENAX",
              "dMRI Prob")


cats <- c(catsmrf,catsidp)
