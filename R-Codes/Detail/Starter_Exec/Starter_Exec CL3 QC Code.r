# Code for QC of CSV files generated from GIA Server 
# QC of Detail Starter Executive Tab at Nation and RM Level

library(xlsx)

dp  <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation"

## 'c' refers to Cluster number

dpv <- ""
dpv[1]<- paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Detail\\Starter_Exec\\CL3_Nation")
dpv[2]<- paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Detail\\Starter_Exec\\CL3_RM")

## Error Directory inside Nation folder
err_loc <- paste0("H:\\01. GIP BAI\\MBR\\Automation\\Automation\\Detail\\Starter_Exec\\CL1_Nation\\Error_Files")


nat_files <- list.files(path = dpv[1], pattern = "\\.csv$", all.files = FALSE,
                        full.names = FALSE, recursive = FALSE,
                        ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

rm_files <- list.files(path = dpv[2], pattern = "\\.csv$", all.files = FALSE,
                       full.names = FALSE, recursive = FALSE,
                       ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)


## Code will only proceed if the number of files are same in both the folders
if (length(nat_files) != length(rm_files)) {
  print(paste0("No. of files mismatch in the Nation and RM folder for cluster: ",c))
} else {
  
  ## List name to store the .csv file names in the Cluster Folders 
  file_nm <- ""
  
  for(k in 1:length(nat_files))
  {
    file_nm[k] <- paste0("prod",k,".csv")
  }
  
  z<-""
  
  for(i in 1:length(nat_files))
  {
    
    # Nation File
    
    x = read.csv(file=paste0(dpv[1],"\\",file_nm[i]),header=TRUE,sep=",", stringsAsFactors = F,blank.lines.skip=TRUE)
    
    
    # Cluster File
    y = read.csv(file=paste0(dpv[2],"\\",file_nm[i]),header=TRUE,sep=",", stringsAsFactors = F)
    
    a = unique(x)
    b = unique(y)
    b$TERR_NM<- ifelse(grepl("CL3-Cluster",a$TERR_NM ), "US", a$TERR_NM)
    
    a = a[order(a$TERR_NM),]
    b = b[order(b$TERR_NM),]
    
    m<-ncol(a)
    
    colnames(a)[m]<-"TCL..HCPs"
    
    g<-ncol(b)
    
    colnames(b)[g]<-"TCL_HCPs"
    
    a <- a[,c("Detail.Frequency.Difference","Detail.Frequency.Increase","Detail.Frequency.Shape","Detail.Frequency",
              "Detail.Reach.Difference","Detail.Reach.Increase","Detail.Reach.Shape","Detail.Reach","Starter.Reach.Difference",
              "Starter.Reach.Increase","Starter.Reach.Shape","Starters.Reach","TCL..HCPs")]
    
    ## Changing column names to make them match across workbooks
    colnames(a) <- c("Detail.Frequency.Difference","Detail.Frequency.Increase","Detail.Frequency.Shape","Detail.Frequency",
                     "Detail.Reach.Difference","Detail.Reach.Increase","Detail.Reach.Shape","Detail.Reach","Starter.Reach.Difference",
                     "Starter.Reach.Increase","Starter.Reach.Shape","Starters.Reach","TCL..HCPs")
    
    
    b <- b[,c("Detail.Frequency.Difference","Detail.Frequency.Increase","Detail.Frequency.Shape","Detail.Frequency",
              "Detail.Reach.Difference","Detail.Reach.Increase","Detail.Reach.Shape","Detail.Reach","Starter.Reach.Difference",
              "Starter.Reach.Increase","Starter.Reach.Shape","Starters.Reach","TCL_HCPs")]
    
    colnames(b) <- c("Detail.Frequency.Difference","Detail.Frequency.Increase","Detail.Frequency.Shape","Detail.Frequency",
                     "Detail.Reach.Difference","Detail.Reach.Increase","Detail.Reach.Shape","Detail.Reach","Starter.Reach.Difference",
                     "Starter.Reach.Increase","Starter.Reach.Shape","Starters.Reach","TCL..HCPs")
    
    z[i] <- identical(a,b)
    
    if(z[i]==FALSE)
    {
      setwd(err_loc)
      write.csv(a, file = paste0(paste0("Nat3_",i),".csv") , row.names = FALSE)
      write.csv(b, file = paste0(paste0("CL3_",i),".csv") , row.names = FALSE)
    }
  }
  
  
  
  
} # If condition ends

# Cluster for loop ends