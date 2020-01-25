library(raster)
library(rgdal)
library(foreach)
library(doParallel)
library(doMC)
registerDoMC(detectCores()-1)


files <- list.files("./clean/AllSubjects/Ensemble2_StaticResNeXt101/data/imagery/", full.names = TRUE)	
length(files)

y1314 <- read.csv("./clean/Subject5_AP/E2_AP_Static/data/y1314_AP.csv")

table(y1314$intervention)

for (i in 1:5875) {
  
  id <- base::substr(files[i], 62, 67)
  school <- subset(y1314, school_id == as.numeric(id))
  int <- school$intervention
  
#  print(id)
#  print(school)
  
  if (int == 0) {
      file.copy(files[i], "./clean/Subject5_AP/E2_AP_Static/data/pass/")
  } else if (int == 1) {
      file.copy(files[i], "./clean/Subject5_AP/E2_AP_Static/data/fail/")
  }
  
}


pass_files <- list.files("./clean/Subject5_AP/E2_AP_Static/data/pass/", full.names = TRUE)
fail_files <- list.files("./clean/Subject5_AP/E2_AP_Static/data/fail/", full.names = TRUE)

length(pass_files)
length(fail_files)
