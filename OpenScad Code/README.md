# Folder contents

## [V10](https://github.com/hubmapconsortium/hra-millitome-generator/tree/main/OpenScad%20Code/V10)

Version 10 is the first fully working version of <a href="https://openscad.org">Openscad</a> code to produce millitome STL files. Through configuration variables at the top of the code, it can cover a wide variety of organ types, sizes and millitome layouts. However, it can only output a single millitome per run, requiring the user to manually configure, render and export each individual file, while saving with the correct file names.

### [images](https://github.com/hubmapconsortium/hra-millitome-generator/tree/main/OpenScad%20Code/V10/images)
This folder contains images used for documentation. Not required for proper operation of <em>Millitome Generator V10</em>.

### organs
Contains 24 files in STL format, used by *Millitome Generator V10* to cut the correct mold shapes. This folder must reside in the same directory from which *Millitome Generator V10.scad* is launched.

### Millitome Generator V10.scad
Program code to be run in Openscad.

## [V11](https://github.com/hubmapconsortium/hra-millitome-generator/tree/main/OpenScad%20Code/V11)

Version 11 is based on the same millitome creation engine as version 10. While it can be used as a stand-alone application running in Openscad, it can now also be launched from the computer's terminal and be configured from the command line. This allows to run the application from a *bash shell script* to output many differently configured millitomes, properly named, in one single operation. In addition it will also create matching lookup files in CSV format. To facilitate command line usage the Openscad code file was renamed to *MT-Generator.scad*.

Running the complete current export procedure will create 144 files each of STL and CSV files. Depending on the hardware expect a duration of 3-4 hours.

### images
This folder contains images used for documentation. Not required for proper operation of *MT-Generator*.

### organs
Contents are identical to V10.

### MT-Generator.scad
Program code to be run in Openscad.

### mt_export.bash
This bash terminal script will create all STL and CSV files as configured by calling *MT-Generator.scad* with the properly formed command line.
