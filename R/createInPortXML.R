#' Create all XML files for direct upload of metadata to InPort.
#'
#' This function calls both \code{\link{createItemXML}} and \code{\link{createEntityXML}} functions to
#' generate two separate XML files. As InPort is currently configured, the two XML files
#' must be uploaded in separate steps, and both are necessary for successful upload.
#'
#'
#' @param inFile The full path to the metadata template (e.g. "~/Master_Template.xlsx").
#' @param outFile An identifying name for output files (e.g. "CHL_metadata_V1.xml".)
#' @return Two XML files; one for the Item XML and one for Entity XML. The filenames
#' will be concatenated with "master_" and "entity_" in a given directory.
#'
#' @examples
#' #Be sure that inFile refers to the full path of the metadata template
#' createInPortXML(inFile = "~/Master_Template.xlsx", outFile = "X_metadata_V1.xml")
#'
#' @export

createInPortXML <- function(inFile,outFile) {

  masterXML_filename <- paste0("master_",outFile)
  entityXML_filename <- paste0("entity_",outFile)


  createItemXML(inFile,outFile=masterXML_filename)
  createEntityXML(inFile,outFile=entityXML_filename)


}


