# Development of template XML files for InPort

We aim to develop a simple framework to facilitate easy upload of metadata to the NMFS metadata warehousing site InPort.
This package is designed to turn a template spreadsheet (XLSX) into two InPort compatible XML files (Item and Entity XML). If
the template is filled out correctly, the resulting XML outputs will score 100% on the InPort metadata grading rubric. 

Edit: 100% score based on Wave 2 requirements.

Benefits:

1.  Reduce duplication of effort in entering data (Data collector into a spreadsheet, then data entry into Inport)
2.  Reduce need to rely on Inport GUI
3.  Reproducability of metadata for importing into alternativeime databases (ERDAPP)

## Usage

#### Installation

`remotes::install_github("andybeet/InportXML",build_vignettes = T)`

Browse vignette for usage instructions


`browseVignettes(package="InportXML")`


#### Create XML from template file

First copy the XLSX template file that is bundled with the package to your working directory:

`copy_master_to_wd()`

Then create Item and Entity XML files using the `createInPortXML` function as in the following example:

`createInPortXML(inFile = "full/path/to/template", outPath = "path/to/output/directory", outFile = "DataIdentifier.xml")`

The output of this function is two XML documents, with filenames "master_" and "entity_" concatenated with the outFile variable. For
example, the XML file outputs from the above code chunk would be "master_DataIdentifier.xml" and "entity_DataIdentifier.xml".
