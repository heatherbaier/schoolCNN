library(raster)

create_brick <- function(folder) {
        lbands <- list.files(folder,
                             pattern = glob2rx("*_B*.TIF$"),
                             full.names = TRUE)
        lbands <- grep("_B[2-4].TIF", lbands, value = TRUE)
        print(lbands)
        landsat_stack_csf <- raster::stack(lbands) # Stack the data
        print("Bricking Rasters")
        landsat_csf_br <- raster::brick(landsat_stack_csf) # Turn the raster stack into a brick
				return(landsat_csf_br)
}


p115r049 <- create_brick("./raw_data/y13-14_landsat/LC08_L1TP_115049_20140320_20170425_01_T1/")
p115r050 <- create_brick("./raw_data/y13-14_landsat/LC08_L1TP_115050_20140405_20180204_01_T1/")
p115r051 <- create_brick("./raw_data/y13-14_landsat/LO08_L1TP_115051_20140304_20170425_01_T1/")
p116r049 <- create_brick("./raw_data/y13-14_landsat/LC08_L1TP_116049_20140207_20170426_01_T1/")
p116r050 <- create_brick("./raw_data/y13-14_landsat/LC08_L1TP_116050_20140207_20170426_01_T1/")
p117r049 <- create_brick("./raw_data/y13-14_landsat/LC08_L1TP_117049_20140129_20170426_01_T1/")

p117r049 <- raster::projectRaster(from = p117r049, crs = "+proj=utm +zone=51 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0") # Project the brick



params <- list(p115r049, p115r050, p115r051, p116r049, p116r050, p117r049)
params$fun <- max
params$na.rm <- TRUE
params$tolerance <- 1

mos <- do.call(mosaic, params)

plotRGB(mos,
				r = 3, g = 2, b = 1,
				stretch = "lin",
				axes = FALSE, frame = FALSE)


raster::writeRaster(mos, "./landsat_cnn_resnet152_y1314/mosaic_unproj.tif")

mos <- raster::brick("./landsat_cnn_resnet152_y1314/mosaic_unproj.tif")

mosaic_proj <- raster::projectRaster(from = mos, crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

raster::writeRaster(mosaic_proj, "./landsat_cnn_resnet152_y1314/mosaic_proj.tif")


