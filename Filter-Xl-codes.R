
rm(list=ls(all=TRUE))

########### Filter Xl files ###################

Files = list.files("Xl/") # Read the folder of txt files which are all the Mark's Xl files
L = length(Files) 

for (i in 1:L){

setwd("Xl/")  
  
File = read.delim(Files[i], header = T)  # Read each txt file

### FILTER by Keeping "PASS" or unkown "."  
# Filter2 = File[File$FILTER == "PASS" | File$FILTER == ".",] 

### FILTER by Keeping SNVs (if you only focus on SNV not on INDEL; but here we focus on both)
# Filter1 = Filter[Filter$REF == "A" | Filter$REF =="C" | Filter$REF == "G"| Filter$REF == "T", ]
# Filter2 = Filter1[Filter1$ALT == "A" | Filter1$ALT =="C" | Filter1$ALT == "G"| Filter1$ALT == "T", ]

### Check the 93rd column, e.g., it shows: 0/1:36,8:44:60:60,0,1831 
Col93 = as.character(File[, 93]) 
N = length(Col93)   

index = c()
for (j in 1:N){
  ### Extract the two characters of second item, e.g. 36, 8; soemtimes three characters with ".", e.g. 28,.,5
  TwoNum = strsplit(strsplit(Col93[j], ":")[[1]][2], ",")[[1]]
  ### Transform characters to numbers and delete stupid "NA"
  TwoNum = na.omit(as.numeric(TwoNum))[1:2] 
  ### Output the index with DP >= 10 ## Note here.
  if (sum(TwoNum) >=  10){ 
    index = c(index, j)
  }
}

Filter3 = File[index,]  # FILTER by the obtained index

setwd("..")  # Go up to parent folder to output the results named with .Xl.csv; otherwise, you set up a path such as ./Xl2/
write.csv(Filter3, file=paste(Files[i], ".Xl.csv", sep=""))

}

##############################################################################
####### We want to combine all the results in one file to easily check #######

 
Files = list.files("Xl2/")
L = length(Files)
setwd("Xl2/")
CFile = read.csv(Files[1], header = F)

### Combine all the files into one file
for (i in 2:L){
  File = read.csv(Files[i], header = F)  # Read csv file
  #Num = length(File$start)
  #print(Num)
  CFile = rbind(CFile, File)
}
write.csv(CFile, file="Xl-WGS.csv")




