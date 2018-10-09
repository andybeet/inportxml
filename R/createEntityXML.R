# write xlsx file as an xml file
# August 2018- Andy Beet
# locationOfTHisFile <- dirname(rstudioapi::getSourceEditorContext()$path)
# setwd(locationOfTHisFile)

if (!require(xml2)) {install.packages("xml2")}
if (!require(readxl)) {install.packages("readxl")}


createEntityXML <- function(inFile="Master_Template.xlsx",outFile="entity_InportXML.xml"){

if (file.exists(outFile)) file.remove(outFile)

# read in data file
data1 <- readxl::read_excel(inFile, sheet = "Entity", skip = 1, n_max = 9)
data2 <- readxl::read_excel(inFile, sheet = "Entity", skip = 13, n_max = 49) 
  
data <- rbind(data1[,1:3],data2[,1:3])

data <- data[,1:3] # # keep first 3 fields only (level, tag, value)
data[is.na(data$value),]$value <- ""
data$value <- as.factor(data$value)


data$value <- as.character(data$value)
nRows <- dim(data)[1]
nCols <- dim(data)[2]

# now construct xml file given inputs in data file
# find the main tags and their indices
mainTagIndex <- which(data[,1]==1)
mainTags <- data[mainTagIndex,]
# attributes only on main tag. if exist elsewhere then template inport xml has changed
for (irow in 1:dim(mainTags)[1]) {
  write(paste0("<",mainTags[irow,2],">"),file=outFile,append=T)

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


}

# we write out tags and nested tags
recursive_Write_Tags <- function(outFile,data,level) {
  TagsIndex <- which(data[,1]==level) # pick out all tags indices at level = level
  Tags <- data[TagsIndex,] # data at level = level
  #print(Tags)
  nRows <- dim(Tags)[1] # number at this level

  for (irow in 1:nRows) { #3 loop through each record at level = level
    if (tolower(Tags[irow,3]) != "head")  { # not a header#  empty, write tag and value
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


