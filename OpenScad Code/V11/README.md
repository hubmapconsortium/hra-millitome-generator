# Millitome Generator V11

![MT-Generator!](images/MT-Generator.png "MT-Generator")

Implemented in OpenScad 2021.1. Developed on MacOS 12.4. Terminal procedures and commands are Mac-specific.
Proper installation requires these items in the same directory location:<br>
<em>organs</em> (folder)<br>
<em>MT-Generator.scad</em> (program code to run in Openscad)<br>
<em>mt_export.bash</em> (bash shell script)

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

<h4>mt_export.bash</h4>
Terminal script file to run <em>MT-Generator</em> automatically from bash terminal.

# Operating Instructions 

<em>MT_Generator.scad</em> is a text based code file. When double-clicked, it will launch the Openscad 3d graphics application and display the code, a text console and a preview of the model produced by the code. Rendering the current model will produce the actual 3d geometry which can then be exported as an STL file. While the <em>MT_Generator</em> code uses several discreet 3d objects, such as boxes, letters and others, to assemble the requested millitome, the exported STL file contains only one single 3d object.

<h3>Customization Properties</h3>

In the <em>MT_Generator.scad</em> code properties for specific millitomes are determined by a short list of parameters. Each of these parameters can be modifed and Openscad will show a preview of the resulting millitome after saving the code file or initiating a refresh of the preview. All the properties are defined as integers.

Here are the properties:

<b>gender</b><br>
0=female, 1=male<br>

<b>organ_id</b><br>
0=left kidney, 1=right kidney, 2=spleen, 3=pancreas<br>

block_size      = 10 ;  // used for type 1, uniform x/y block size for cubes
organ_scale     = 0;    // 0=large,1=medium,2=small
laterality      = 0;    // 0 = bottom, 1 = top, 2 = bypass MT creation      
                
output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY
