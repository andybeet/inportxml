# Development of template XML files for InPort


![gitleaks](https://github.com/andybeet/inportxml/workflows/gitleaks/badge.svg)


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

`remotes::install_github("andybeet/inportxml",build_vignettes = T)`

Browse vignette for usage instructions


`browseVignettes(package="inportxml")`


#### Create XML from template file

First copy the XLSX template file that is bundled with the package to your working directory:

`copy_master_to_wd()`

Then create Item and Entity XML files using the `create_inportxml` function as in the following example:

`create_inportxml(inFile = "full/path/to/template", outPath = "path/to/output/directory", outFile = "DataIdentifier.xml")`

The output of this function is two XML documents, with filenames "master_" and "entity_" concatenated with the outFile variable. For
example, the XML file outputs from the above code chunk would be "master_DataIdentifier.xml" and "entity_DataIdentifier.xml".

## Contact

| [andybeet](https://github.com/andybeet)        
| ----------------------------------------------------------------------------------------------- 
| [![](https://avatars1.githubusercontent.com/u/22455149?s=100&v=4)](https://github.com/andybeet) | 



#### Legal disclaimer

*This repository is a scientific product and is not official
communication of the National Oceanic and Atmospheric Administration, or
the United States Department of Commerce. All NOAA GitHub project code
is provided on an ‘as is’ basis and the user assumes responsibility for
its use. Any claims against the Department of Commerce or Department of
Commerce bureaus stemming from the use of this GitHub project will be
governed by all applicable Federal law. Any reference to specific
commercial products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of Commerce.
The Department of Commerce seal and logo, or the seal and logo of a DOC
bureau, shall not be used in any manner to imply endorsement of any
commercial product or activity by DOC or the United States Government.*
