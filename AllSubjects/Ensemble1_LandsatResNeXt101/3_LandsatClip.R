library(rgdal)
library(raster)
library(rgeos)
library(sp)
library(foreach)
library(doParallel)
library(doMC)
registerDoMC(detectCores()-1)

clip_rasters <- function(rast, shapefile, destination) {

      a <- 0
      
      foreach(school = 1:nrow(shapefile)) %dopar% {
				      
            selected <- shapefile[school,]
            extract <- raster::crop(rast, selected)
            file_name <- paste(destination, selected$school_id, '.tif', sep = '')
#            print(paste(dim(shapefile)[1], " files: ", file_name, sep = ''))
					
            raster::writeRaster(extract, filename = file_name)

            a <- a + 1
				
					print(a)

      }

}
  

# Read in the school squares shapefile
sb <- readOGR('./clean/AllSubjects/Ensemble1_LandsatResNeXt/data/shp/y1314_AllSubjects_sb.shp')
sb <- sp::spTransform(sb, "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
class(sb)

r <- raster::brick("./clean/AllSubjects/Ensemble1_LandsatResNeXt/data/mosaic_proj.tif")


#plotRGB(r,
#				r = 3, g = 2, b = 1,
#				stretch = "lin",
#				axes = FALSE, frame = FALSE)
#plot(sb, add = TRUE)


colnames(sb@data) <- c("school_id", "overall_mean", "intervention", "latitude", "longitude")

clip_rasters(r, sb, './clean/AllSubjects/Ensemble1_LandsatResNeXt/data/imagery/')

length(list.files("./clean/AllSubjects/Ensemble1_LandsatResNeXt/data/pass/"))
length(list.files("./clean/AllSubjects/Ensemble1_LandsatResNeXt/data/fail/"))