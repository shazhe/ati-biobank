#### This file use the constraint based methods in the package bnlearn
#### with/without fixed edge
#### Bnlearn deal with different type of variables.

library(bnlearn)

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


tt1<- system.time(gs1 <- gs(V79m, blacklist = bl1))
pdf("gs1.pdf", width = 20, height = 20)
graphviz.plot(gs1)
dev.off()

tt2 <- system.time(iamb1<- iamb(V79m, blacklist = bl1))
pdf("iamb1.pdf", width = 20, height = 20)
graphviz.plot(iamb1)
dev.off()

## Don't run because us a lot memeory
##tt3 <- system.time(fiamb1 <- fast.iamb(V79m, blacklist = bl1))
##pdf("fiamb1.pdf", width = 20, height = 20)
##graphviz.plot(fiamb1)
##dev.off()

tt4 <- system.time(iiamb1 <- inter.iamb(V79m, blacklist = bl1))
pdf("iiamb1.pdf", width = 50, height = 50)
graphviz.plot(iiamb1)
dev.off()

tt5 <- system.time(mmpc1 <- mmpc(V79m, blacklist = bl1))
pdf("mmpc1.pdf", width = 20, height = 20)
graphviz.plot(mmpc1)
dev.off()

tt6 <- system.time(shpc1 <- si.hiton.pc(V79m, blacklist = bl1))
pdf("shpc1.pdf", width = 20, height = 20)
graphviz.plot(shpc1)
dev.off()

## a parallel version can be done bu not for now
library(parallel)
cl = makeCluster(2)
gs(x = V79m, cluster = cl)

#### Do score-based method
hc1 <- hc(V79m, blacklist = bl1, score = "bic-cg")
hc2 <- hc(V79m, blacklist = bl1, score = "aic-cg")


pdf("hc1.pdf", width = 20, height = 20)
graphviz.plot(hc1)
dev.off()

tabu1 <- tabu(V79m, blacklist = bl1, scorre = "bic-cg")
pdf("tabu1.pdf", width = 20, height = 20)
graphviz.plot(tabu1)
dev.off()




source(file = "/home/fs0/zhesha/ukbb/ati-biobank/Rscr_Zhe/R2gephi.R")
aa <- amat(hc1)
bb <- amat(tabu1)
attr <- list(Names=Vnames,Categories=cats)
gexf.from.adj(adjm = aa, attributes = attr, undirected = F,
              directory = "/home/fs0/zhesha/ukbb/",
              filename = "V79hc.gexf")

gexf.from.adj(adjm = bb, attributes = attr, undirected = F,
              directory = "/home/fs0/zhesha/ukbb/",
              filename = "V79tabu.gexf")
