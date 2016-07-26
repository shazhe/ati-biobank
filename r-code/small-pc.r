# Load file
message("Loading small matrix")
small = read.csv(file="../small-matrix/small_filled_all.csv", header=TRUE);

# Separate modifiable risk factors from general 
mods = small[,1:41]
idps = small[,42:ncol(small)]

# Perform hierarchical clustering
message("Clustering IDPs")
distIdps = dist(t(idps), method = "euclidean")
hclustIdps = hclust(distIdps, method = "average")
# plot(hclustIdps)

message("Cutting hierarchical cluster")
hclustIdpsCut030 = cutree(hclustIdps, 30)
hclustIdpsCut060 = cutree(hclustIdps, 60)
hclustIdpsCut090 = cutree(hclustIdps, 90)
hclustIdpsCut120 = cutree(hclustIdps, 120)
hclustIdpsCut150 = cutree(hclustIdps, 150)
hclustIdpsCut180 = cutree(hclustIdps, 180)
