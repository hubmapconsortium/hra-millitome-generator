# Millitome Generator

## Function overview

A millitome is a device designed to hold a freshly procured organ and facilitate cutting it into many small tissue blocks for usage in single cell analysis. A millitome has discrete, equally placed cutting grooves in both the x and y directions to guide a carbon steel cutting knife. The millitome is used to produce uniformly sized slices or cubes of tissue material that can be registered to organs from the [CCF 3D Reference Object Library](https://humanatlas.io/3d-reference-library).

Millitome Generator uses modified 3D-models from the HuBMAP organ repository to generate 3D-printable millitomes, delivered as STL files. The exact shape, proportions and dimensions of the generated millitome depend directly on the properties of the organ model used.

---
## What Physical Assets can be created?

### Millitome for 3D print

<p align="center">
  <span>
  <img src="images/MT-render.png" height="300">
  <img src="images/MT-photo.jpg" height="300">
  </span>
</p>
<p align = "center">
  <sub>Fig.1 Millitome for half banana .STL file; physical 3d print</sub>
</p>



### Icebox for laser-cut acrylic
<p align="center">
  <img src="images/Icebox_dxf.png" height="300">
  <img src="images/Icebox_acrylic.jpg" height="300">
</p>
<p align = "center">
  <sub>Fig.2 Left: icebox laser cut sheet; right: physial icebox</sub>
</p>

### Matching CSV lookup file
<p align="center">
  <img src="images/CSV-lookup.png" height="500">
</p>
<p align = "center">
  <sub>Fig.3 Lookup sheet in CSV format</sub>
</p>
 

---
## What Virtual Assets can be created?

### Individual sample block organ segments

<p align="center">
  <img src="images/banana half 3x8x3 organ blocks.png" height="300">
</p>
<p align = "center">
  <sub>Fig.4 Banana half; individual organ sample blocks</sub>
</p>

### Bounding-boxed organ segments

<p align="center">
  <img src="images/banana half 3x8x3 scaled blocks.png" height="300">
</p>
<p align = "center">
  <sub>Fig.5 Banana half; individual bounding boxed blocks</sub>
</p>

---

## Software Tools

- (required) OpenSCAD
- (optional) 3D editor, for pre-and post processing (Cinema 4D, Blender, Maya)
- (optional) Terminal to run BASH script

---
## How to install from github

All required files and folders can be installed by downloading  "millitome-physical" or "millitome-blocks" folder to your local computer.
(file & folder names are subject to change)

### Files and Folders required for Physical Millitomes

- MT-Customizer.scad
- MT-Generator.scad
- MT-Icebox.scad
- MT-Master.scad
- mt-organs.config
- organs (folder)
- mt_export.bash
- create-customized-mt.md
- README.md

### Files and Folders required for Virtual Sample Blocks

- MT-Pipeline.blend
- MT-Organics.scad
- mt_organics.py
- mt-organs.config
- organs (folder)
- README.md




---
## old stuff below here
---


Along with the 3d-printed millitome the researcher needs a lookup document. This comes in the form of a spreadsheet file, where data about the individual sample blocks can be recorded. This lookup file is provided in CSV format.

In order to match millitomes to specific organs, a 3d modeling application such as Blender, Maya or Cinema 4D is used to simplify the organ model. This modified organ is then used in <a href="https://openscad.org">Openscad</a> to generate the matching STL file.

Unlike regular 3D modelling software, which relies on a visual point-and-click interface, OpenScad is fully code based. That means, the 3D geometry is created after the user executes the text-based code. This makes it easy to create variations of a 3D object (e.g., millitomes for different organ sizes or tissue block sizes) by changing relevant parameters in the code.

The user adjusts a handfull of variables, such as organ type, gender and block size, then selects which part of the millitome (top, bottom) should be generated. OpenScad will build the requested geometry, which can then be exported as an STL file for 3D-printing.

To create a matching lookup file in CSV format for a specific millitome, any spreadsheet application can be used, or even a text editor.

## <a href="https://github.com/hubmapconsortium/hra-millitome-generator/tree/main/OpenScad%20Code/V10">Millitome Generator V10</a>

V10 was programmed to export one single millitome STL after setting the required properties directly in the Openscad code. This is practical to produce a handful of STL files or to troubleshoot errors in the code or parameters. But complete millitome sets for several organs can require 100 or more individual STL files. It is very time-consuming to tweak the parameters for every millitome variation, and then export each STL file manually.

## <a href="https://github.com/hubmapconsortium/hra-millitome-generator/tree/main/OpenScad%20Code/V11">Millitome Generator V11</a>

Just like V10, V11 can be used to export individual STL files. But now millitome generation can also be initiated through the command line in a terminal app. A bash terminal script automates the creation of (at the moment) 144 individual STL files; all named consistently, created into matching folders, each folder compressed into a ZIP file.

While the terminal script is running Openscad, it also generates a correctly configured and named CSV lookup file for each STL file. CSV files are also saved into the output folder and included in the generated ZIP file.
