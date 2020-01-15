library(classInt)
library(leaflet)
library(rgdal)
library(sp)


# 1. Create DataFrame
dta <- CreateDF("./clean/Subject2_Filipino/y13-14_g6.csv", 
								"filipino",
							  "./clean/AllSubjects/Ensemble2_StaticResNeXt101/data/coords.csv")

# Write final CSV
write.csv(final_df, "./clean/Subject2_Filipino/Ensemble1_English_LandsatResNeXt101/data/y1314_English.csv", row.names=FALSE)
write.csv(final_df, "./clean/Subject2_Filipino/Ensemble2_English_StaticResNeXt101/data/y1314_English.csv", row.names=FALSE)
write.csv(final_df, "./clean/Subject2_Filipino/Ensemble3_English_StreetViewResNeXt101/data/y1314_English.csv", row.names=FALSE)

# Create shapefile
coords <- cbind(final_df$longitude, final_df$latitude)
sp <- SpatialPoints(coords)
spdf <- SpatialPointsDataFrame(coords, final_df, proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# Write shapefile
writeOGR(spdf, dsn = "./clean/Subject2_Filipino/Ensemble1_English_LandsatResNeXt101/data/shp/y1314_English_sp.shp", layer = "y1314_English_sp", driver = "ESRI Shapefile", overwrite_layer = TRUE)


length(list.files("./clean/Subject2_Filipino/Ensemble1_English_LandsatResNeXt101/data/pass/"))
length(list.files("./clean/Subject2_Filipino/Ensemble1_English_LandsatResNeXt101/data/fail/"))
