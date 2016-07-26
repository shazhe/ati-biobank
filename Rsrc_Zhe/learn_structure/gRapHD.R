library(gRapHD)
## Major functions are minForest and stepw
## Below shows examples for mixted data (both discrete and continuous)
data(dsMixed)
str(dsMixed)

## 79Vars
data.sidp1 <- read.csv("/home/fs0/zhesha/ukbb/ati-biobank/Rsrc_Zhe/V79.csv")

## search for a minimum spanning forests
m1 <- minForest(data.sidp1,homog=TRUE,forbEdges=NULL,stat="LR")
plot(m1,numIter=1000)

## apply a forward search on the forest we've just found
m2 <- stepw(m1, data.sidp1)
plot(m2,numIter=1000) # same as previous

## degree of the edges
table(Degree(m2))

## the BIC and AIC of the fittd model
fit(edges=m2@edges, dataset=data.sidp1, homog = TRUE)

## find clique structure in the graph
clique.sets <- perfSets(m2)

## fancy plotting features to be explored when necessary
