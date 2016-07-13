#### This file pre-process the data from the saved matrix in to a csv file
#### Before feed into tetrad


## Read in the saved matrix from the csv file
data1 <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/big-matrix/big_visit1.csv", header = FALSE)

datnames <- scan(file = "/home/fs0/anavarro/scratch/ati-biobank/big-matrix/big_names.csv")
names(data1) <- datnames


## A simple brutal imputation of missing value by median of the variables
imputeM <- function(x){
    x[which(is.na(x))] = median(x, na.rm = TRUE)
    x
}
data2 <- sapply(data1, imputeM)
names(data2) <- datnames
## sepearte the data according to their types
data.info <- read.csv(file = "~/ukbb/ati-biobank/matlab/bbuk-variables.csv")
name.cont <- data.info[which(data.info$Type == "Continuous"), 1]
name.discrete <- data.info[which(data.info$Type == "Discrete"), 1]
name.bin <- data.info[which(data.info$Type == "Binary"), 1]
name.nom <- data.info[which(data.info$Type == "Norminal"), 1]
name.ord <- data.info[which(data.info$Type == "Ordinal"), 1]

data.cont <- data.frame(data2[, which(names(data2) %in% name.cont)])
data.discrete <- data2[, which(names(data2) %in% name.discrete)]
data.bin <- data2[, which(names(data2) %in% name.bin)]
data.nom <- data2[, which(names(data2) %in% name.nom)]
data.ord <- data2[, which(names(data2) %in% name.ord)]

## Use Johnson's transformation to increase normality
#install.packages("jtrans", contriburl = "http://mirrors.ebi.ac.uk/CRAN/src/contrib/")
library(jtrans)
data.contJ <- matrix(0, nrow(data.cont), ncol(data.cont))
for (i in 1:ncol(data.cont)){
    data.contJ[,i] <- jtrans(data.cont[,i])$transformed
    }
data.contJ <- apply(data.cont, function(x) jtrans(x)$transformed )


vnames <- paste0("v", datnames)
write.csv(data.cont, file = "Vcont.csv")
write.csv(data.cont, file = "Vdis.csv")
write.csv(data.cont, file = "Vbin.csv")
write.csv(data.cont, file = "Vnom.csv")
write.csv(data.cont, file = "Vord.csv")
