    # Code for QC of CSV files generated from GIA Server 
    # QC of Nation-CL1 Rx Trends Tab at Nation and RM Level

dp  <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation"
dpv <- ""
dpv[1]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\POA\\CL1_Nation"
dpv[2]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\POA\\CL1_RM"

sheet_nm <- ""
sheet_nm[1] <- "CL1_Nation"
sheet_nm[2] <- "CL1_RM"

err_loc <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\POA\\CL1_Nation\\Error_Files"

n <- list()
cl<- ""
file_nm <- ""

# enter the number of files generated from the combination
nfile <- 22
  
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
  x = read.csv(file=file_nm[i],head=TRUE,sep=",")
  setwd(dpv[2])
  y = read.csv(file=file_nm[i],head=TRUE,sep=",")
  
  a = unique(x)
  b = unique(y)
  
  if (i < 21)
  {
    a = a[order(a$Level.Name, a$Measure),]
    b = b[order(b$Level.Name, b$Measure),]
    
    rownames(a) <- NULL
    rownames(b) <- NULL
    
    a <- a[,c("Level.Name","Measure", "Measure.Value.....added")]
    b <- b[,c("Level.Name","Measure", "Measure.Value.....added")]
    
    
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

