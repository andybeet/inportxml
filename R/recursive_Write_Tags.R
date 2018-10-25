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
