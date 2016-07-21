library(gRapHD)
## Major functions are minForest and stepw
## Below shows examples for mixted data (both discrete and continuous)
data(dsMixed)
str(dsMixed)

## search for a minimum spanning forests
m1 <- minForest(dsMixed,homog=TRUE,forbEdges=NULL,stat="LR")
plot(m1,numIter=1000)

## apply a forward search on the forest we've just found
m2 <- stepw(m1, dsMixed)
plot(m2,numIter=1000) # same as previous

## degree of the edges
table(Degree(m2))

## the BIC and AIC of the fittd model
fit(edges=m2@edges, dataset=dsMixed, homog = FALSE)

## find clique structure in the graph
clique.sets <- perfSets(m2)

## fancy plotting features to be explored when necessary
