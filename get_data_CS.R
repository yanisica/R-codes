#==========================================================================
#==========================================================================
# Get files from GC
#==========================================================================
#==========================================================================


rm(list=ls())

#install.packages('devtools') 
#devtools::install_github("rstats-db/bigrquery")
library(bigrquery)
library(readr)
#library(DBI)
library(dplyr)
library(tidyr)
#library(jsonlite) 
#library(stringr)

#Autentication for GoogleCloud
GCP_SERVICE_KEY = "~/map-of-life-e38c8605def2-sdm-user.json" #key should always be in your home directory
Sys.setenv("GCS_AUTH_FILE" = GCP_SERVICE_KEY)
Sys.setenv("GCS_DEFAULT_BUCKET" = "mol-playground") #bucket where data is
library(googleCloudStorageR)
bigrquery::set_service_token(GCP_SERVICE_KEY)


GEE_data = gcs_list_objects(prefix='MountainClimate/CHELSA',detail = c("summary"))
GS_filenames=separate(GEE_data, id,into = c("file", "id1"), sep = "/1")
GS_filenames=GS_filenames[,c('file')]
GEE_names=separate(GEE_data, name,into = c("path1","name"),sep = "/")
GEE_names=separate(GEE_names, name,into = c("name"),sep = ".tif")
GEE_names=GEE_names[,c('name')]

GEE=cbind(GEE_names, GS_filenames)
GEE=as.data.frame(GEE)
GEE= mutate(GEE, upload = 'earthengine upload image --asset_id=projects/earthenv/mountain_climate/',GS=' gs://')
GEE=GEE[,c('upload','GEE_names','GS','GS_filenames')]
GEE=unite(GEE, col='run', sep='')
write.csv(GEE, file="GEE.csv") #saves in home directory where the key is

