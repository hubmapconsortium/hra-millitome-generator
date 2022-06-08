# Millitome Generator V11

![MT-Generator!](images/MT-Generator.png "MT-Generator")

Implemented in OpenScad 2021.1.<br>

# Folder Contents

<h4>images</h4>
This folder contains images used for documentation. Not required for proper operation of <em>MT-Generator</em>.

<h4>organs</h4>
Contains 24 files in STL format, used by <em>MT-Generator</em> to cut the correct mold shapes. This folder must reside in the same directory from which <em>MT-Generator.scad </em> is launched.<br><br>

There are three STL files for each organ:

Edited, simplified geometry of left female kidney:<br>
<em>f_0_kidney_l.stl</em><br>
![f_0_kidney_l.png!](images/f_0_kidney_l.png "f_0_kidney_l.png")

Model with straight extended top; used to cut bottom molds:<br>
<em>_bf_0_kidney_l.stl</em><br>
![_bf_0_kidney_l.png!](images/_bf_0_kidney_l.png "_bf_0_kidney_l.png")

Model with straight extended bottom; used to cut top molds:<br>
<em>_tf_0_kidney_l.stl</em><br>
![_tf_0_kidney_l.png!](images/_tf_0_kidney_l.png "_tf_0_kidney_l.png")

<h4>MT-Generator.scad</h4>
Program code to be run in Openscad.

# Configuration 

<h3>Customization variables</h3>
<h4>Organ selection</h4>
