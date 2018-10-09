source("R/createXML.R")
source("R/createEntityXML.R")

inputFile <- "Data_Set_test.xlsx"
outputFile <- "InportXML.xml"

create_Inport_XML <- function(inFile=inputFile,outFile=outputFile) {
  
  masterXML_filename <- paste0("master_",outFile)
  entityXML_filename <- paste0("entity_",outFile)
  

  createXML(inFile,outFile=masterXML_filename)
  createEntityXML(inFile,outFile=entityXML_filename)
  
  
}

create_Inport_XML(inFile = inputFile, outFile = outputFile)
