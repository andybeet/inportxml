#'Copy Master_Template.xlsx to computer
#'
#'The Master_Template.xlsx file that is bundled with the \code{inportxml} package gets installed (by default) with your package.
#'This is often in a location the typical user never looks. \code{copy_master_to_wd} allows the user to copy this file automatically
#'without having to know where it was installed.
#'
#'@examples
#'#'simply run the function to copy the file to your working directory
#'
#'@export

copy_master_to_wd <- function() {

  fileName <- "Master_Template.xlsx"
  outPath <- paste0(getwd(),"/",fileName)
  numPaths <- length(.libPaths())

  for (ipath in 1:numPaths) {
    inPath <- paste0(.libPaths()[ipath],"/inportXML/",fileName)
    result <- file.copy(from = inPath, to = outPath, overwrite = FALSE)
    if (result == TRUE) {
      return(message("The file ",fileName," was sucessfully copied to your working directory"))
    }
  }

  warning("The file (Master_Template.xlsx) FAILED TO COPY. Maybe the file already exists in you working directory!")


}
