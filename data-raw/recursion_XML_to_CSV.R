recursion_XML_to_CSV <- function(outFile,children,igap) {
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

    recursion_XML_to_CSV(outFile,newChildren,igap+1)
  }

}
