#' Implements a basic k-means algorithm.
#'
#' @param dat A data frame
#'
#' @return something (TBD) to be returned with
#'
#' @import dplyr
#' @import tidyverse
#'
#' @export

k_means <- function(data, k, pca = FALSE){
    if (pca = TRUE) {
        #If pca is set to true, then PCA will be performed on 1st 2 dimensions
        data_pca <- data %>%
            princomp()

        data_pca_scores <- data_pca$scores %>%
            as_tibble() %>%
            select(Comp.1, Comp.2)
    }

    set.seed(37)




}

---
    title: "Check in Week 7"
author: "Roee Morag"
date: "2023-05-23"
output: html_document
---

    ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
library(tidyverse)
library(dplyr)
library(ggdendro)
library("ape")
```


```{r}
fed <- read_csv(here::here("federalist.txt"))

head(fed)

fed <- select(fed, -`...1`)
```

```{r}
fed_pca <-
    fed %>%
    select(-Author) %>%
    princomp()

tibble(
    pcs = 1:70,
    variance = fed_pca$sdev^2
) %>%
    ggplot(aes(x = pcs, y = variance)) +
    geom_col()

fed_pc_scores <-
    fed_pca$scores %>%
    as_tibble() %>%
    select(Comp.1, Comp.2) %>%
    mutate(
        Author = fed$Author
    )



```

```{r}

my_kmeans <-
    fed_pc_scores %>%
    select(Comp.1, Comp.2) %>%
    kmeans(centers = 3)
```

```{r}

fed_pc_scores <- fed_pc_scores %>%
    mutate(Cluster = my_kmeans$cluster)

ggplot(fed_pc_scores, aes(x = Comp.1, y = Comp.2, color = Author, label = factor(Cluster))) +
    geom_point() +
    geom_text(hjust = 0, vjust = 0) +
    labs(color = "Author") +
    theme_minimal()


```


```{r}
my_kmeans_iris <-
    iris %>%
    select(Petal.Length, Petal.Width) %>%
    kmeans(centers = 3)

test_k <-
    tibble(
        `Number of Clusters` = 2:6,
        SS = map_dbl(2:6, ~kmeans(iris[, 3:4], centers = .x)$tot.withinss)
    )

test_k %>%
    ggplot() +
    aes(x = `Number of Clusters`, y = SS) +
    geom_point() +
    geom_line() +
    ylab("")



```


```{r}

fed_matrix <- as.matrix(fed)

fed_dist <- dist(fed_matrix)

h_clust <- hclust(fed_dist)



op = par(bg = "#DDE3CA")
plot(h_clust, labels = fed$Author, cex = 0.5, las = 1, xlab = "")
axis(side = 2, at = seq(0, 400, 100), col = "#F38630",
     labels = FALSE, lwd = 2)



```
