library(classInt)
library(leaflet)
#library(sf)
library(rgdal)
library(sp)

# Read in Grade 6 and 10 data
df10 <- read.csv("./Subject1_English/data/y13-14_g10.csv")
df6 <- read.csv("./Subject1_English/data/y13-14_g6.csv")

## Calculate the overall mean of NAT scores per school
#df10$mean <- df10$overall_mean_rs / 6
#df6$mean <- df6$overall_mean_rs / 5

hist(df10$filipino_mean_rs)
hist(df6$filipino_mean_rs)

range(df10$filipino_mean_rs)
range(df6$filipino_mean_rs)

# Subset columns
final_df10 <- df10[c("school_id","english_mean_rs")]
final_df6 <- df6[c("school_id","english_mean_rs")]

# Calculate kMeans break with 2 classes
kmeans_df10 <- classIntervals(final_df10$english_mean_rs, 2, style = "kmeans")
kmeans_df6 <- classIntervals(final_df6$english_mean_rs, 2, style = "kmeans")

# Assign interventon booleans based on above kmeans break 
final_df10$intervention <- NA
final_df10$intervention[final_df10$english_mean_rs < kmeans_df10$brks[2]] <- 1
final_df10$intervention[final_df10$english_mean_rs >= kmeans_df10$brks[2]] <- 0

final_df6$intervention <- NA
final_df6$intervention[final_df6$english_mean_rs < kmeans_df6$brks[2]] <- 1
final_df6$intervention[final_df6$english_mean_rs >= kmeans_df6$brks[2]] <- 0

# Combine data frames into one and drop duplicates
final_df <- rbind(final_df10, final_df6)
final_df <- final_df[!duplicated(final_df$school_id), ]


table(final_df$intervention)


# Read in coordinates data frame, drop duplicates and coordinates outliers  
coords <- read.csv("./Subject1_English/data/coords.csv")
final_df <- base::merge(final_df, coords, by = 'school_id')
final_df <- final_df[!duplicated(final_df$school_id), ]
final_df <- final_df[(final_df$latitude != 0 & final_df$longitude != 0),]
final_df$latitude <- as.numeric(as.character(final_df$latitude))
final_df <- final_df[final_df$latitude > 12,]
final_df <- final_df[final_df$school_id != 100011,]
final_df <- final_df[final_df$school_id != 123048,]

table(final_df$intervention)

colnames(final_df) <- c("school_id", "english_mean", "intervention", "drop", "latitude", "longitude")

# Rename columns and subset final dataframe
cols <- c("school_id", "english_mean", "intervention", "latitude", "longitude")
final_df <- final_df[cols]

# Write final CSV
write.csv(final_df, "./Subject1_English/data/y1314_English.csv", row.names=FALSE)

# Create shapefile
coords <- cbind(final_df$longitude, final_df$latitude)
sp <- SpatialPoints(coords)
spdf <- SpatialPointsDataFrame(coords, final_df, proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# Write shapefile
writeOGR(spdf, dsn = "./Subject1_English/data/shp/y1314_English_sp.shp", layer = "y1314_English_sp", driver = "ESRI Shapefile", overwrite_layer = TRUE)
