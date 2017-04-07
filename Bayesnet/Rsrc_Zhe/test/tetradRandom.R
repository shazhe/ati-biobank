## Read in the saved matrix from the csv file
dataMed <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/medium-matrix/medium_names_vars_mods_filled.csv", header = TRUE)
dataSmall <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/small-matrix/small_filled_all.csv", header = TRUE)
data.idps <- dataSmall[, -c(1:41)]
dataMinfo <- read.csv(file = "/home/fs0/anavarro/scratch/ati-biobank/medium-matrix/list-medium_matrix.csv")
dataAll <- cbind(dataMed, data.idps)


rand.idx <- sort(sample(1:ncol(dataSmall), 350))
rand.data <- dataSmall[, rand.idx]
write.csv(rand.data, file = "rand2.csv", row.names = FALSE)
