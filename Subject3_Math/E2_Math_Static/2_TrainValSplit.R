library(doMC)
registerDoMC(detectCores()-1)

pass_files <- list.files("./clean/Subject3_Math/E2_Math_Static/data/pass/", full.names = TRUE)
fail_files <- list.files("./clean/Subject3_Math/E2_Math_Static/data/fail/", full.names = TRUE)

length(pass_files)
length(fail_files)

pass_train_sample <- sample(pass_files, 2880)
pass_val_sample <- setdiff(pass_files, pass_train_sample)

length(pass_train_sample)
length(pass_val_sample)

fail_train_sample <- sample(fail_files, 1525)
fail_val_sample <- setdiff(fail_files, fail_train_sample)

length(fail_train_sample)
length(fail_val_sample)


foreach(i = 1:2880) %dopar% {
  file.copy(pass_train_sample[i], "./clean/Subject3_Math/E2_Math_Static/data/train/pass/")
}


foreach(i = 1:961) %dopar% {
  file.copy(pass_val_sample[i], "./clean/Subject3_Math/E2_Math_Static/data/val/pass/")
}


foreach(i = 1:1525) %dopar% {
  file.copy(fail_train_sample[i], "./clean/Subject3_Math/E2_Math_Static/data/train/fail/")
}


foreach(i = 1:509) %dopar% {
  file.copy(fail_val_sample[i], "./clean/Subject3_Math/E2_Math_Static/data/val/fail/")
}


train_pass <- list.files("./clean/Subject3_Math/E2_Math_Static/data/train/pass")
val_pass <- list.files("./clean/Subject3_Math/E2_Math_Static/data/val/pass/")
train_fail <- list.files("./clean/Subject3_Math/E2_Math_Static/data/train/fail/")
val_fail <- list.files("./clean/Subject3_Math/E2_Math_Static/data/val/fail/")

length(train_pass)
length(val_pass)
length(train_fail)
length(val_fail)



