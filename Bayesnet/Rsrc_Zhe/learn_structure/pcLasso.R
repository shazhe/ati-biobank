#### Estimate the Hetcor correlation matrix
#### And do GLASSO on the partial correlation matrix

library(polycor)
library(glasso)

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


t1 <- system.time(poly0 <- hetcor(V79m))
## This will usually takes about 2 hours to compute
## With warning messgead of NaNs produced
## Why? for two categorical variables, there are 0 in the contingency table
## a contiuous correction can be done which will affect the value
## without correction is fine but just not stable.

## Compute the correlation matrix for 5 bootstrap samples
Boot5 <- lapply(1:5, function(x) V79m[sample(1:nrow(V79m), size=nrow(V79m), replace = TRUE),])
library(parallel)
p.hetcor <- function(x){
    hetcor(Boot5[[x]])
    }
tt <- system.time(Poly5 <- mclapply(1:5, p.hetcor,
                                    mc.cores = getOption("mc.cores",5 )))

write.csv(poly0$correlation, file = "ppcor0.csv", row.names = FALSE)
write.csv(Poly5[[1]]$correlation, file = "ppcorb1.csv", row.names = FALSE)
write.csv(Poly5[[2]]$correlation, file = "ppcorb2.csv", row.names = FALSE)
write.csv(Poly5[[3]]$correlation, file = "ppcorb3.csv", row.names = FALSE)
write.csv(Poly5[[4]]$correlation, file = "ppcorb4.csv", row.names = FALSE)
write.csv(Poly5[[5]]$correlation, file = "ppcorb5.csv", row.names = FALSE)










## Use an ordinary covariance matrix to test sparse partial correlation in glasso
V79m <- read.csv("/home/fs0/zhesha/ukbb/tetrad/data/V79m.csv")
V79m.s <- scale(V79m)
s.test <- cov(V79m.s)

rholist <- exp(-10:0)
logs <- sapply(rholist, function(x) glasso(s.test, x)$loglik)

w1 <- as.matrix(path1$wi[,,1])
w10 <- as.matrix(path1$wi[,,10])

## BIC score function for cross validation
BIC.path <- function(data, W){
    W <- path1$wi[, , 1]
    k <- nrow(W)
    p <- (k*k - sum(W == 0) - k)/2 + 2*k
    n <- nrow(data)
    ss <- sum(apply(data, 1, function(x) crossprod(x, crossprod(W, x))))
    k*log(2*pi) - log(det(W)) + ss + p*2
}

Bscore <- apply(path1$wi, 3, BIC.path, data = V79m.s)
plot(path1$rholist, Bscore)
