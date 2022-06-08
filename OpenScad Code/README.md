# Folder contents

<h3>V10</h3>

Version 10 is the first fully working version of Openscad code to produce millitome STL files. Through configuration variables at the top of the code, it can cover a wide variety of organ types, sizes and millitome layouts.

<h4>images</h4>
This folder contains images used for documentation. Not required for proper operation of <em>Millitome Generato V10</em>.

<h4>organ</h4>
Contains 24 files in STL format, used by <em>Millitome Generator V10</em> to cut the correct mold shapes. This folder must reside in the same directory from which <em>Millitome Generator V10.scad </em> is launched.<br><br>

There are three STL files for each organ:

Edited, simplified geometry of left female kidney.
![f_0_kidney_l.png!](V10/images/f_0_kidney_l.png "f_0_kidney_l.png")

Model with straight extended top; used to cut bottom molds.
![_bf_0_kidney_l.png!](V10/images/_bf_0_kidney_l.png "_bf_0_kidney_l.png")

Model with straight extended bottom; used to cut top molds.
![_tf_0_kidney_l.png!](V10/images/_tf_0_kidney_l.png "_tf_0_kidney_l.png")

<h3>V11</h3>

Version 11 is based on the same millitome creation engine as version 10. While it can still be used as a standalone application running in Openscad it can now be launched from the computer's Terminal application, and be configured from the command line. A bash script allows to output many differently configured millitomes, properly named, in one signle operation. In addition it will also create lookup files in CSV format. 
