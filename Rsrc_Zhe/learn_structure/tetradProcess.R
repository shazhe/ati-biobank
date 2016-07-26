#### This file pre-process the data from the saved matrix in to a csv file
#### Before feed into tetrad


## Read in the saved matrix from the csv file
V79m <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/clusters/small-with-idp-at-1.10-most.csv", header = TRUE)
V79a <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/clusters/small-with-idp-at-1.10-average.csv", header = TRUE)
write.csv(V79m[,-1], file = "V79m.csv", row.names = FALSE)
write.csv(V79a[,-1], file = "V79a.csv", row.names = FALSE)


#### Then analysis done in tetrad: GES + PC LiNGAM
#### First on the entire data set
#### Then on 7 bootstrap samples of the data (3 same size, 3 half size, 1 third size)
#### Adjacency matrix saved to be read into R
library(Rgraphviz)
library(fields)
adMat1 <- as.matrix(read.table(file = "/home/fs0/zhesha/ukbb/ati-biobank/Rsrc_Zhe/Results/graph1.r.txt", header = TRUE, sep = ""))
adMat79.1 <- tetrad2R(adMat1)
## Create a graph object for plotting etc.
graph.79.1 <- new("graphAM", adjMat=adMat1, edgemode = "directed")
plot(graph.79.1, attrs = list(node = list(fontsize = 22, fixedsize = FALSE,
                                          fillcolor = "lightblue"),
                              edge = list(arrowsize = 0.5)))

filedir <- "/home/fs0/zhesha/ukbb/ati-biobank/Rsrc_Zhe/Results/"
V79adMats <- lapply(1:8, function(x) T2R(paste0(filedir, "graph", x, ".r.txt")))
V79c <- edgeChanges(V79adMats[[1]], V79adMats[-1])
image.plot(V79c[[1]])
image.plot(V79c[[2]])

## Plot the sparse graph
V79d <- stableMat(V79c[[2]])
V79d.names <- shortNames(colnames(V79d))
graph.79d <- mat2graph(V79d, V79d.names, direction = "directed")

pdf("StableEdges.pdf", width = 12, height = 8)
attrs <- list(node = list(fillcolor = "lightblue", fontsize = 30,
                          ratio = "fill", nodesep = 10),
              edge = list(arrowsize = 0.5))
plot(graph.79d, attrs = attrs)
dev.off()


#### use the undirected results from GES
V79.undirectMat <- lapply(1:8, function(x) txt2mat(paste0(filedir, "graph", x, ".txt")))
V79uc <- edgeChanges(V79.undirectMat[[1]], V79.undirectMat[-1])
par(mfrow = c(1,2))
image.plot(V79uc[[1]])
image.plot(V79uc[[2]])

## Plot the sparce graph
V79u <- stableMat(V79uc[[2]])
V79u.names <- shortNames(colnames(V79u))
graph.79u <- mat2graph(V79u, V79u.names, direction = "undirected")

pdf("StableEdges0.pdf", width = 30, height = 15)
attrs = list(node = list(fillcolor = "lightblue", fontsize = 50,
                         ratio = "fill", nodesep = 20))
plot(graph.79u, attrs = attrs)
dev.off()


#### Generate the 10 statbility test sets


## small 2 41Risk + 82IDPs = 123Vars

## small 3 41Risk + 308IDPs = 349Vars

## medium 1 73Risk + 38IDPs = 111Vars

## medium 2 73Risk + 82IDPs = 155Vars

## medium 3 73Risk + 308IDPs = 381Vars

















## Notes on the images data
idp.T1S <- 1:11
idp.T1F <- 12:26 # mater vols
idp.SWI <- 27:40 # obj vols
idp.tfMRI <- 41:56
idp.dMRI.T <- 57:488
idp.dMRI.P <- 489:731

## ICAs not clear about the meaning
idp.amp25 <- 732:752
idp.amp100 <- 753:807
idp.con25 <-808:1017
idp.con100 <- 1018: 2502

## try to find some relationships within IDP groups
data.idpA <- data.idps[, 1:731]
data.ICA25 <- data.idps[, c(idp.amp25, idp.con25)]
data.ICA100 <- data.idps[, c(idp.amp100, idp.con100)]

write.csv(dataSmall1, file = "Vsmall.csv", row.names = FALSE)
write.csv(data.num, file = "Vnum.csv", row.names = FALSE)
write.csv(data.cat, file = "Vcat.csv", row.names = FALSE)
write.csv(data.idps, file = "Vidps.csv", row.names = FALSE)

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
data.idps <- dataSmall[, -c(1:41)]
