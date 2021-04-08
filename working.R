library(raster)
# short analysed_sst(time, lat, lon) ;
# analysed_sst:long_name = "analysed sea surface temperature" ;
# analysed_sst:standard_name = "sea_surface_foundation_temperature" ;
# analysed_sst:units = "kelvin" ;
# analysed_sst:_FillValue = -32768s ;
# analysed_sst:add_offset = 298.15 ;
# analysed_sst:scale_factor = 0.001 ;
# analysed_sst:valid_min = -32767s ;
# analysed_sst:valid_max = 32767s ;
# analysed_sst:comment = "\"Final\" version using Multi-Resolution Variational Analysis (MRVA) method for interpolation" ;
# analysed_sst:coordinates = "lon lat" ;
# analysed_sst:source = "AMSRE-REMSS, AVHRR_Pathfinder-PFV5.2-NODC_day, AVHRR_Pathfinder-PFV5.2-NODC_night, MODIS_T-JPL, iQUAM-NOAA/NESDIS, Ice_Conc-OSISAF" ;
# analysed_sst:_Storage = "chunked" ;
# analysed_sst:_ChunkSizes = 1, 1023, 2047 ;
# analysed_sst:_DeflateLevel = 7 ;
# analysed_sst:_Shuffle = "true" ;
# analysed_sst:_Endianness = "little" ;
#


#
# short sst(time, zlev, lat, lon) ;
# sst:long_name = "Daily sea surface temperature" ;
# sst:units = "Celsius" ;
# sst:_FillValue = -999s ;
# sst:add_offset = 0.f ;
# sst:scale_factor = 0.01f ;
# sst:valid_min = -300s ;
# sst:valid_max = 4500s ;
# sst:_Storage = "chunked" ;
# sst:_ChunkSizes = 1, 1, 720, 1440 ;
# sst:_DeflateLevel = 4 ;
# sst:_Shuffle = "true" ;
# sst:_Endianness = "little" ;

sds <- 'NETCDF:"/rdsi/PUBLIC/raad/data/podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/2002/152/20020601090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc":analysed_sst'
prj <- "+proj=laea +lat_0=-42 +lon_0=147"
r0 <- projectExtent(raster::raster(raster::extent(-130, 150, -55, -30), crs = "+proj=longlat", res = 2), prj)


#e <- new("Extent", xmin = -729574.370995987, xmax = 1006027.80116313,
#         ymin = -812611.063431228, ymax = 765209.093077062)
#r0 <- raster(e, res = 30000, crs = prj)
#files <- raadtools::icefiles(hemisphere = "south")
#files <- raadtools::sstfiles()


gt <- affinity::extent_dim_to_gt(raster::extent(r0), dim(r0)[2:1])
wkt <- sf::st_crs(projection(r0))$wkt


tfile <- tempfile(fileext = ".vrt")
#file <- sample(files$fullname, 1)
file <- sds #files$fullname[1]
writeLines(sprintf(readLines("inst/vrt0/ghrsst.vrt"), file), tfile)
tf <- tfile

r <- raster::setValues(r0, vapour:::vapour_warp_raster(tf, geotransform = gt, dimension = dim(r0)[2:1], wkt = wkt)[[1]]/2.5)

nobig <- function(x) x[x < 101]
brks <- sort(unique(quantile(nobig(values(r)), seq(0, 1, length.out = 24))))
plot(r, col = grey.colors(length(brks) - 1), breaks = brks)


