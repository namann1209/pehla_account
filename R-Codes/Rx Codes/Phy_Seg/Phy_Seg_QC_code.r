library(stringr)
library(dplyr)

for (i in 1:3){
  
  Nation_files_list <- list.files(paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Rx\\Phy_Seg\\CL",i,"_Nation",sep=''),pattern = '.csv')
  
  RM_files_list <- list.files(paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Rx\\Phy_Seg\\CL",i,"_RM",sep=''), pattern = '.csv')
  
  
  if(length(Nation_files_list) != length(RM_files_list)){
    
    assign(paste0("CL",i,"_error"),paste("Error in CL",i," files!",sep = ""))
    
    } else {
      
    setwd(paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Rx\\Phy_Seg\\CL",i,"_Nation",sep=''))
    Nation_files <- lapply(Nation_files_list,function(x)  read.csv(file = x,header = T,stringsAsFactors = F,
                                                               col.names = c("Key_Speciality","TCL_Segments","Percentage_HCPs","Brand_NRx_per_MD",
                                                                             "Brand_TRx_per_MD","HCP_Count")))
    
    
    setwd(paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Rx\\Phy_Seg\\CL",i,"_RM",sep=''))
    RM_files <- lapply(RM_files_list,function(x)  read.csv(file = x,header = T,stringsAsFactors = F,
                                                           col.names = c("Key_Speciality","TCL_Segments","Percentage_HCPs","Brand_NRx_per_MD",
                                                                         "Brand_TRx_per_MD","HCP_Count")))
    x <- data.frame(Nation_file = character(),RM_file = character(), err_chk = logical())
    for(j in 1:length(Nation_files_list)){
      nation_temp <- as.data.frame(Nation_files[j])
      
      nation_temp$Key_Speciality <- gsub(' ','',as.character(nation_temp$Key_Speciality))
      nation_temp$TCL_Segments <- gsub(' ','',as.character(nation_temp$TCL_Segments))
      nation_temp$Percentage_HCPs <- as.numeric(substr(nation_temp$Percentage_HCPs,1,nchar(nation_temp$Percentage_HCPs)-1))
      nation_temp$Brand_NRx_per_MD <- as.numeric(nation_temp$Brand_NRx_per_MD)
      nation_temp$Brand_TRx_per_MD <- as.numeric(nation_temp$Brand_TRx_per_MD)
      nation_temp$HCP_Count <- as.numeric(gsub(',','',nation_temp$HCP_Count))
      nation_temp <- nation_temp %>% distinct()
      
      rm_temp <- as.data.frame(RM_files[j])
      rm_temp$Key_Speciality <- gsub(' ','',as.character(rm_temp$Key_Speciality))
      rm_temp$TCL_Segments <- gsub(' ','',as.character(rm_temp$TCL_Segments))
      rm_temp$Percentage_HCPs <- as.numeric(substr(rm_temp$Percentage_HCPs,1,nchar(rm_temp$Percentage_HCPs)-1))
      rm_temp$Brand_NRx_per_MD <- as.numeric(rm_temp$Brand_NRx_per_MD)
      rm_temp$Brand_TRx_per_MD <- as.numeric(rm_temp$Brand_TRx_per_MD)
      rm_temp$HCP_Count <- as.numeric(gsub(',','',rm_temp$HCP_Count))
      rm_temp <- rm_temp %>% distinct()
      
      x <- rbind(x,data.frame(Nation_file = Nation_files_list[j], RM_file = RM_files_list[j], err_chk = identical(nation_temp, rm_temp)))
       
      rm(nation_temp,rm_temp)
    }
    if(sum(x$err_chk == TRUE) != nrow(x)){
      print(paste("Error in Cluster ",i))
    }
      
    assign(paste0("CL",i,"_identity",sep = ""), x)
    
  }
  
 
}

# x <- data.frame()
# for(i in 1:length(Nation_files_list)){
#   x <- rbind(x,colnames(as.data.frame(Nation_files[i])))
# }
# input_file_list_csv =lapply(get_files_csv,function(x)  read.csv(file = x,header = T,stringsAsFactors = F,
#                                                                 col.names = c("Key Speciality","TCL Segments","%HCPs","Brand_NRx_per_MD",
#                                                                               "Brand_TRx_per_MD","HCP_Count")))
# getwd()
# paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Rx\\Phy_Seg\\CL",i,"_Nation",sep='')
# i=1
# setwd(paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Rx\\Phy_Seg\\CL",i,"_Nation",sep=''))
# getwd()
# x <- read.csv(file = "prod1.csv",header = T,stringsAsFactors = F, col.names = c("a","b","c","d","e","f"))
# colnames(x)
# 
# a <- substr(a,1,nchar(a)-1)
# for(k in 1:length(a)){
#   a[k] <- substr(a[k],nchar(a[k]))