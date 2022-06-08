# Folder contents

# V10

Version 10 is the first fully working version of Openscad code to produce millitome STL files. Through configuration variables at the top of the code, it can cover a wide variety of organ types, sizes and millitome layouts. However, it can only output a single millitome per run, requiring the user to manually configure, render and export each individual file, while typing in the correct file names.

<h4>images</h4>
This folder contains images used for documentation. Not required for proper operation of <em>Millitome Generator V10</em>.

<h4>organs</h4>
Contains 24 files in STL format, used by <em>Millitome Generator V10</em> to cut the correct mold shapes. This folder must reside in the same directory from which <em>Millitome Generator V10.scad </em> is launched.

<h4>Millitome Generator V10.scad</h4>
Program code to be run in Openscad.

# V11

Version 11 is based on the same millitome creation engine as version 10. While it can still be used as a standalone application running in Openscad, it can now be launched from the computer's Terminal application and be configured from the command line. This allows to run the application from a <em>bash shell script</em> to output many differently configured millitomes, properly named, in one single operation. In addition it will also create lookup files in CSV format. To facilitate commandline usage the Openscad code was renamed to <em>MT-Generator.scad</em>.

<h4>images</h4>
This folder contains images used for documentation. Not required for proper operation of <em>MT-Generator</em>.

<h4>organs</h4>
Contents are identical to V10.

<h4>MT-Generator.scad</h4>
Program code to be run in Openscad.
