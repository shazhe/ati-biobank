#### This file pre-process the data from the saved matrix in to a csv file

### Before feed into tetrad
## Read in the saved matrix from the csv file
V79m <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/clusters/small-with-idp-at-1.10-most.csv", header = TRUE)
V79a <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/clusters/small-with-idp-at-1.10-average.csv", header = TRUE)
write.csv(V79m, file = "V79m.csv", row.names = FALSE)
write.csv(V79a, file = "V79a.csv", row.names = FALSE)
### Then analysis done in tetrad: GES + PC LiNGAM
### First on the entire data set
### Then on 7 bootstrap samples of the data (3 same size, 3 half size, 1 third size)



#############################################################################
##   Analyisis using 7 bootstrap samples (3 full, 3 half, 1 third)         ##
#############################################################################
#### Stable Edges (directed from PC-LinGAM)
filedir <- "/home/fs0/zhesha/ukbb/tetrad/results/resV79/"
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

#############################################################################
##            Analyisis using 10 half bootstrap samples                    ##
#############################################################################
filedir <- "/home/fs0/zhesha/ukbb/tetrad/results/resV79half/"

#### Stable Edges from GES(undirected)
V79h.u <- lapply(1:11, function(x) txt2mat(paste0(filedir, "GES/graph", x, ".txt")))
## keep edges that appears 80% of the time
V79h.u1 <- edgeChanges(V79h.u[[1]], V79h.u[-1], stable = 0.8)
par(mfrow = c(1,2))
image.plot(V79h.u1[[1]])
image.plot(V79h.u1[[2]])

## Plot the sparse graph
V79h.u2 <- stableMat(V79h.u1[[2]])
V79h.us <- V79h.u2$mat
V79h.usn <- shortNames(colnames(V79h.us))
graph.79h.us <- mat2graph(V79h.us, V79h.usn, direction = "undirected")

pdf("Half_SEdges0.pdf", width = 30, height = 15)
attrs <- list(node = list(fillcolor = "lightblue", fontsize = 30,
                          ratio = "fill", nodesep = 10),
              edge = list(arrowsize = 0.5))
plot(graph.79h.us, attrs = attrs)
dev.off()

write.csv(V79h.usn, file = "GESNames.csv")

#### Stable Edges directed (from PC-LinGAM)
V79h.d <- lapply(1:11, function(x) txt2mat(paste0(filedir, "PCL/graph", x, ".txt"), undirected = FALSE))
## keep edges that appears 80% of the time
V79h.d1 <- edgeChanges(V79h.d[[1]], V79h.d[-1], stable = 0.8)
par(mfrow = c(1,2))
image.plot(V79h.d1[[1]])
image.plot(V79h.d1[[2]])

## Plot the sparce graph
V79h.d2 <- stableMat(V79h.d1[[2]])
V79h.ds <- V79h.d2$mat
V79h.dsn <- shortNames(colnames(V79h.ds))
graph.79h.ds <- mat2graph(V79h.ds, V79h.dsn, direction = "directed")

pdf("Half_SEdges.pdf", width = 20, height = 15)
attrs = list(node = list(fillcolor = "lightblue", fontsize = 50,
                         ratio = "fill", nodesep = 20))
plot(graph.79h.ds, attrs = attrs)
dev.off()

write.csv(V79h.dsn, file = "PCLinNames.csv")

#### Save the resulted matrix as a Gephi output
## Category names
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


catsidp <- c("dMRI TBSS",
             "dMRI TBSS",
             "rfMRI Con 25 Edge",
             "rfMRI Con 100 Edge",
             "rfMRI Con 25 Edge",
             "rfMRI Con 25 Edge",
             "rfMRI Con 25 Edge",
             "dMRI TBSS",
             "dMRI TBSS",
             "rfMRI Con 25 Edge",
             "dMRI Probtrack",
             "rfMRI Con 25 Edge",
             "dMRI TBSS",
             "rfMRI Con 25 Edge",
             "dMRI Probtrack",
             "dMRI Probtrack",
             "dMRI TBSS",
             "SWI",
             "T1 SIENAX",
             "dMRI TBSS",
             "dMRI Probtrack",
             "rfMRI Amp 100",
             "rfMRI Con 25 Edge",
             "rfMRI Con 25 Edge",
             "dMRI TBSS")


cats1 <- c(catsmrf1,catsidp1)

V79h.usAttrs <- list(names = as.character(V79h.usn$names),
                     short.names = as.character(V79h.usn$short.names),
                     category = cats1[V79h.u2$indx] )

gexf.from.adj(adjm = V79h.us,attributes = V79h.usAttrs, undirected = T,
              directory = "/home/fs0/zhesha/ukbb/tetrad/",
              filename = "V79tetradGES.gexf")

V79h.dsAttrs <- list(names = as.character(V79h.dsn$names),
                     short.names = as.character(V79h.dsn$short.names),
                     category = cats1[V79h.d2$indx] )

gexf.from.adj(adjm = V79h.ds,attributes = V79h.dsAttrs, undirected = F,
              directory = "/home/fs0/zhesha/ukbb/tetrad/",
              filename = "V79tetradPCL.gexf")
