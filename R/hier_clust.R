#' Function that provides agglomerative hierachcal slusters for a data set
#'
#' @param data data set
#'
#' @returns a data frame specifying the cluster assignment and index of each observation in the data set
#'
#' @export

hier_clust <- function(data){
    dist <- dist(data)
    dist <- as.matrix(dist)
    dist <- as.data.frame(apply(dist, 1, function(x) ifelse(x == 0, NA, x)))
    colnames(dist) <- NULL
    rownames(dist) <- NULL

    vec <- c(1, rep(NA, length.out = nrow(data) -1))
    while(NA %in% vec){
        i <- as.numeric(which(is.na(vec))[1])
        cur1 <- as.numeric(which.min(dist[,i]))
        cur <- as.numeric(rownames(dist)[cur1])
        if(!is.na(vec[cur])){
            vec[i] <- vec[cur]
            vec[cur] <- vec[cur]
            dist <- dist[-which(rownames(dist) == i),]
        }
        if(is.na(vec[cur])){
            vec[i] = i
            vec[cur] = i
            dist <- dist[-which(rownames(dist) == cur),]
        }
    }
    return(data.frame(index = rep(1:nrow(data)),
                      clusters = vec))
}
