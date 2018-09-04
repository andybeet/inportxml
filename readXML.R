#reads in inport sample xml file and parses it too create an excel file for data input

locationOfTHisFile <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(locationOfTHisFile)

readXML <- function() {
  library(xml2)
  outFile <- "InportXML-template.csv"
  outAttributes <- "XMLattributes.csv"
  write(paste0("level",",","tag",",","value",",","instructions"),file=outFile)
  
  doc <- read_xml("inport-xml-sample.xml")
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
    recursion(outFile,children,1)
  }
  outText <- as.data.frame(outText)
  names(outText) <- c("tag","attribute","value")
  write.csv(outText,file=outAttributes,row.names = FALSE)
  return(outText)
  
  
}
recursion <- function(outFile,children,igap) {
  #  numCommas <- toString(rep(" ",igap+1))
  numCommas <- igap+1
  for (ichild in 1:length(children)){ 
    if (length(children[ichild]) == 0) {next}
    newChildren <- xml_children(children[ichild])
    if (length(newChildren) == 0) {
      # need to write out instructions and required
      instruction <- xml_text(children[ichild])
      if (grepl("REQUIRED",instruction)) {
        flag <- "REQUIRED"
      } else {
        flag <- "OPT"
      }
      # replace all commas with semi colon so excel import behaves
      instruction <- gsub(",",";",instruction)
     # print(paste0(numCommas,",",xml_name(children[ichild]),",",flag,",",instruction))
      write(paste0(numCommas,",",xml_name(children[ichild]),",",flag,",",instruction),file=outFile,append="TRUE")
    } else {
      write(paste0(numCommas,",",xml_name(children[ichild])),file=outFile,append="TRUE")
    }
    
    recursion(outFile,newChildren,igap+1)
  }
  
}

