library(doMC)
registerDoMC(detectCores()-1)

pass_files <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/pass/", full.names = TRUE)
fail_files <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/fail/", full.names = TRUE)

length(pass_files)
length(fail_files)

pass_train_sample <- sample(pass_files, 6108)
pass_val_sample <- setdiff(pass_files, pass_train_sample)

length(pass_train_sample)
length(pass_val_sample)

fail_train_sample <- sample(fail_files, 3333)
fail_val_sample <- setdiff(fail_files, fail_train_sample)

length(fail_train_sample)
length(fail_val_sample)


foreach(i = 1:6108) %dopar% {
  file.copy(pass_train_sample[i], "./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/train/pass/")
}


foreach(i = 1:2036) %dopar% {
  file.copy(pass_val_sample[i], "./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/val/pass/")
}


foreach(i = 1:3333) %dopar% {
  file.copy(fail_train_sample[i], "./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/train/fail/")
}


foreach(i = 1:1111) %dopar% {
  file.copy(fail_val_sample[i], "./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/val/fail/")
}


train_pass <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/train/pass")
val_pass <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/val/pass/")
train_fail <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/train/fail/")
val_fail <- list.files("./clean/Subject1_English/Ensemble3_English_StreetViewResNeXt101/data/val/fail/")

length(train_pass)
length(val_pass)
length(train_fail)
length(val_fail)



