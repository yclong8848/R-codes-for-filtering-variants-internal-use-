
rm(list=ls(all=TRUE))

########### Further Filter Mark's De nova files ###################

Files = list.files("dn.filt/") # Read the folder of txt files which are all the Mark's De nova (dn) files
L = length(Files) 

for (i in 1:L){

setwd("dn.filt/")  
  
File = read.delim(Files[i], header = T)  # Read each txt file

### FILTER by Keeping "PASS" or unkown "." 
Filter2 = File[File$FILTER == "PASS" | File$FILTER == ".", ] 

### FILTER by Keeping SNVs (if you only focus on SNV not on INDEL; but here we focus on both)
# Filter1 = Filter[Filter$REF == "A" | Filter$REF =="C" | Filter$REF == "G"| Filter$REF == "T", ]
# Filter2 = Filter1[Filter1$ALT == "A" | Filter1$ALT =="C" | Filter1$ALT == "G"| Filter1$ALT == "T", ]

### Check the 93rd column, e.g., it shows: 0/1:36,8:44:60:60,0,1831 
Col93 = as.character(Filter2[, 93]) 
N = length(Col93)   

index = c()
for (j in 1:N){
  ### Extract the two characters of second item, e.g. 36, 8; soemtimes three characters with ".", e.g. 28,.,5
  TwoNum = strsplit(strsplit(Col93[j], ":")[[1]][2], ",")[[1]]
  ### Transform characters to numeric numbers and delete stupid "NA"
  TwoNum = na.omit(as.numeric(TwoNum))[1:2] 
  ### Output the index with DP > 15 and Alt depth percentage > 25%
  if (sum(TwoNum) > 15 & TwoNum[2]/sum(TwoNum) > 0.25){ 
    index = c(index, j)
  }
}

Filter3 = Filter2[index,]  # FILTER by the obtained index

setwd("..") # Go up to parent folder to output the results named with .filt2.csv; otherwise, you set up a path such as ./dn.filt2/
write.csv(Filter3, file=paste(Files[i], ".filt2.csv", sep=""))

}

##############################################################################
############### Check numbers of filtered de novo varaints ###################

Files = list.files("dn.filt2/") # Assume we put all the above result in the folder dn.filt2/
L = length(Files)
setwd("dn.filt2/")

### Check how many filtered de novo varaints in each file
for (i in 1:L){
  File = read.csv(Files[i], header = T)  # Read csv file
  Num = length(File$start)
  print(Num)
}





