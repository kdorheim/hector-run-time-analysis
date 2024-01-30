# How did adding the permafrost module change the run time? 

# 0. Set Up --------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(tidyr)
theme_set(theme_bw())

RSLT_DIR <- here::here("output")

# Load the data sets and format for easy plotting. 
main <- read.csv(file.path(RSLT_DIR, "ensemble_run_time-3.1.1.csv"))
pf_branch <- read.csv(file.path(RSLT_DIR, "ensemble_run_time-3.1.1-dev.csv"))

main$version <- "release"
pf_branch$version <- "permafrost"

df <- rbind(main, pf_branch)


# 1. Plot Results --------------------------------------------------------------------
ggplot(df) + 
  geom_line(aes(ensemble, user.self, color = version)) + 
  labs(title = "Run Time", y = "Time (seconds)", x = "Ensmble Size")

# So it does look like the permafrost has not really changed the run time by 
# much! Which is good! 
df %>% 
  select(ensemble, version, elapsed) %>% 
  spread(version, elapsed) %>% 
  mutate(dif = permafrost - release) %>% 
  mutate(dif_per_size = dif/ensemble)
  


