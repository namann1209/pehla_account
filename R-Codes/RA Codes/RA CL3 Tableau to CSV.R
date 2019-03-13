
## Author : Abhinav

dp  <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation"
dpv <- ""
dpv[1]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL3_Nation"
dpv[2]<- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\RA\\CL3_RM"

sheet_nm <- ""
sheet_nm[1] <- "CL3_Nation"
sheet_nm[2] <- "CL3_RM"

#Directory set should always be "path\\pdft\\pdft\\bin"
setwd(dp)

#Initial Declarations
library(xlsx)
op=getwd()
op=gsub("/","\\",op,fixed=T)

#Beginning of printing in batch file
line1="c:"
line2="cd \"c:\\Program Files\\Tableau\\Tableau Server\\9.0\\extras\\Command Line Utility\""
line2a="set /p gia_usr=Enter UID"
line2b="set /p gia_pswrd= Enter pwd"
line3=paste("Tabcmd login -s https://gia.pfizer.com/ -t PfizerWorks -u apac\\%gia_usr% -p %gia_pswrd% --no-certcheck",sep="")

#function to cleanup the columns from special characters

trimstr1=function(strng) {
  strng=gsub("[[(-.,)]]","",strng,fixed=T)
  strng=gsub("+","%%2B",strng,fixed=T)
  strng=gsub("&","%%26",strng,fixed=T)
  strng=gsub(" ","",strng,fixed=T)
}

trimstr2=function(strng) {
  strng=gsub("[[(-.,)]]","",strng,fixed=T)
  strng=gsub("+","%%2B",strng,fixed=T)
  strng=gsub("&","%%26",strng,fixed=T)
  strng=gsub(" ","+",strng,fixed=T)
}

#function to print pdf files from Tableau server, collate pdfs chapterwise, delete redundant files
func=function(ch){
  
  ch$Workbook_name=trimstr1(ch$Workbook_name)
  ch$tab_name       =trimstr1(ch$tab_name)
  ch$filter_name    =trimstr2(ch$filter_name)
  ch$filter_value   =trimstr2(ch$filter_value)
  ch$filter_name_2  =trimstr2(ch$filter_name_2)
  ch$filter_value_2 =trimstr2(ch$filter_value_2)
  ch$filter_name_3  =trimstr2(ch$filter_name_3)  
  ch$filter_value_3 =trimstr2(ch$filter_value_3)
  ch$filter_name_4  =trimstr2(ch$filter_name_4)	
  ch$filter_value_4 =trimstr2(ch$filter_value_4)
  ch$filter_name_5  =trimstr2(ch$filter_name_5)	
  ch$filter_value_5 =trimstr2(ch$filter_value_5)
  ch$filter_name_6  =trimstr2(ch$filter_name_6)	
  ch$filter_value_6 =trimstr2(ch$filter_value_6)
  ch$filter_name_7  =trimstr2(ch$filter_name_7)	
  ch$filter_value_7 =trimstr2(ch$filter_value_7)
  ch$filter_name_8  =trimstr2(ch$filter_name_8)	
  ch$filter_value_8 =trimstr2(ch$filter_value_8)
  ch$filter_name_9  =trimstr2(ch$filter_name_9)	
  ch$filter_value_9 =trimstr2(ch$filter_value_9)
  
  
  ch$url=paste("\"",ch$Workbook_name,"/",ch$tab_name,"?",
               ch$filter_name,"=", ch$filter_value, "&",
               ch$filter_name_2, "=", ch$filter_value_2, "&",
               ch$filter_name_3, "=", ch$filter_value_3, "&", 
               ch$filter_name_4, "=", ch$filter_value_4, "&", 
               ch$filter_name_5, "=", ch$filter_value_5, "&", 
               ch$filter_name_6, "=", ch$filter_value_6, "&", 
               ch$filter_name_7, "=", ch$filter_value_7, "&", 
               ch$filter_name_8, "=", ch$filter_value_8, "&", 
               ch$filter_name_9, "=", ch$filter_value_9, "&", 
              
     
               "\"",sep="")
  
  ch$op_file=paste("prod",ch$Sequence,".csv",sep="")
  ch$op_file_path=paste(op,"\\","prod",ch$Sequence,".csv",sep="")
  
  line4=""
  line7="pdftk"
  line8=""
  for (i in 1:nrow(ch)) 
  {
    line4=paste(line4,"tabcmd export -t PfizerWorks ",ch$url[[i]]," --csv -f \"",ch$op_file_path[[i]] ,"\" --timeout 10000 --no-certcheck\n",sep="")
    line7=paste(line7,ch$op_file[[i]],sep=" ")
  }
  #line5=substr(op,1,2)
  #line6=paste("cd \"",op,"\"",sep="")
  #line7=paste(line7," output \"",ch_name,".xlsx\"",sep="")
  #for (i in 1:nrow(ch)) {
  #  line8=paste(line8,"del ",ch$op_file[[i]],"\n",sep="")
  #}
  cmd=paste(line1,line2,line2a,line2b,line3,line4,sep="\n")
  write(cmd,file ="batcode.bat",ncolumns = 1,append = F,sep = "")
  #shell.exec("batcode.bat")
}

for ( i in 1:2)   
{
      setwd(dp)
      #Reading filters chapterwise
      ch=read.xlsx("Print_to_Excel_RA.xlsx",sheetName = sheet_nm[i], stringsAsFactors = F)
      ch$filter_value_5[which(is.na(ch$filter_value_5))] = ""
      ch$filter_value_6[which(is.na(ch$filter_value_6))] = ""
      ch$filter_value_7[which(is.na(ch$filter_value_7))] = ""
      ch$filter_value_8[which(is.na(ch$filter_value_8))] = ""
      ch$filter_value_9[which(is.na(ch$filter_value_9))] = ""
          
      
      setwd(dpv[i])
      op=getwd()
      op=gsub("/","\\",op,fixed=T)
      
       
      func(ch)
      
}
#Delete batch file
#file.remove("batcode.bat")
#Collate all chapters
#collate_all="pdftk Chapter1.pdf Chapter2.pdf Chapter3.pdf Chapter4.pdf Chapter5.pdf output \"Bluebook.pdf\""
#system(collate_all)
