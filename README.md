
<!-- README.md is generated from README.Rmd. Please edit that file -->

# raadvrt

<!-- badges: start -->

<!-- badges: end -->

VERY MUCH WIP

Don’t use the example code here it’s very likely to crash your session.

The goal of raadvrt is to collect VRT versions of raadtools data
sources.

WHY

  - can GDALwarp a VRT (so we can get any layer we want in any
    projection/grid on-demand)
  - VRT can be used by other systems (QGIS, Manifold, raster, terra,
    stars)

In theory we could parameterize the VRT creation, but that’s lofty and
this gets us heaps of leverage over raadtools itself

## GDALwarp

I mean with the GDAL API, via the
[vapour](https://CRAN.r-project.org/package=vapour) package, not bound
by any other GDAL wrapper or in-memory format. But, these will work
through other GDAL wrappers as well.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("AustralianAntarcticDivision/raadvrt")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(raadvrt)
## basic example code
```

## Code of Conduct

Please note that the raadvrt project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
