library(raster)
library(rgdal)
library(foreach)
library(doParallel)
library(doMC)
registerDoMC(detectCores()-1)


files <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/imagery/", full.names = TRUE)	
length(files)

y1314 <- read.csv("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/y1314_English.csv")

table(y1314$intervention)

for (i in 1:12588) {
  
  id <- base::substr(files[i], 65, 70)
  school <- subset(y1314, school_id == as.numeric(id))
  int <- school$intervention
  
#  print(id)
#  print(school)
  
  if (int == 0) {
      file.copy(files[i], "./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/pass/")
  } else if (int == 1) {
      file.copy(files[i], "./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/fail/")
  }
  
}


pass_files <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/pass/", full.names = TRUE)
fail_files <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/fail/", full.names = TRUE)

length(pass_files)
length(fail_files)
