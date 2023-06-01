
<!-- README.md is generated from README.Rmd. Please edit that file -->

# clust431

<!-- badges: start -->
<!-- badges: end -->

The goal of clust431 is to provide two main functions: k_means(), which
performs clustering on a given dataset using a basic k means algorithm
hclust(), which …

## Installation

You can install the released version of clust431 from GitHub with:

``` r

install_github("josh-rowe/lab-7-clustering-methods-josh-rowe")
```

## Functions

### k_means()

#### Inputs

*dat* a dataframe where the first two columns are x and y coordinates

*k* a number describing the number of clusters to search for

*pca* a boolean which allows the user to have k_means() perform pca on
the data before running the k means algorithm (defaults to FALSE)

*max_iter* a number describing the maximum number of iterations for
k_means() to run through if convergence is not met (defaults to 100)

#### Outputs

A list with two elements:

*groups* a dataframe with the x and y values of the original data and a
factor which contains the grouping assignment of each observation

*tss* the total sum of squares of the final grouping assignment

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(clust431)

dat <- data.frame(x = c(1, 2, 3, 10, 11, 12, 20, 21, 22),
                  y = c(1, 2, 3, 10, 11, 12, 20, 21, 22))

dat_groups <- k_means(dat = dat, k = 3)
```

### hier_clust()

#### Inputs

*data* a numeric data frame

*cluster* a number describing the number of clusters to search for

#### Outputs

A data frame with two columns and a number of rows corresponding to the
inputted data frame:

*index* index row number corresponding to the inputted data set

*clusters* cluster assignment for index

## hier_clust() Example

This is a basic example which shows you how to solve a common problem:

``` r
library(clust431)

data <- iris %>% dplyr::select(-Species)
cluster <- 3

hierarchical <- hier_clust(data, cluster)
tail(hierarchical)
#>     index clusters
#> 145   145        3
#> 146   146        3
#> 147   147        3
#> 148   148        3
#> 149   149        3
#> 150   150        2
table(hierarchical$clusters)
#> 
#>  1  2  3 
#> 50 51 49
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub!
