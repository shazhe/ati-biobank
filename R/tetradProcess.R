#### This file pre-process the data from the saved matrix in to a csv file
#### Before feed into tetrad


## Read in the saved matrix from the csv file
dataSmall <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/small-matrix/small_filled_all.csv", header = TRUE)

dataSinfo <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/small-matrix/list-small-matrix.csv")

dataSmall1 <- dataSmall[, 1:41]
## Separate variables type
stype <- dataSinfo$Type
for(i in 1:41){
    if(stype[i] == "Binary"){
        dataSmall1[,i] <- paste0("b", dataSmall1[,i])
    }else if(stype[i] == "Nominal"){
        dataSmall1[,i] <- paste0("cat", dataSmall1[,i])
    }
}

Vnum <- sapply(dataSmall1, is.numeric)
data.num <- dataSmall1[, Vnum]
data.cat <- dataSmall1[, !Vnum]
data.idps <- dataSmall[, -c(1:45, 2547:2561)]

write.csv(dataSmall1, file = "Vsmall.csv", row.names = FALSE)
write.csv(data.num, file = "Vnum.csv", row.names = FALSE)
write.csv(data.cat, file = "Vcat.csv", row.names = FALSE)
write.csv(data.idps, file = "Vidps.csv", row.names = FALSE)

## Notes on the images data

## Reduce the dimensionality of the idps
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
## previous analysis
pdf(file = "Vcon.pdf")
par(mfrow = c(3,3))
for(i in 1: ncol(data.num)){
    truehist(data.num[,i], xlab = paste0("v", names(data.num)[i]),
             main = "")
}
dev.off()

data.qt <- data2[,which(names(data2) %in% quantn)]
data.ql <- data2[,which(names(data2) %in% qualtn)]

write.csv(data.num, file = "Vnum.csv", row.names = FALSE)
write.csv(data.cat, file = "Vcat.csv", row.names = FALSE)

## A simple brutal imputation of missing value by median of the variables
imputeM <- function(x){
    x[which(is.na(x))] = median(x, na.rm = TRUE)
    x
}


## sepearte the data according to their types
data.info <- read.csv(file = "~/ukbb/ati-biobank/matlab/bbuk-variables.csv")
name.cont <- data.info[which(data.info$Type == "Continuous"), 1]
name.discrete <- data.info[which(data.info$Type == "Discrete"), 1]
name.bin <- data.info[which(data.info$Type == "Binary"), 1]
name.nom <- data.info[which(data.info$Type == "Norminal"), 1]
name.ord <- data.info[which(data.info$Type == "Ordinal"), 1]

data.discrete <- data2[, which(names(data2) %in% name.discrete)]
data.bin <- data2[, which(names(data2) %in% name.bin)]
data.nom <- data2[, which(names(data2) %in% name.nom)]
data.ord <- data2[, which(names(data2) %in% name.ord)]
vnames <- paste0("v", datnames)
write.csv(data.cont, file = "Vcont.csv")
write.csv(data.cont, file = "Vdis.csv")
write.csv(data.cont, file = "Vbin.csv")
write.csv(data.cont, file = "Vnom.csv")
write.csv(data.cont, file = "Vord.csv")
