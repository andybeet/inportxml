#reads in inport sample xml file and parses it to create an excel file for data input
# This sample xml file was obtained from Inport website.

source(here::here("data-raw","recursion_XML_to_CSV.R"))

readXML <- function() {
  library(xml2)

  outFile <- here::here("data-raw","InportXML-template.csv")
  outAttributes <- here::here("data-raw","XMLattributes.csv")
  write(paste0("level",",","tag",",","value",",","instructions"),file=outFile)

  doc <- read_xml(here::here("data-raw","inport-xml-sample.xml"))
  mainNodes <- xml_children(doc)
  numMainNodes <- length(mainNodes)
  outText <- NULL
  for (imain in 1:numMainNodes) {
    write(paste0("1,",xml_name(mainNodes[imain])),file=outFile,append="TRUE")
    attributes <- xml_attrs(mainNodes[imain])
    if(length(attributes[[1]]) == 0){
      # no attrubtes for this tag
    } else if (length(attributes[[1]]) == 1) {
      outText <- rbind(outText,cbind(xml_name(mainNodes[imain]),names(attributes[[1]]),as.character(attributes[[1]])))
    } else {
      stop("Not coded for. XML template changed")
    }

    children <- xml_children(mainNodes[imain])
    recursion_XML_to_CSV(outFile,children,1)
  }
  outText <- as.data.frame(outText)
  names(outText) <- c("tag","attribute","value")
  write.csv(outText,file=outAttributes,row.names = FALSE)
  return(outText)


}

