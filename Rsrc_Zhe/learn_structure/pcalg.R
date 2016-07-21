#### This file pre-process the data from the saved matrix in to a csv file
#### Before feed into tetrad


## Read in the saved matrix from the csv file
dataSmall <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/small-matrix/small_filled_all.csv", header = TRUE)

dataSinfo <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/small-matrix/list-small-matrix.csv")


## Separate and recombination of data
data.risk <- dataSmall[, 1:41]     # Risk factors
data.idps <- dataSmall[, -c(1:41)]  # imaging data

## Notes on the imaging data
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

## assmeble small dataframes
d.idps <- data.idps[, 1:731]
d.ICA25a <- data.idps[, c(idp.amp25)]

data.idp <- cbind(data.risk, d.idps)
data25a <- cbind(data.risk, d.ICA25a)

## extract short names for variables
shortname <- function(x, split = "_"){
    nstr <- unlist(strsplit(x, split=split, fixed = TRUE))
    kk <- length(nstr)
    if(kk > 1){
        reg.n <- paste(paste0(sapply(nstr[1:(kk-1)], substr, 1,1),
                              collapse = ""), nstr[kk], sep = "_")
    } else{
        reg.n <- x
        }
    reg.n
}

vnames <- names(data25a)
VNs <- sapply(vnames, shortname, split = ".")
names(data25a) <- VNs


#### causal inference on small data
library(pcalg)

## Try estimate skeleton
suffStat <- list(C = cor(data25a), n = nrow(data25a))
skel25a.fit <- skeleton(suffStat, indepTest = gaussCItest, m.max = 1,
                     alpha = 0.01, labels = names(data25a), verbose = TRUE)
#plot(skel25a.fit, main = "Estimated skeleton")

## Try a PC search -- cost highly depend on m.max!
pc.25a <- pc(suffStat, indepTest = gaussCItest, m.max = 2,
             alpha = min(1/nrow(data25)*ncol(data25), 0.01),
             labels = names(data25a), verbose = TRUE)
#plot(pc.25a, main = "Estimated graph by PC")

## More fancy plots on the PC results
graph.25aPC <- getGraph(pc.25a)
g25PC.op <- agopen(graph.25aPC, "g25")
attrs <- list(node = list(shape = "ellipse", fixedsize = FALSE, fontsize = 18))

NAttrs <- list(label = names(I25amp.data))
, fillcolor = c(rep("yellow", 7) ,rep("blue", 21)) )
pdf("pc25.pdf", height = 10, width = 10)
plot(graph.25, main = "Estimated graph by PC", attrs=attrs, nodeAttrs = NAttrs)
dev.off()



## Try GES search
score25a  <- new("GaussL0penObsScore", data = as.matrix(data25a))
gs.25a <- ges(ncol(data25a), score = score25a, maxDegree = 5)
graph.25aGES <- as(gs.25a$essgra, "graphNEL")
## Try plot with node names and different colors
plot(graph.25aGES, main = "Estimated graph by PC",
     nodeAttrs = NAttrs, attrs = attrs)
