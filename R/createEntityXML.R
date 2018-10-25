#' Create XMl for an InPort Entity from the InportXML metadata template spreadsheet.
#'
#' For an InPort metadata rubric score of 100%, the submission of both an Item and at
#' least one Entity are required. This function will create Entity XML. The term "Entity"
#' refers to specific metadata related to the structure of the Data Set, and must include
#' at least one "attribute" for successful XML upload. These instructions are further
#' explained in the "Master_Template.xlsx" file.
#'
#' @param inFile The full path to the metadata template (e.g. "~/Master_Template.xlsx").
#' @param outFile The name of the resulting XML file (e.g. "Entity1.xml").
#' @return An XML file for an InPort Entity.
#'
#' @examples
#' #Be sure that inFile refers to the full path of the metadata template
#' createEntityXML(inFile = "~/Master_Template.xlsx", outFile = "Data_Entity1.xml")
#'
#' @export


createEntityXML <- function(inFile,outFile){

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

  # write standard header of xml file.
  InportXML:::writeHeader(outFile)

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
    InportXML:::recursive_Write_Tags(outFile,nested,level=2)
    write(paste0("</",mainTags[irow,2],">"),file=outFile,append=T)
  }
  InportXML:::writeFooter(outFile)

}




