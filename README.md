
<!-- README.md is generated from README.Rmd. Please edit that file -->

# raadvrt

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

|                                                                         |
| :---------------------------------------------------------------------- |
| VERY MUCH WIP                                                           |
| Don’t use the example code here it’s very likely to crash your session. |

The goal of raadvrt is to collect VRT versions of raadtools data
sources.

WHY

  - can GDALwarp a VRT (so we can get any layer we want in any
    projection/grid on-demand)
  - VRT can be used by other systems (QGIS, Manifold, raster, terra,
    stars)

This gets us heaps of leverage over raadtools itself, because currently
raadtools augments data in R code only. It does this by

  - reading raw binary and converting to in-memory raster, applying
    extent and SRS
  - using raster to read netcdf (which uses ncdf4)
  - applying known geotransforms and/or crs when needed (using
    `raster::crs()`, `raster::extent()`)
  - using `raster::flip()` where needed
  - using `raster::rotate()` where needed, this is much more efficient
    via VRT depending on the ultimate target
  - multipler proper raster files as tiles in one larger one
    (e.g. GEOID)
  - other weird cases …

In theory we could parameterize the VRT creation, but that’s more lofty
and no one else cares it seems.

These fixes are R-only, not communicable to users of other systems,
can’t be streamed through GDAL itself, or through other R GDAL
wrappers. We won’t give up on our raadtools ways (they are still better
some of the time), but we get to choose when streaming through GDALwarp
is the better approach.

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

## Working cases

NSIDC

These are binary sources with the byte offset and orientation specified,
along with the output dimensions, geotransform and SRS for both north
and south hemispheres.

CERSAT

Use of a warped source to flip the geotransform from positive y read
from the bottom. The files need the projected transform applied, and the
SRS because it’s not recorded (only there are longlat arrays), but also
to warp with the y-negation to flip.

AMSRE

This is very similar to the CERSAT case, but the source has no longlat
arrays to fool tools with, it’s purely in index space (so needs
flipping, applying extent and SRS the same).

OISST

There’s oisst\_pacific.vrt and oisst\_atlantic.vrt, the former merely
has the SRS added and the latter has two window sources, to flip from
Pacific view (0,360 longitude) to Atlantic view (-180, 180). (There’s no
flip needed so there’s no warp with transform negation. )

GEOID

This is currently a funny case as it’s composed of multiple source
files, so to fit the sprintf templating here we need that parameterized
out.

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
