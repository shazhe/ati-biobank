#### Estimate the Hetcor correlation matrix
#### And do GLASSO on the partial correlation matrix

library(polycor)
library(glasso)

V79m <- read.csv("/home/fs0/zhesha/ukbb/tetrad/data/79m.csv")
V79m.s <- as.data.frame(scale(V79m))
V79atr <- read.csv("/home/fs0/anavarro/scratch/ati-biobank/small-matrix/list-small-matrix.csv")
v.factor <- which(V79atr$Type != "Continuous")
for (i in v.factor){
    V79m.s[,i] <- factor(V79m.s[,i])
}
Poly.c <- hetcor(V79m.s)
