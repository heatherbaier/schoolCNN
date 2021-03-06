library(doMC)
registerDoMC(detectCores()-1)

pass_files <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/pass/", full.names = TRUE)
fail_files <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/fail/", full.names = TRUE)

length(pass_files)
length(fail_files)

pass_train_sample <- sample(pass_files, 6165)
pass_val_sample <- setdiff(pass_files, pass_train_sample)

length(pass_train_sample)
length(pass_val_sample)

fail_train_sample <- sample(fail_files, 3276)
fail_val_sample <- setdiff(fail_files, fail_train_sample)

length(fail_train_sample)
length(fail_val_sample)


foreach(i = 1:6165) %dopar% {
  file.copy(pass_train_sample[i], "./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/train/pass/")
}


foreach(i = 1:2055) %dopar% {
  file.copy(pass_val_sample[i], "./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/val/pass/")
}


foreach(i = 1:3276) %dopar% {
  file.copy(fail_train_sample[i], "./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/train/fail/")
}


foreach(i = 1:1092) %dopar% {
  file.copy(fail_val_sample[i], "./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/val/fail/")
}


train_pass <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/train/pass")
val_pass <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/val/pass/")
train_fail <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/train/fail/")
val_fail <- list.files("./clean/AllSubjects/Ensemble3_StreetViewResNet152/data/val/fail/")

length(train_pass)
length(val_pass)
length(train_fail)
length(val_fail)



