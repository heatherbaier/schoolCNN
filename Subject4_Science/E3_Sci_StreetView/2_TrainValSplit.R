library(doMC)
registerDoMC(detectCores()-1)

pass_files <- list.files("./clean/Subject4_Science/E3_Sci_StreetView/data/pass/", full.names = TRUE)
fail_files <- list.files("./clean/Subject4_Science/E3_Sci_StreetView/data/fail/", full.names = TRUE)

length(pass_files)
length(fail_files)

pass_train_sample <- sample(pass_files, 6000)
pass_val_sample <- setdiff(pass_files, pass_train_sample)

length(pass_train_sample)
length(pass_val_sample)

fail_train_sample <- sample(fail_files, 3441)
fail_val_sample <- setdiff(fail_files, fail_train_sample)

length(fail_train_sample)
length(fail_val_sample)


foreach(i = 1:6000) %dopar% {
  file.copy(pass_train_sample[i], "./clean/Subject4_Science/E3_Sci_StreetView/data/train/pass/")
}


foreach(i = 1:2000) %dopar% {
  file.copy(pass_val_sample[i], "./clean/Subject4_Science/E3_Sci_StreetView/data/val/pass/")
}


foreach(i = 1:3441) %dopar% {
  file.copy(fail_train_sample[i], "./clean/Subject4_Science/E3_Sci_StreetView/data/train/fail/")
}


foreach(i = 1:1147) %dopar% {
  file.copy(fail_val_sample[i], "./clean/Subject4_Science/E3_Sci_StreetView/data/val/fail/")
}


train_pass <- list.files("./clean/Subject4_Science/E3_Sci_StreetView/data/train/pass")
val_pass <- list.files("./clean/Subject4_Science/E3_Sci_StreetView/data/val/pass/")
train_fail <- list.files("./clean/Subject4_Science/E3_Sci_StreetView/data/train/fail/")
val_fail <- list.files("./clean/Subject4_Science/E3_Sci_StreetView/data/val/fail/")

length(train_pass)
length(val_pass)
length(train_fail)
length(val_fail)



