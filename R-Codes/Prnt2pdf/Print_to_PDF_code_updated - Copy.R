
# Author : Abhinav Karnwal

dp <- "H:\\01. GIP BAI\\MBR\\Automation\\Automation\\print_to_pdf"

setwd(dp)

sheet_nm <- ""
sheet_nm[1] <- "1_Rx_Trends"
sheet_nm[2] <- "2_Field_Execution"
sheet_nm[3] <- "3_Detail_Exec"
sheet_nm[4] <- "4_Detail_Opt"
sheet_nm[5] <- "5_POA_Priorities"
sheet_nm[6] <- "6_Viagra PillsTRx"
sheet_nm[7] <- "7_Resource Allocation"
sheet_nm[8] <- "8_TCL Deployment Summary"
sheet_nm[9] <- "9Physician SegmentKey Specialty"
sheet_nm[10] <- "10_Executive Summary"

dpv <- ""
dpv[1] <- paste0(dp,"\\",sheet_nm[1])
dpv[2] <- paste0(dp,"\\",sheet_nm[2])
dpv[3] <- paste0(dp,"\\",sheet_nm[3])
dpv[4] <- paste0(dp,"\\",sheet_nm[4])
dpv[5] <- paste0(dp,"\\",sheet_nm[5])
dpv[6] <- paste0(dp,"\\",sheet_nm[6])
dpv[7] <- paste0(dp,"\\",sheet_nm[7])
dpv[8] <- paste0(dp,"\\",sheet_nm[8])
dpv[9] <- paste0(dp,"\\",sheet_nm[9])
dpv[10] <- paste0(dp,"\\",sheet_nm[10])

tot_tab <- length(dpv)

gia_usr="apac\\"
gia_pswrd=""

#Initial Declarations
library(xlsx)
op=getwd()
op=gsub("/","\\",op,fixed=T)

#Beginning of printing in batch file
line1="c:"
line2="cd \"c:\\Program Files\\Tableau\\Tableau Server\\9.0\\extras\\Command Line Utility\""
line3=paste("Tabcmd login -s https://gia.pfizer.com/ -t BAI -u ",gia_usr, " -p ",gia_pswrd, " --no-certcheck",sep="")

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
func=function(ch,k){
  
      ch$Workbook_name  =trimstr1(ch$Workbook_name)
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
      ch$filter_name_10 =trimstr2(ch$filter_name_10)  
      ch$filter_value_10=trimstr2(ch$filter_value_10)
      ch$filter_name_11 =trimstr2(ch$filter_name_11)  
      ch$filter_value_11=trimstr2(ch$filter_value_11)
      ch$filter_name_12 =trimstr2(ch$filter_name_12)  
      ch$filter_value_12=trimstr2(ch$filter_value_12)
      
      ch$url=paste("\"",ch$Workbook_name,"/",ch$tab_name,"?",
                   ch$filter_name,   "=", ch$filter_value, "&",
                   ch$filter_name_2, "=", ch$filter_value_2, "&",
                   ch$filter_name_3, "=", ch$filter_value_3, "&", 
                   ch$filter_name_4, "=", ch$filter_value_4, "&", 
                   ch$filter_name_5, "=", ch$filter_value_5, "&", 
                   ch$filter_name_6, "=", ch$filter_value_6, "&", 
                   ch$filter_name_7, "=", ch$filter_value_7, "&", 
                   ch$filter_name_8, "=", ch$filter_value_8, "&", 
                   ch$filter_name_9, "=", ch$filter_value_9, "&", 
                   ch$filter_name_10,"=", ch$filter_value_10, "&",
                   ch$filter_name_11,"=", ch$filter_value_11, "&", 
                   ch$filter_name_12,"=", ch$filter_value_12, "&", 
                   
                   "\"",sep="")
      
      ch$op_file=paste("prod",ch$Sequence,".pdf",sep="")
      ch$op_file_path=paste(op,"\\","prod",ch$Sequence,".pdf",sep="")
    
      line4=""
      line7="pdftk"
      line8=""
      for (i in 1:nrow(ch)) 
      {
        line4=paste(line4,"tabcmd export -t BAI ",ch$url[[i]]," --pdf -f \"",ch$op_file_path[[i]] ,"\" --timeout 10000 --no-certcheck\n",sep="")
        line7=paste(line7,ch$op_file[[i]],sep=" ")
      }
      line5=substr(op,1,2)
      line6=paste("cd \"",op,"\"",sep="")
      line7=paste(line7," output \"",sheet_nm[k],".pdf\"",sep="")
      #for (i in 1:nrow(ch)) {
      #  line8=paste(line8,"del ",ch$op_file[[i]],"\n",sep="")
      #}
      cmd=paste(line1,line2,line3,line4,sep="\n")
      write(cmd,file = paste0(sheet_nm[k],".bat"),ncolumns = 1,append = F,sep = "")
      cmd=paste(line5,line6,line7,sep="\n")
      write(cmd,file = paste0("Collate_",sheet_nm[k],".bat"),ncolumns = 1,append = F,sep = "")
      #shell.exec("batcode.bat")
}

# Reading filters
# For loop if multiple sheet are present in base excel filr to create URL

for ( k in 1:tot_tab)   
{
  setwd(dp)
  
  ch=read.xlsx("print_to_pdf.xlsx",sheetName = sheet_nm[k], stringsAsFactors = F)

    ch$filter_name[which(is.na(ch$filter_name))] = ""
    ch$filter_value[which(is.na(ch$filter_value))] = ""
    ch$filter_name_2[which(is.na(ch$filter_name_2))] = ""
    ch$filter_value_2[which(is.na(ch$filter_value_2))] = ""
    ch$filter_name_3[which(is.na(ch$filter_name_3))] = ""  
    ch$filter_value_3[which(is.na(ch$filter_value_3))] = ""
    ch$filter_name_4[which(is.na(ch$filter_name_4))] = ""
    ch$filter_value_4[which(is.na(ch$filter_value_4))] = ""
    ch$filter_name_5[which(is.na(ch$filter_name_5))] = ""
    ch$filter_value_5[which(is.na(ch$filter_value_5))] = ""
    ch$filter_name_6[which(is.na(ch$filter_name_6))] = ""
    ch$filter_value_6[which(is.na(ch$filter_value_6))] = ""
    ch$filter_name_7[which(is.na(ch$filter_name_7))] = ""
    ch$filter_value_7[which(is.na(ch$filter_value_7))] = ""
    ch$filter_name_8[which(is.na(ch$filter_name_8))] = ""
    ch$filter_value_8[which(is.na(ch$filter_value_8))] = ""
    ch$filter_name_9[which(is.na(ch$filter_name_9))] = ""
    ch$filter_value_9[which(is.na(ch$filter_value_9))] = ""
    ch$filter_name_10[which(is.na(ch$filter_name_10))] = ""
    ch$filter_value_10[which(is.na(ch$filter_value_10))] = ""
    ch$filter_name_11[which(is.na(ch$filter_name_11))] = ""
    ch$filter_value_11[which(is.na(ch$filter_value_11))] = ""
    ch$filter_name_12[which(is.na(ch$filter_name_12))] = ""
    ch$filter_value_12[which(is.na(ch$filter_value_12))] = ""

  
  setwd(dpv[k])
  
  op=getwd()
  op=gsub("/","\\",op,fixed=T)

  func(ch,k)
}


#Delete batch file
#file.remove("batcode.bat")

#Collate all chapters
#collate_all="pdftk prod1.pdf prod2.pdf prod3.pdf prod4.pdf prod5.pdf output \"Rx_Trends.pdf\""
#system(collate_all)
