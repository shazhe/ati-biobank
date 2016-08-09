library(bnlearn)
library(Rgraphviz)
library(graph)
library(igraph)

#### readin data and specify data type
V79m <- read.csv("/home/fs0/anavarro/scratch/ati-biobank/clusters/small-with-idp-at-1.10-most.csv")

V79atr <- read.csv("/home/fs0/zhesha/ukbb/ati-biobank/small-matrix/list-small-matrix.csv")

for (i in 1:41) {
    v.type = V79atr[i,4]
    if (v.type == "Binary"){
        V79m[,i] <- factor(V79m[,i])
    }else if(v.type == "Ordinal"){
        V79m[,i] <- ordered(factor(V79m[,i]))
    }else if(v.type == "Discrete"){
        V79m[,i] <- log(V79m[,i] + 1/max(V79m[,i]))
    }
}

##V79ds <- V79m[, which(V79atr[,4] == "Discrete")]

#### The blacklist accepte directed edges

#### 1 Try removing impossible directions
## A: remove idps --> risk factors -- this can be too restrictive
## B: Anything to Age or Gender
Vnames <- names(V79m)
blAge <- cbind(Vnames[-31], rep("Age", 78))
blGender <- cbind(Vnames[-34], rep("Gender", 78))
bl1 <- rbind(blAge, blGender)

tt3 <- system.time(fiamb1 <- fast.iamb(V79m, blacklist = bl1))

fiamb1.mat <-amat(fiamb1)
colnames(fiamb1.mat) <- rownames(fiamb1.mat) <- Vnames
graph.fiamb1 <- new("graphAM", adjMat= fiamb1.mat, edgemode = "directed")
attrs = list(node = list(fillcolor = "lightblue", fontsize = 100,
                         ratio = "fill", nodesep = 20))

pdf("fiamb1.pdf", width = 50, height = 50)
plot(graph.fiamb1, attrs = attrs)
dev.off()
