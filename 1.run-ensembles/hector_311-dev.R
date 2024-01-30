# What is the release run time for Hector V 3.1.1 dev

# 0. Set Up ---------------------------------------------------------------------
# Install or load the version of Hector to be testing. If this is going to be something 
# committed to the repo ideally you would use remotes::install_github(specific hector branch/version)
# Save information about the package. 
remotes::install_github("JGCRI/hector@dev")
library(hector)
hector_pkg_info <- devtools::package_info("hector")
hector_v <- hector_pkg_info[hector_pkg_info[["package"]] == "hector", ][["ondiskversion"]]
hector_git <- hector_pkg_info[hector_pkg_info[["package"]] == "hector", ][["source"]]

# Additional packages used
library(ggplot2)
library(magrittr)

# Define helper functions 

# Rest, run, and fetch results from an active Hector core
# Args
#   hc: active hector core 
# Return: data frame of results
my_hector_run_fxn <- function(hc){
  reset(hc)
  run(hc)
  fetchvars(hc, dates = 1850:2100)
}


# 1. Emission Driven Run Hector Ensembles ----------------------------------------------------------
# Set up the Hector run 
ini <- system.file("input/hector_ssp245.ini", package = "hector") 
hc <- newcore(ini)


ensemble_sizes <- c(1, 5, 10, 100, 1000, 1e4)

lapply(ensemble_sizes, function(n){
  
  message("Running ensemble size: ", n)
  time_n <- system.time({
    x <- lapply(X = 1:n, FUN = my_run_fxn)
  })
  df <- cbind(ensemble = n, t(as.data.frame(time_n)))
  return(df)
}) %>% 
  do.call(what = "rbind") -> 
  emission_driven_ensemble


results <- cbind(data.frame(emission_driven_ensemble), 
                 version = hector_v, git = hector_git)

ofile <- here::here("output", paste0("ensemble_run_time-", hector_v, "-dev.csv")) 

if(file.exists(ofile)){
  message("It looks like ", ofile, " already exists, do you want to overwrite this file?")
} else {
  write.csv(x = results, file = ofile, row.names = FALSE)
}
