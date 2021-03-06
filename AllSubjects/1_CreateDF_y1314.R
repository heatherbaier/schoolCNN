library(classInt)
library(leaflet)
#library(sf)
library(rgdal)
library(sp)

# Read in Grade 6 and 10 data
df6 <- read.csv("./clean/AllSubjects/Ensemble2_StaticResNeXt101/data/y13-14_g6.csv")

# Calculate the overall mean of NAT scores per school
df6$mean <- df6$overall_mean_rs / 5

kmeans_overall <- classIntervals(df6$mean, 2, style = "kmeans")

hist(df6$mean)

range(df6$mean)

# Subset columns
final_df6 <- df6[c("school_id","overall_mean_rs")]

# Calculate kMeans break with 2 classes
kmeans_df6 <- classIntervals(final_df6$overall_mean_rs, 2, style = "kmeans")

# Assign interventon booleans based on above kmeans break 
final_df6$intervention <- NA
final_df6$intervention[final_df6$overall_mean_rs < kmeans_df6$brks[2]] <- 1
final_df6$intervention[final_df6$overall_mean_rs >= kmeans_df6$brks[2]] <- 0

table(final_df6$intervention)

# Read in coordinates data frame, drop duplicates and coordinates outliers  
coords <- read.csv("./clean/AllSubjects/Ensemble2_StaticResNeXt101/data/coords.csv")
final_df <- base::merge(final_df6, coords, by = 'school_id')
final_df <- final_df[!duplicated(final_df$school_id), ]
final_df <- final_df[(final_df$latitude != 0 & final_df$longitude != 0),]
final_df$latitude <- as.numeric(as.character(final_df$latitude))
final_df <- final_df[final_df$latitude > 12,]
final_df <- final_df[final_df$school_id != 100011,]
final_df <- final_df[final_df$school_id != 123048,]

table(final_df$intervention)

colnames(final_df) <- c("school_id", "overall_mean", "intervention", "drop", "latitude", "longitude")

# Rename columns and subset final dataframe
cols <- c("school_id", "overall_mean", "intervention", "latitude", "longitude")
final_df <- final_df[cols]

head(final_df)

# Write final CSV
write.csv(final_df, "./clean/AllSubjects/Ensemble1_LandsatResNeXt101/data/y1314_AllSubjects.csv", row.names=FALSE)
write.csv(final_df, "./clean/AllSubjects/Ensemble2_StaticResNeXt101/data/y1314_AllSubjects.csv", row.names=FALSE)
write.csv(final_df, "./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/y1314_AllSubjects.csv", row.names=FALSE)

# Create shapefile
coords <- cbind(final_df$longitude, final_df$latitude)
sp <- SpatialPoints(coords)
spdf <- SpatialPointsDataFrame(coords, final_df, proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# Write shapefile
writeOGR(spdf, dsn = "./clean/AllSubjects/Ensemble1_LandsatResNeXt101/data/shp/y1314_AllSubjects_sp.shp", layer = "y1314_AllSubjects_sp", driver = "ESRI Shapefile", overwrite_layer = TRUE)



