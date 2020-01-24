library(raster)
library(rgdal)
library(foreach)
library(doParallel)
library(doMC)
registerDoMC(detectCores()-1)


files <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/imagery/", full.names = TRUE)	
length(files)

y1314 <- read.csv("./clean/Subject3_Math/E1_Math_Landsat/data/y1314_Math.csv")

table(y1314$intervention)

for (i in 1:12588) {
  
  id <- base::substr(files[i], 65, 70)
  school <- subset(y1314, school_id == as.numeric(id))
  int <- school$intervention
  
#  print(id)
#  print(school)
  
  if (int == 0) {
      file.copy(files[i], "./clean/Subject3_Math/E3_Math_StreetView/data/pass/")
  } else if (int == 1) {
      file.copy(files[i], "./clean/Subject3_Math/E3_Math_StreetView/data/fail/")
  }
  
}


pass_files <- list.files("./clean/Subject3_Math/E3_Math_StreetView/data/pass/", full.names = TRUE)
fail_files <- list.files("./clean/Subject3_Math/E3_Math_StreetView/data/fail/", full.names = TRUE)

length(pass_files)
length(fail_files)
