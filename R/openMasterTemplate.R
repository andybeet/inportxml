#' Open the master InPort template from session
#'
#' Calling this function will open the master InPort XLSX template that is packaged with InPortXML.
#' Only Windows systems are currently supported.
#'
#' @param path_to_excel Enter the full file path to Microsoft Excel on your Windows machine.
#'
#' @export
#'
#' @examples
#' openMasterTemplate(path_to_excel = "C:/Program Files (x86)/Microsoft Office/Office15/Excel.exe")
#'


openMasterTemplate <- function(path_to_excel){

  #Path for writing out batch script
  path <- paste(.libPaths(),'/InportXML',sep="")

  #Excel directory
  excel <- paste0('"',path_to_excel,'"')

  #Template directory
  template <- paste('"',.libPaths(),'/InportXML/Master_Template.XLSX','"',sep="")

  #replace ticks
  excel <- gsub("/", "\\\\", excel)
  template <- gsub("/", "\\\\", template)

  out <- paste(excel, template)
  write(out, file = file.path(path,"run_template.bat"))

  #Execute shell script
  shell.exec(file.path(path,"run_template.bat"))
}


