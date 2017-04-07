
message('--- Loading librariers ---')
library(bnlearn)
library(Rgraphviz)
message('--- Done! ---')

#message('--- Loading data file: Small + IDP@1.10 (average) ---')
#dataset = read.csv(file="../clusters/small-with-idp-at-1.10-average.csv", header=TRUE, colClasses = "numeric")
#message('--- Done! ---')
message('--- Loading data file: Small + IDP@1.10 (most) ---')
dataset = read.csv(file="../clusters/small-with-idp-at-1.10-most.csv", header=TRUE, colClasses = "numeric")
message('--- Done! ---')

message('--- Runing Hill-Climbing method ---')
model = hc(dataset)

message('--- Done! ---')

message('Plotting')
graphviz.plot(model)
