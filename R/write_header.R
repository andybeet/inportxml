write_header <- function(outFile){
  write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>",file=outFile,append=T)
  write("<!-- Last Update: InPort Release 4.0.0.0 -->",file=outFile,append=T)
  write("<inport-metadata version=\"1.31\">",file=outFile,append=T)

}
