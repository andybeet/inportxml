

inputFile <- "Master_Template.xlsx"
outputFile <- "InportXML.xml"

create_Inport_XML <- function(inFile=inputFile,outFile=outputFile) {
  
  masterXML_filename <- paste0("master_",outFile)
  entityXML_filename <- paste0("entity_",outFile)
  

  createXML(inFile,outFile=masterXML_filename)
  createEntityXML(inFile,outFile=entityXML_filename)
  
  
}
