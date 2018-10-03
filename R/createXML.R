# write csv file as an xml file
# August 2018- Andy Beet
# locationOfTHisFile <- dirname(rstudioapi::getSourceEditorContext()$path)
# setwd(locationOfTHisFile)

createXML <- function(inFile="InportXML-template.csv",outFile="output_InportXML.xml"){
library(xml2)

if (file.exists(outFile)) file.remove(outFile)

# read in data file
data <- read.csv(inFile,header=TRUE)
data <- data[,-dim(data)[2]] # remove comments field (last column)
data$value <- as.character(data$value)
# read in attributes file. created in readXML
attributes <- read.csv("XMLattributes.csv",header=TRUE)
nRows <- dim(data)[1]
nCols <- dim(data)[2]

# write standard header of xml file.
writeHeader(outFile)
# now construct xml file given inputs in data file
# find the main tags and their indices
mainTagIndex <- which(data[,1]==1)
mainTags <- data[mainTagIndex,]
# attributes only on main tag. if exist elsewhere then template inport xml has changed
for (irow in 1:dim(mainTags)[1]) {
  index <- attributes$tag == as.character(mainTags[irow,2]) 
  if (any(index)) { # this tag has an attribute
    att <- attributes[index,]
    write(paste0("<",mainTags[irow,2]," ",att$attribute,"=\"",att$value,"\">"),file=outFile,append=T)
  } else {
    write(paste0("<",mainTags[irow,2],">"),file=outFile,append=T)
  }
  
  # now write out all of the nested stuff. recursive procedure
  if (irow == dim(mainTags)[1]) { # last header !
    nested <- data[(mainTagIndex[irow]+1):nrow(data),]
  } else { # all other headers
    nested <- data[(mainTagIndex[irow]+1):(mainTagIndex[irow+1]-1),]
  }
  # recursive operation
  recursive_Write_Tags(outFile,nested,level=2)
  write(paste0("</",mainTags[irow,2],">"),file=outFile,append=T)
}

writeFooter(outFile)

}

# we write out tags and nested tags
recursive_Write_Tags <- function(outFile,data,level) {
  TagsIndex <- which(data[,1]==level) # pick out all tags indices at level = level
  Tags <- data[TagsIndex,] # data at level = level
  #print(Tags)
  nRows <- dim(Tags)[1] # number at this level

  for (irow in 1:nRows) { #3 loop through each record at level = level
    if(tolower(Tags[irow,3]) != "head") { # not a header#  empty, write tag and value
    #if(nchar(Tags[irow,3]) > 0) { # not empty, write tag and value
        textToWrite <- paste0("<",Tags[irow,2],"> ",Tags[irow,3]," </",Tags[irow,2],">")
      write(textToWrite,file=outFile,append=T)
    
    } else { # another header. find new indices and recursive
      textToWrite <- paste0("<",Tags[irow,2],"> ")
      write(textToWrite,file=outFile,append=T)
      # extract data between subsequent indices
      if (irow == nRows) { # last record
        nestedData <- data[(TagsIndex[irow]+1):nrow(data),]
      } else {
        nestedData <-data[(TagsIndex[irow]+1):(TagsIndex[irow+1]-1),]
      }
        recursive_Write_Tags(outFile,nestedData,level=level+1)
        textToWrite <- paste0("</",Tags[irow,2],"> ")
        write(textToWrite,file=outFile,append=T)
     }

  } # for loop 
}


writeHeader <- function(outFile){
  write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>",file=outFile,append=T)
  write("<!-- Last Update: InPort Release 4.0.0.0 -->",file=outFile,append=T)
  write("<inport-metadata version=\"1.31\">",file=outFile,append=T)
  
}

writeFooter <- function(outFile){
  write("</inport-metadata>",file=outFile,append=T)
}

