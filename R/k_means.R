#' Implements a basic k-means algorithm.
#'
#' @param dat A data frame
#' @param k A number
#' @param pca A boolean
#'
#' @return A list with a dataframe containing the original x & y values of the input data and a factor which contains the grouping variable, and the total sum of squares
#'
#' @import dplyr
#'
#' @export

k_means <- function(dat, k, pca = FALSE, max_iter = 1000){

    max_iter <- as.numeric(max_iter)
    k <- as.numeric(k)

    if (pca == TRUE) {
        #If pca is set to true, then PCA will be performed on 1st 2 dimensions
        data_pca <- dat %>%
            princomp()

        dat <- data_pca$scores %>%
            as_tibble() %>%
            select(Comp.1, Comp.2)
    }

    set.seed(37)

    x <- as.data.frame(dat[, 1])
    y <- as.data.frame(dat[, 2])

    colnames(x) = "x"
    colnames(y) = "y"

    start_points <- dat[sample(nrow(dat), k), ]

    start_x <- as.data.frame(start_points[, 1])
    start_y <- as.data.frame(start_points[, 2])

    distances <- get_distances(x, y, start_x, start_y)

    groups <- as.data.frame(
        names(distances)[apply(distances, MARGIN = 1, FUN = which.min)])

    colnames(groups) <- "Group"

    distances <- distances |>
        mutate(Group = as.factor(groups$Group),
               x = x$x,
               y = y$y)

    group_names <- levels(distances$Group)

    for (i in group_names) {

        start_x_i <- distances |>
            filter(Group == i) |>
            select(x) |>
            colMeans() |>
            as.numeric()

        start_y_i <- distances |>
            filter(Group == i) |>
            select(y) |>
            colMeans() |>
            as.numeric()

        if (i == "Group1") {

            start_x <- start_x_i
            start_y <- start_y_i

        } else {

            start_x <- rbind(start_x, start_x_i)
            start_y <- rbind(start_y, start_y_i)

        }

    }

    start_x <- as.data.frame(start_x)
    start_y <- as.data.frame(start_y)

    j <- 2

    while (j <= max_iter) {

        prev_sx <- start_x
        prev_sy <- start_y

        distances <- get_distances(x, y, start_x, start_y)

        groups <- as.data.frame(
            names(distances)[apply(distances, MARGIN = 1, FUN = which.min)])

        colnames(groups) <- "Group"

        distances <- distances |>
            mutate(Group = as.factor(groups$Group),
                   x = x$x,
                   y = y$y)

        for (i in group_names) {

            start_x_i <- distances |>
                filter(Group == i) |>
                select(x) |>
                colMeans() |>
                as.numeric()

            start_y_i <- distances |>
                filter(Group == i) |>
                select(y) |>
                colMeans() |>
                as.numeric()

            if (i == "Group1") {

                start_x <- start_x_i
                start_y <- start_y_i

            } else {

                start_x <- rbind(start_x, start_x_i)
                start_y <- rbind(start_y, start_y_i)

            }

        }

        if (identical(prev_sx, start_x) && identical(prev_sy, start_y)) {

            break

        }

        j <- j + 1

    }

    if (j == max_iter) {

        return(glue::glue(max_iter, " iterations reached without convergence"))

    }

    result_groups <- distances |>
        select(x, y, Group)

    dmin <- distances |>
        select(-Group, -x, -y)

    dmin <- apply(dmin, 1, min)

    result_tss <- sum(dmin^2)

    result <- list(groups = result_groups, tss = result_tss)

    return(result)


}


#' Implements a basic k-means algorithm.
#'
#' @param dat A data frame
#' @param start_points A data frame
#'
#' @return A data frame containing the distances of each point in dat to the initial points
#'
#' @import tidyverse
#'
#' @export
#'

get_distances <- function(x, y, start_x, start_y) {

    for (i in 1:nrow(start_x)) {

        sx <- as.numeric(start_x[i, 1])
        sy <- as.numeric(start_y[i, 1])

        dist_i <- sqrt((x - sx)^2 + (y - sy)^2)

        if (i == 1) {

            dist <- dist_i

        } else {

            dist <- cbind(dist, dist_i)
        }

    }

    for (i in 1:nrow(start_x)) {

        col_name <- glue::glue("Group", i)

        if (i == 1) {

            col_names <- col_name

        } else {

            col_names <- cbind(col_names, col_name)
        }

    }

    colnames(dist) <- col_names


    return(dist)

}


