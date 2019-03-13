library(dplyr)
# Code for QC of CSV files generated from GIA Server 
# QC of Nation-CL1 Rx Trends Tab at Nation and RM Level

dp  <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation"
dpv <- ""
dpv[1]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\POA\\CL1_Nation"
dpv[2]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\POA\\CL1_RM"

sheet_nm <- ""
sheet_nm[1] <- "CL1_Nation"
sheet_nm[2] <- "CL1_RM"

err_loc<- ""
err_loc <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\POA\\CL1_Nation\\Error_Files"

#n <- list()
#cl<- ""
#file_name <- ""

setwd(dpv[1])
# enter the number of files generated from the combination
#nfile <- 26

file_name <- as.data.frame(list.files(dpv[1], pattern = ".csv"))
colnames(file_name)[1] <- "file_name"
file_name$file_name <- as.character(file_name$file_name)

for (i in 1:length(file_name$file_name))
{
  file_name$len[i] <- length(count.fields(file_name$file_name[i]))
  file_name$order[i]<-substr(file_name$file_name[i],5,as.integer(gregexpr("csv",file_name$file_name[i]))-2)
}

file_name$order<-as.integer(file_name$order)
file_name<-file_name%>%arrange(order)
file_name <- file_name %>% filter(len != 0)
# file_name$order[i]<-substr(file_name$file_name[i],5,as.integer(gregexpr("csv",file_name$file_name[i]))-1)

#Directory set should always be "path\\pdft\\pdft\\bin"
setwd(dp)

#Initial Declarations
library(xlsx)

z<-""

col<- c("Level.Name","Measure", "Measure.Value.....added")

for (i in 1:length(file_name$file_name))
{
 
  k<-file_name$order[i]
  
  setwd(dpv[1])
  x = read.csv(file = file_name$file_name[i],head=TRUE,sep=",")
  setwd(dpv[2])
  y = read.csv(file = file_name$file_name[i],head=TRUE,sep=",")
  
  a = unique(x)
  b = unique(y)
  
  if (k < 25)
  {
    a = a[order(a$Level.Name, a$Measure),]
    b = b[order(b$Level.Name, b$Measure),]
    
    rownames(a) <- NULL
    rownames(b) <- NULL
    
    a <- a[, col]
    b <- b[, col]
    
    z[i] <- identical(a,b)
    
    if(z[i]==FALSE)
    {
      setwd(err_loc)
      write.csv(a, file = paste0(paste0("Nat_",i),".csv") , row.names = FALSE)
      write.csv(b, file = paste0(paste0("CL1_",i),".csv") , row.names = FALSE)
    
    
  
  
  
      }} else 
  {
    a = a[order(a[,"Level.Name"], a[,"MEASURE_NAME"]),]
    b = b[order(b[,"Level.Name"], b[,"MEASURE_NAME"]),]
    
    rownames(a) <- NULL
    rownames(b) <- NULL
    
    a <- a[,c("Level.Name","MEASURE_NAME", "X..of.Total.Sum.of.MEASURE_VALUE")]
    b <- b[,c("Level.Name","MEASURE_NAME", "X..of.Total.MEASURE_VALUE")]
    colnames(a)[colnames(a)=='X..of.Total.Sum.of.MEASURE_VALUE'] <- "Measure_Value"
    colnames(b)[colnames(b)=='X..of.Total.MEASURE_VALUE'] <- "Measure_Value"
    
    z[i] <- identical(a,b)
    
    if(z[i]==FALSE)
    {
      setwd(err_loc)
      write.csv(a, file = paste0(paste0("Nat_",i),".csv") , row.names = FALSE)
      write.csv(b, file = paste0(paste0("CL1_",i),".csv") , row.names = FALSE)
    }
    
  }
  
}


z <- as.data.frame(z)
error <- z %>% filter(z == "FALSE")
length(error$z)
z_file <- which(z$z == "FALSE")
list_of_files <- as.data.frame(file_name$file_name[z_file])
