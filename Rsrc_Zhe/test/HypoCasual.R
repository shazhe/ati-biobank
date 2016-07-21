#### This file serves as a test script for using selected variables for causaul inference


## Read the selected variables from the saved csv file
data1 <- read.csv(file = "/home/fs0/zhesha/ukbb/ati-biobank/matlab/selectVars.csv")
names(data1)
summary(data1)

## To have a working data set for now, just drop variables that have too many NAs
nacounts <- colSums(is.na(data1))
vnames.out <- which(nacounts > nrow(data1)*0.2)
data2 <- data1[, -vnames.out]

## And also remove the few categorical variables that are too messy now
names2 <- names(data2)
vnames.out2 <- c(grep(20003, names2), grep(20002, names2), grep(6138, names2))
data3 <- data2[, -vnames.out2]
summary(data3)

## now get a working dataframe by omitting NAs
data4 <- na.omit(data3)

write.csv(data4, file = "testmat.csv")
