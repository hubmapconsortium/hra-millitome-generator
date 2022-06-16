# Millitome Generator V11

![MT-Generator!](images/MT-Generator.png "MT-Generator")

## Table of Contents

- [Requirements](#requirements)
- [Folder Contents](#folder-contents)
- [Operating Instructions](#operating-instructions)
  - [Customization Properties](#customization-properties)
  - [Millitome Generation from Openscad](#millitome-generation-from-openscad)
  - [Millitome Generation using Terminal Commands](#millitome-generation-using-terminal-commands)
  - [Millitome Generation using Terminal Script](#millitome-generation-using-terminal-script)
    - [Running the Terminal Script](#running-the-terminal-script)
    - [Closer Look at the Terminal Script](#closer-look-at-the-terminal-script)

# Requirements

Implemented in [OpenScad 2021.01](https://openscad.org). Developed on MacOS 12.4. Terminal procedures and commands are Mac-specific.
Proper installation requires these items in the same directory location:

<b>organs</b> (folder)<br>
<b>MT-Generator.scad</b> (program code to run in Openscad)<br>
<b>mt_export.bash</b> (bash shell script)

In addition the [Openscad](https://openscad.org) application must be installed on the computer and configured for [command line access](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment).

# Folder Contents

#### images
This folder contains images used for documentation. Not required for proper operation of <em>MT-Generator</em>.

#### organs
Contains 24 files in STL format, used by <em>MT-Generator</em> to cut the correct mold shapes. This folder must reside in the same directory from which <em>MT-Generator.scad </em> is launched.

There are three STL files for each organ:

Edited, simplified geometry of left female kidney:<br>
[<em>f_0_kidney_l.stl</em>](https://github.com/hubmapconsortium/hra-millitome-generator/blob/7fc45ea5e9f6eb0297473e38da1884ab637b68ce/OpenScad%20Code/V11/organs/f_0_kidney_l.stl)<br>
![f_0_kidney_l.png!](images/f_0_kidney_l.png "f_0_kidney_l.png")

Model with straight extended top; used to cut bottom molds:<br>
[<em>_bf_0_kidney_l.stl</em>](https://github.com/hubmapconsortium/hra-millitome-generator/blob/646edafee4bd8995ceebeda2937633f550995781/OpenScad%20Code/V11/organs/_bf_0_kidney_l.stl)<br>
![_bf_0_kidney_l.png!](images/_bf_0_kidney_l.png "_bf_0_kidney_l.png")

Model with straight extended bottom; used to cut top molds:<br>
[<em>_tf_0_kidney_l.stl</em>](https://github.com/hubmapconsortium/hra-millitome-generator/blob/646edafee4bd8995ceebeda2937633f550995781/OpenScad%20Code/V11/organs/_tf_0_kidney_l.stl)<br>
![_tf_0_kidney_l.png!](images/_tf_0_kidney_l.png "_tf_0_kidney_l.png")

#### [MT-Generator.scad](https://github.com/hubmapconsortium/hra-millitome-generator/blob/d9b2529c8e3caacc66053ad367b275fbb6c62047/OpenScad%20Code/V11/MT-Generator.scad)
Program code to be run in Openscad.

#### [mt_export.bash](https://github.com/hubmapconsortium/hra-millitome-generator/blob/d9b2529c8e3caacc66053ad367b275fbb6c62047/OpenScad%20Code/V11/mt_export.bash)
Terminal script file to run <em>MT-Generator</em> automatically from bash terminal.

# Operating Instructions 

<em>MT_Generator.scad</em> is a text based code file. When double-clicked, it will launch the Openscad 3d graphics application and display the code, a text console and a preview of the model produced by the code. Rendering the current model will produce the actual 3d geometry, which can then be exported as an STL file. While the <em>MT_Generator</em> code internally uses many discreet 3d objects, such as boxes, letters and the simplified organ model in order to assemble the requested millitome, the exported STL file contains only one single 3d object.

## Customization Properties

Properties for specific millitomes are determined by a short list of parameters at the top of the <em>MT_Generator.scad</em> code. Each of these parameters can be modifed and Openscad will show a preview of the resulting millitome after saving the code file or initiating a refresh of the preview. All properties are defined as integers:

<b>gender</b><br>
0=female, 1=male<br>

<b>organ_id</b><br>
0=left kidney, 1=right kidney, 2=spleen, 3=pancreas<br>

<b>block_size</b><br>
10, 15, 20 (size of one sample block in millimeters)<br>

<b>organ_scale</b><br>
0=large (115%), 1=medium (100%), 2=small (85%) (to account for size variations in organ samples)<br>

<b>laterality</b><br>
0=bottom, 1=top<br>    

## Millitome Generation from Openscad

In the Openscad code editor navigate to the lines shown. Edit the parameters as required. <em>Save</em> the modified code and see updated preview. <em>Render</em> to create exportable geometry. When satisfied <em>Export STL</em>. 

![MT-Generator-Properties!](images/MT-Generator-properties.png "MT-Generator Properties")

## Millitome Generation using Terminal Commands

[This webpage](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment)  contains information about how to set up command line access of Openscad on Windows and MacOS.
All following instructions assume Openscad can be accessed in the terminal by typing "openscad" followed by the <em>Return</em> key at the command prompt. 
  
To test:
Launch the terminal app. At the prompt type:<br>
<em>openscad</em><br>

If everything is properly set up, the Openscad application will launch without loading a file.

![openscad-from-bash!](images/bash-open-openscad.jpg "openscad from bash")

In order to make Openscad export a millitome of a specific type the command line has to include information about the Openscad source code file, the name of the STL file to be created, and properties of the requested millitome:

<em>openscad MT-Generator.scad -o MT-output.stl -D laterality=0 -D gender=0 -D organ_id=1 -D organ_scale=1 -D block_size=20</em>

This command line will create an output file, "MT-output.stl", in the working directory. This millitome will be the "bottom" for a "female" "kidney right" scaled to 100% with a block size of 20mm. The "-D" option forces Openscad to override a named variable defined in the code file.

![test-millitome!](images/bash-test-mt.jpg "test millitome")



## Millitome Generation using Terminal Script

Both previous methods of millitome generation produce one single STL file per run. One full set of millitomes for a specific organ and sample block size contains six individual STL files. This is to account for organ size variations and laterality. With four distinct organs and two genders the total number of STL files comes 144! Depending on the configuration properties of the millitome it takes about one to five minutes for Openscad to render and save one STL file. Every STL file must be saved using a very specific filename and sorted into a folder hierarchy. It is a perfect task for a script.

### Running the Terminal Script

Make sure the terminal's working directory is set correctly and you have the required user priviliges. These three items must be present in the working directory:

<em>MT-Generator.scad</em><br>
<em>mt_export.bash</em><br>
<em>organs</em><br>

![working-directory!](images/terminal-1.png "working directory")

At the prompt enter this command:<br>
<em>bash mt_export.bash</em><br>

The script will create an <em>exports</em> folder and a subfolder for the first millitome set. A file called <em>_logfile.txt</em> will appear in the working directory. This logfile is used by the script to parse console output. 

While the script is running, text output in the terminal console will show switching between working directories. 
![directory-switching!](images/terminal-2.png "directory switching")

Every time the script has created all six STL files and matching CSV files for a specific millitome the folder iz compressed into a ZIP file and the source folder is deleted.

![zip-compressing!](images/terminal-3.png "zip compressing")

In total 24 ZIP files will be created inside <em>exports</em>. Each ZIP file contains six STL files and six CSV files. Expect this to take several hours. The script can be stopped from the terminal by pressing <em>Control-z</em>.

### Closer Look at the Terminal Script


openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/VH_${gender}_${organ}_${blocksize}_${scale}_${laterality}.stl -D laterality=${lateralityID} -D gender=${genderID} -D organ_id=${organID} -D organ_scale=${scaleID} -D block_size=${blocksize} -D output_flag=${outputFlag}

