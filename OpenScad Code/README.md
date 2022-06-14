# Folder contents

# V10

Version 10 is the first fully working version of <a href="https://openscad.org">Openscad</a> code to produce millitome STL files. Through configuration variables at the top of the code, it can cover a wide variety of organ types, sizes and millitome layouts. However, it can only output a single millitome per run, requiring the user to manually configure, render and export each individual file, while typing in the correct file names.

<h4>images</h4>
This folder contains images used for documentation. Not required for proper operation of <em>Millitome Generator V10</em>.

<h4>organs</h4>
Contains 24 files in STL format, used by <em>Millitome Generator V10</em> to cut the correct mold shapes. This folder must reside in the same directory from which <em>Millitome Generator V10.scad </em> is launched.

<h4>Millitome Generator V10.scad</h4>
Program code to be run in Openscad.

# V11

Version 11 is based on the same millitome creation engine as version 10. While it can be used as a stand-alone application running in Openscad, it can now also be launched from the computer's terminal application and be configured from the command line. This allows to run the application from a <em>bash shell script</em> to output many differently configured millitomes, properly named, in one single operation. In addition it will also create matching lookup files in CSV format. To facilitate command line usage the Openscad code file was renamed to <em>MT-Generator.scad</em>.

Currently running the complete export procedure will create 144 files each of STL and CSV files. Depending on the hardware expect a duration of 3-4 hours.

<h4>images</h4>
This folder contains images used for documentation. Not required for proper operation of <em>MT-Generator</em>.

<h4>organs</h4>
Contents are identical to V10.

<h4>MT-Generator.scad</h4>
Program code to be run in Openscad.

<h4>mt_export.bash</h4>
This bash terminal script will create all STL and CSV files as configured, by calling <em>MT-Generator.scad</em> with the properly formed command line. It must reside in the same directory as <em>MT-Generator.scad</em>. To invoke the script navigate the terminal to the folder containg <em>MT-Generator.scad</em> and enter this command: <em>bash mt_export.bash</em><br><br>

The terminal script will create a folder called <em>exports</em> to hold all exported files. Further, poperly named subfolders are created inside <em>exports</em>, into which all STL and CSV files for a respective organ are saved. After each subfolder is filled the terminal script will compress it into a ZIP file, ready to be delivered.


