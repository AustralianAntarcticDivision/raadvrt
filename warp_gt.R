inv_gt <- function(x) {
  out <- x
  out[1] = -x[1] / x[2];
  out[2] = 1.0 / x[2];
  out[3] = 0.0;
  out[4] = -x[4] / x[6];
  out[5] = 0.0;
  out[6] = 1.0 / x[6];
  out
}
commas <- function(x) {
  paste(x, collapse = ", ")
}
wkt <- 'PROJCS["WGS 84 / Antarctic Polar Stereographic",GEOGCS["WGS 84",DATUM["WGS_1984",SPHEROID["WGS 84",6378137,298.257223563,AUTHORITY["EPSG","7030"]],AUTHORITY["EPSG","6326"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4326"]],PROJECTION["Polar_Stereographic"],PARAMETER["latitude_of_origin",-71],PARAMETER["central_meridian",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["metre",1,AUTHORITY["EPSG","9001"]],AXIS["Easting",NORTH],AXIS["Northing",NORTH],AUTHORITY["EPSG","3031"]]'
vrt_srs <-   sprintf('<SRS dataAxisToSRSAxisMapping="1,2">%s</SRS>', wkt)
## this is the right geotransform, after flipping
gt <- c(-3950000,12500,0,4350000,0,-12500)
flip_gt <- function(x, direction = c("x", "y"), offset = 0) {
  direction <- match.arg(direction)
  idx <- switch(direction, x = 2, y = 6)
  x[idx] <- -x[idx]
  
  idx2 <- switch(direction, x = 1, y = 4)
  x[idx2] <- offset
  x
}
vrt_gt <- sprintf('<GeoTransform> %s</GeoTransform>', commas(gt))
vrt_src_gt <- sprintf('<SrcGeoTransform> %s</SrcGeoTransform>', commas(flip_gt(gt, "y", -3950000)))
vrt_src_inv_gt <- sprintf('<SrcInvGeoTransform> %s</SrcInvGeoTransform>', commas(inv_gt(flip_gt(gt, "y", -3950000))))

vrt_dst_gt <- sprintf('<DstGeoTransform> %s</DstGeoTransform>', commas(gt))
vrt_dst_inv_gt <- sprintf('<DstInvGeoTransform> %s</DstInvGeoTransform>', commas(inv_gt(gt)))

SDS_datasource <- 'NETCDF:"/rdsi/PUBLIC/raad/data/ftp.ifremer.fr/ifremer/cersat/products/gridded/psi-concentration/data/antarctic/daily/netcdf/2021/20210317.nc":concentration'

vrt <- sprintf('
<VRTDataset rasterXSize="632" rasterYSize="664" subClass="VRTWarpedDataset">
  %s
  %s
  <VRTRasterBand dataType="Byte" band="1" subClass="VRTWarpedRasterBand">
    <NoDataValue>-128</NoDataValue>
    <UnitType>percent</UnitType>
  </VRTRasterBand>
  <BlockXSize>512</BlockXSize>
  <BlockYSize>128</BlockYSize>
  <GDALWarpOptions>
    <WarpMemoryLimit>6.71089e+07</WarpMemoryLimit>
    <ResampleAlg>NearestNeighbour</ResampleAlg>
    <WorkingDataType>Float32</WorkingDataType>
    <Option name="INIT_DEST">NO_DATA</Option>
    <Option name="ERROR_OUT_IF_EMPTY_SOURCE_WINDOW">FALSE</Option>
    <SourceDataset relativeToVRT="0">%s</SourceDataset>
    <Transformer>
      <ApproxTransformer>
        <MaxError>0.125</MaxError>
        <BaseTransformer>
          <GenImgProjTransformer>
            %s
            %s
            %s
            %s
          </GenImgProjTransformer>
        </BaseTransformer>
      </ApproxTransformer>
    </Transformer>
    <BandList>
      <BandMapping src="1" dst="1">
        <SrcNoDataReal>-128</SrcNoDataReal>
        <SrcNoDataImag>0</SrcNoDataImag>
        <DstNoDataReal>-128</DstNoDataReal>
        <DstNoDataImag>0</DstNoDataImag>
      </BandMapping>
    </BandList>
  </GDALWarpOptions>
</VRTDataset>
', vrt_srs, vrt_gt,
               SDS_datasource,
        vrt_src_gt, vrt_src_inv_gt,  
        vrt_dst_gt, vrt_dst_inv_gt)




ct <- function(vrt) {
  writeLines(vrt, tfile <- tempfile(fileext = ".vrt"))
  tfile
}


library(raster)
plot(raster::raster(ct(vrt)))
