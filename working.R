library(raster)

prj <- "+proj=laea"
r0 <- projectExtent(raster::raster(raster::extent(-180, 180, -90, 90), crs = "+proj=longlat", res = 0.2), prj)


#e <- new("Extent", xmin = -729574.370995987, xmax = 1006027.80116313,
#         ymin = -812611.063431228, ymax = 765209.093077062)
#r0 <- raster(e, res = 30000, crs = prj)

files <- raadtools::icefiles(hemisphere = "south")
#files <- raadtools::sstfiles()


gt <- affinity::extent_dim_to_gt(raster::extent(r0), dim(r0)[2:1])
wkt <- sf::st_crs(projection(r0))$wkt


tfile <- tempfile(fileext = ".vrt")
#file <- sample(files$fullname, 1)
file <- files$fullname[1]
writeLines(sprintf(readLines("~/vrt0/nsidc_south.vrt"), file), tfile)
tf <- c(tf, tfile)


r <- raster::setValues(r0, vapour:::vapour_warp_raster(tf[2:1], geotransform = gt, dimension = dim(r0)[2:1], wkt = wkt)[[1]]/2.5)

nobig <- function(x) x[x < 101]
brks <- sort(unique(quantile(nobig(values(r)), seq(0, 1, length.out = 24))))
plot(r, col = grey.colors(length(brks) - 1), breaks = brks)


