    # Code for QC of CSV files generated from GIA Server 
    # QC of Nation-CL2 Rx Trends Tab at Nation and RM Level


## Author : Abhinav

dp  <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation"
dpv <- ""
dpv[1]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL2_Nation"
dpv[2]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL2_RM"

sheet_nm <- ""
sheet_nm[1] <- "CL2_Nation"
sheet_nm[2] <- "CL2_RM"

err_loc <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL2_Nation\\Error_Files"

n <- list()
cl<- ""
file_nm <- ""

# enter the number of files generated from the combination
nfile <- 16
hfile <- nfile/2
  
for(i in 1:nfile)
{
  file_nm[i] <- paste0("prod",i,".csv")
}

#Directory set should always be "path\\pdft\\pdft\\bin"
setwd(dp)

#Initial Declarations
library(xlsx)

z<-""

for(i in 1:nfile)
{
  setwd(dpv[1])
  x = read.csv(file=file_nm[i],head=TRUE,sep=",", stringsAsFactors = F)
  setwd(dpv[2])
  y = read.csv(file=file_nm[i],head=TRUE,sep=",", stringsAsFactors = F)
  
  a = unique(x)
  b = unique(y)
  
  if (i <= hfile)
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
      write.csv(b, file = paste0(paste0("CL2_",i),".csv") , row.names = FALSE)
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
      write.csv(b, file = paste0(paste0("CL2_",i),".csv") , row.names = FALSE)
    }
  }
}