    # Code for QC of CSV files generated from GIA Server 
    # QC of Nation-CL3 Rx Trends Tab at Nation and RM Level

dp  <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation"
dpv <- ""
dpv[1]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\2.Nation_Rx_Trends"
dpv[2]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\1.CL3_Rx_Trends"

sheet_nm <- ""
sheet_nm[1] <- "Nation_Rx_Trends"
sheet_nm[2] <- "CL3_Rx_Trends"

err_loc <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\2.Nation_Rx_Trends\\Error_Files"

n <- list()
cl<- ""
file_nm <- ""

# enter the number of files generated from the combination
nfile <- 32
  
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
  
  a = a[order(a$MARKET, a$TERR_NM),]
  b = b[order(b$MARKET, b$TERR_NM),]
  
  a <- a[,c("MARKET","TERR_NM", "EI", "Mkt.Gwth.Shape" ,"Mkt.Gwth" ,"Mkt.Vol" ,"Product.Growth.Shape" ,"Product.Growth" ,"Product.Volume" ,"Rx.Share.Point.Change.Shape" ,"Rx.Share.Point.Change" ,"Share")]
  b <- b[,c("MARKET","TERR_NM", "EI", "Mkt.Gwth.Shape" ,"Mkt.Gwth" ,"Mkt.Vol" ,"Product.Growth.Shape" ,"Product.Growth" ,"Product.Volume" ,"Rx.Share.Point.Change.Shape" ,"Rx.Share.Point.Change" ,"Share")]
  
  z[i] <- identical(a,b)
  
  if(z[i]==FALSE)
  {
    setwd(err_loc)
    write.csv(a, file = paste0(paste0("Nat_",i),".csv") , row.names = FALSE)
    write.csv(b, file = paste0(paste0("CL3_",i),".csv") , row.names = FALSE)
  }
}