library(dplyr)
# Code for QC of CSV files generated from GIA Server 
# QC of Nation-CL3 Rx Trends Tab at Nation and RM Level


## Author : Abhinav

dp  <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation"
dpv <- ""
dpv[1]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL1_Nation"
dpv[2]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL1_RM"

sheet_nm <- ""
sheet_nm[1] <- "CL1_Nation"
sheet_nm[2] <- "CL1_RM"

err_loc<-""
err_loc <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL1_Nation\\Error_Files"

#n <- list()
#cl<- ""
#file_nm <- ""

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

# enter the number of files generated from the combination
#nfile <- 64
#hfile <- nfile/2

#for(i in 1:nfile)
#{
#  file_nm[i] <- paste0("prod",i,".csv")
#}


#Directory set should always be "path\\pdft\\pdft\\bin"
setwd(dp)

#Initial Declarations
library(xlsx)

z<-""

for (i in 1:length(file_name$file_name))
{
  setwd(dpv[1])
  x = read.csv(file=file_name$file_name[i],head=TRUE,sep=",", stringsAsFactors = F)
  setwd(dpv[2])
  y = read.csv(file=file_name$file_name[i],head=TRUE,sep=",", stringsAsFactors = F)
  
  a = unique(x)
  b = unique(y)
  
  if (i <= (length(file_name$file_name)/2))
  {
    ## This is to QC Copay Sheets
    a = a[order(a$Terr.Nm),]
    b = b[order(b$Terr.Nm),]
    
    a <- a[,c("Terr.Nm","Reach.Change..", "Reach.Change.Shape", "Reach" ,"Cpay.Drops.C" ,"Sum.of.Tcl.Hcps")]
    b <- b[,c("Terr.Nm","Reach.Change..", "Reach.Change.Shape", "Reach" ,"Cpay.Drops.C" ,"Tcl.Hcps")]
    
    colnames(b)[colnames(b)=='Tcl.Hcps'] <- "Sum.of.Tcl.Hcps"
    
    a<-a[!(is.na(a$Terr.Nm) | a$Terr.Nm==""),]
    b<-b[!(is.na(b$Terr.Nm) | b$Terr.Nm==""),]
    
    rownames(a) <- NULL
    rownames(b) <- NULL
    
    z[i] <- identical(a,b)
    
    if(z[i]==FALSE)
    {
      setwd(err_loc)
      write.csv(a, file = paste0(paste0("Nat_",i),".csv") , row.names = FALSE)
      write.csv(b, file = paste0(paste0("CL1_",i),".csv") , row.names = FALSE)
    }
  }
  else
  {
    ## This is to QC RTE Sheets
    
    a = a[order(a$Terr.Nm),]
    b = b[order(b$Terr.Nm),]
    
    a <- a[,c("Terr.Nm","Open.Rate", "Reach", "Cpay.Drops.C" ,"Mails.Opened" ,"Sum.of.Tcl.Hcps")]
    b <- b[,c("Terr.Nm","Open.Rate", "Reach", "Cpay.Drops.C" ,"Mails.Opened" ,"Tcl.Hcps")]
    
    colnames(b)[colnames(b)=='Tcl.Hcps'] <- "Sum.of.Tcl.Hcps"
    
    a<-a[!(is.na(a$Terr.Nm) | a$Terr.Nm==""),]
    b<-b[!(is.na(b$Terr.Nm) | b$Terr.Nm==""),] 
    
    rownames(a) <- NULL
    rownames(b) <- NULL
    
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
