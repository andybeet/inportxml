#' Create XMl for an InPort data item from the InportXML metadata template spreadsheet.
#'
#' For an InPort metadata rubric score of 100%, the submission of both an Item and its
#' respective Entity are required. This function will create Item XML. Currently, the
#' term "Item" refers solely to a Data Set.
#'
#' @param inFile The full path to the metadata template (e.g. "~/Master_Template.xlsx").
#' @param outFile The name of the resulting XML file (e.g. "DataSet1.xml").
#' @return An XML file for an InPort Item.
#'
#' @examples
#' #Be sure that inFile refers to the full path of the metadata template
#' createItemXML(inFile = "~/Master_Template.xlsx", outFile = "DataSet1.xml")
#'
#' @export



createItemXML <- function(inFile,outFile){

  if (file.exists(outFile)) file.remove(outFile)

  # read in data file
  data <- readxl::read_excel(inFile, sheet = "Data_Set", skip = 1)

  data <- data[,1:3] # # keep first 3 fields only (level, tag, value)
  data[is.na(data$value),]$value <- ""
  data$value <- as.factor(data$value)


  data$value <- as.character(data$value)
  # read in attributes file. created in readXML
  attributes <- InportXML:::attributes
  nRows <- dim(data)[1]
  nCols <- dim(data)[2]

  # write standard header of xml file.
  InportXML:::writeHeader(outFile)
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
    InportXML:::recursive_Write_Tags(outFile,nested,level=2)
    write(paste0("</",mainTags[irow,2],">"),file=outFile,append=T)
  }

  InportXML:::writeFooter(outFile)

}






