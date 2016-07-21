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
data.idps <- dataSmall[, -c(1:41)]
names(data.num) <- paste0("v" 1:26)
write.table(data.num, file = "Vnum.txt", row.names = FALSE, sep = "\t",
            quote = FALSE)
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
