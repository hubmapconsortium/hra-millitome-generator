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

laterality [bottom,top,bottom no ID]

organ scale [large,medium,small]

blocktype [uniform,userXY,blockCount]

block size [10,15,20]

block xsize [10,15,20]

block ysize [10,15,20]

blocks x (int)

blocks y (int)

product [MT-physical,MT-block array,MT-sample blocks,MT-organ,IB-physical,IB-virtual]

### Millitome physical for 3d print (.STL)

Produces 3d-printable millitomes, based on properties, exported to .STL file. This file can be printed on 3d-printer directly or used as virtual asset.

asset_typeID = 0

### Millitome block array (.STL)

Sample block array used in MT generation process. Used for UI and other virtual things.

asset_typeID = 1

### Millitome sample blocks (.STL)

The actual sample blocks. Created by intersecting block array with the organ model geometry. Used for virtual.

asset_typeID = 2

### Millitome organ (.STL)

The organ model. Used for virtual.

asset_typeID = 3

### Millitome Icebox laser cut sheet (.DXF)

The physical icebox is used to store physical organ samples in a compartmentalized container. The container layout matches the MT layout and provides a column/row coordinate system. Openscad produces a ready-to-use laser cut file in .DXF format.

asset_typeID = 0

### Millitome Icebox 3d model (.STL)

A 3d model of the icebox. Could be 3d printed ot used as virtual asset.

asset_typeID = 1


## Files

### MT-Customizer.scad



### MT-Generator.scad


### MT-Icebox.scad


### mt-organs.config


### mt-export.bash







