# Millitome Generator Suite V12

2022-9-20

## strategies

can we do more scripting from external?

what can be done with FreeCAD Openscad plugin?

all virtual and physical 3d assets can be created in Openscad, using MT-Customizer; this works well for single or very low count MT creation. How can we do CSV creation? Parameters of a MT to be created accessible from Openscad code? From exported .json?

## Tasks

These assets are created from Openscad pipeline. Asset properties are set/selected from MT-Customizer, which then runs the appropriate sub-module (MT-Generator, MT-Icebox). Sub-modules can also be launched directly, in which case properties have to modified in the property variables.

The following properties are accessible from MT-Customizer:

gender [female,male]

organ [kidney_l,kidney_r,spleen,pancreas,banana]

laterality

organ scale

blocktype

block size

block xsize

block ysize

blocks x

blocks y

product

### Millitome for 3d print

Produces 3d-printable millitomes, based on properties, exported to .STL file. This file can be printed on 3d-printer directly.












