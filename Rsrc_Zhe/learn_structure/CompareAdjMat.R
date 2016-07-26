## The following function convert a tetrad output adjacency matrix to a R adjacency matrix
tetrad2R <- function(tMat){
    tMat <- - tMat
    tMat[tMat < 0] <- 0
    rownames(tMat) <- colnames(tMat)
    tMat
}
## The following function read in a tetrad output and convert it to R
T2R <- function(filename){
    tMat <- as.matrix(read.table(file = filename, header = TRUE, sep = ""))
    tetrad2R(tMat)
}

## Now count how many times an edge has changed compared to the original one
## And find the ones that never changes
edgeChanges <- function(Mat0, matlist, stable = 1){
    ## stable = (0,1] -- percentage of time an edge has not changed
    n.changes <- length(matlist) * (1-stable)
    MatC.temp <- lapply(matlist, function(x) Mat0 != x)
    MatC <- Reduce('+', MatC.temp)
    MatS <- Mat0
    MatS[MatC > n.changes] = 0
    return(list(MatC = MatC, MatS = MatS))
    }

## The following function convert tetrad txt graph to an adjacency matrix
txt2mat <- function(filename, undirected = TRUE, skips = c(2, 7), nlines = 3){
    nodes <- scan(filename, what = "character", skip = skips[1], nlines = nlines, sep = "")
    edges <- read.table(filename, skip = skips[2], sep = "")
    Mat <- matrix(0, nrow = length(nodes), ncol = length(nodes))
    rownames(Mat) <- colnames(Mat) <- nodes
    N.edges <- nrow(edges)
    for (i in 1:N.edges){
        n1 <- edges[i,2]
        n2 <- edges[i,4]
        edge <- edges[i,3]
        Vnames <- rownames(Mat)
        id.row <- which(nodes == n1)
        id.col <- which(nodes == n2)
        if(undirected){
            Mat[id.row, id.col] <- Mat[id.col, id.row] <- 1
        }else{
            if(edge == "-->"){
            Mat[id.row, id.col] <- 1
            }else if(edge == "---"){
            Mat[id.row, id.col] <- Mat[id.col, id.row] <- 1
            }else{
            Mat[id.col, id.row] <- 1
            }
        }
    }
    Mat
}

## function to find the reduced stable matrix
stableMat <- function(mat, indx.out = TRUE){
    names.in <-  unique(c(names(which(rowSums(mat) > 0)),
                          names(which(colSums(mat) > 0))))
    indx <- which(rownames(mat) %in% names.in)

    if(indx.out){
        list(mat = mat[indx, indx], indx = indx)
    }else{
        mat[indx, indx]
        }
    }

## function to make short names
shortNames <- function(names){
    idp <- rfmri <- 0
    short.names <- names
    for (i in 1: length(names)){
        if (length(grep("IDP", names[i])) > 0){
            idp <- idp + 1
            short.names[i] <- paste0("IDP.", idp)
        }else if(length(grep("rfMRI", names[i])) > 0){
            rfmri <- rfmri + 1
            short.names[i] <- paste0("rfMRI.", rfmri)
        }else{
            sp.names <- unlist(strsplit(names[i], split = ".",
                                        fixed = TRUE))
            k <- length(sp.names)
            if(k > 2){
                short.names[i] <- paste(sp.names[1],
                                        paste0(sapply(sp.names[2:(k-1)],
                                                      substr, 1,1),
                                               collapse = ""),
                                        sp.names[k], sep= ".")
            }else{
                short.names[i] <- names[i]
            }
        }
    }
    data.frame(names = names, short.names = short.names)
}

mat2graph <- function(mat, names, direction = "directed"){
    colnames(mat) <- rownames(mat) <- names$short.names
    new("graphAM", adjMat= mat, edgemode = direction)
    }
