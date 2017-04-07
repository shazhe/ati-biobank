## Reduce the dimensionality of the idps -- clustering by correlation does not help much
## Do this by hierarhical clustering varialbes with high linear correlation
idp.cor <- cor(data.idps)
idp.discors <- as.dist(1- abs(idp.cor))
idp.cluster <- hclust(idp.discors, method = "average")
idp.dend <- as.dendrogram(idp.cluster)

idp.ccut <- cut(idp.dendp, h = 0.9)
plot(idp.ccut$upper, ylim = c(0.5, 1))
cut.trees <- cutree(idp.cluster, h = 0.1)
table(cut.trees[,1], cut.trees[, 11])

library(corpcor)
idp.parcor <- cor2pcor(idp.cor)
idp.dispcors <- as.dist(1-abs(idp.parcor))
idp.clp <- hclust(idp.dispcors, method = "average")
idp.dendp <- as.dendrogram(idp.clp)

cut.trees <- cutree(idp.clp, h = 0.1)
