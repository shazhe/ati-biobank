#### This file pre-process the data from the saved matrix in to a csv file
#### Before feed into tetrad


## Read in the saved matrix from the csv file
data1 <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/small-matrix/small_vars_mods.csv", header = FALSE)

datnames <- scan(file = "/home/fs0/anavarro/scratch/ati-biobank/small-matrix/small_names_vars_mods.csv", sep = ",")
names(data1) <- datnames

## Now simply omit all the missing values
data2 <- na.omit(data1)
library(MASS)
par(mfrow = c(5,6))
for(i in c(1, 6:31)){
    truehist(data2[,i], xlab = paste0("v", names(data2)[i]),
             main = "")
}

vnum <- c(1329, 1558, 21001, 4079, 4080, 20016, 20023, 400)

quantn <- c(1329,1558, 864, 884, 904, 1170, 1160, 2080, 2050, 21001,4079, 4080,1031, 4230, 4241, 20016, 20023, 400)
qualtn <- c(20003, 6155, 1239, 1249,20002, 2443,6160, 2247, 2257, 20018)

data.num <- data2[,which(names(data2) %in% vnum)]
data.cat <- data2[,-which(names(data2) %in% vnum)]
## simple way to make the last two variables more normal -- log transform
#data.num[,c(3,7,8)] <- log(data.num[, c(3,7,8)])

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
