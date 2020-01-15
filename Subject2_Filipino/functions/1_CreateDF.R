CreateDF <- function(raw_csv, subject, coords_df) {
	
	df <- read.csv(raw_csv)
	head(df)
	
	if (subject == "english") {
		df <- df[c("school_id","english_mean_rs")]
	} else if (subject == "filipino") {
		df <- df[c("school_id","filipino_mean_rs")]
	} else if (subject == "math") {
		df <- df[c("school_id","math_mean_rs")]
	} else if (subject == "science") {
		df <- df[c("school_id","science_mean_rs")]
	}
	
	colnames(df) <- c("school_id", "mean")
	
	kmeans <- classIntervals(df$mean, 2, style = "kmeans")
	
	df$intervention <- NA
	df$intervention[df$mean < kmeans$brks[2]] <- 1
	df$intervention[df$mean >= kmeans$brks[2]] <- 0
	
	coords <- read.csv(coords_df)
	df <- base::merge(df, coords, by = 'school_id')
	df <- df[!duplicated(df$school_id), ]
	df <- df[(df$latitude != 0 & df$longitude != 0),]
	df$latitude <- as.numeric(as.character(df$latitude))
	df <- df[df$latitude > 12,]
	df <- df[df$school_id != 100011,]
	df <- df[df$school_id != 123048,]
	
	
	colnames(df) <- c("school_id", "mean", "intervention", "drop", "latitude", "longitude")

	# Rename columns and subset final dataframe
	cols <- c("school_id", "mean", "intervention", "latitude", "longitude")
	df <- df[cols]
	
	return(df)
	
}







