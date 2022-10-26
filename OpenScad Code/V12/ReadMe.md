# Millitome Generator Suite V12

2022-10-26

## Table of Contents
* [Overview](#toc_overview)
* [Millitome for 3d print](#toc_mt_print)
* [Millitome block array](#toc_mt_blockarray)
* [Millitome sample blocks](#toc_mt_sampleblocks)
* [Millitome organ](#toc_mt_organ)
* [Millitome organ bisection](#toc_mt_bisection)




<hr>


## <a id="toc_overview"></a> Overview

The following assets can be created from the Openscad pipeline when operated from both [MT-Customizer](#customizer-scad) and [MT-Master](#master-scad) through a terminal script.

<hr>

## <a id="toc_mt_print"></a> Millitome for 3d print

Produces 3d-printable millitomes, based on user-defined properties, exported to .STL file. This file can be printed on a 3d-printer directly or used as virtual asset.

<p align="center">
  <span>
  <img src="images/MT-render.png" height="300">
  <img src="images/MT-photo.jpg" height="300">
  </span>
</p>
<p align = "center">
  <sub>Fig.1 Millitome for banana half .STL file and 3d print</sub>
</p>

<hr>

## <a id="toc_mt_blockarray"></a> Millitome block array

Sample block array used in the MT generation process. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Block_array.png" height="300">
</p>
<p align = "center">
  <sub>Fig.2 Millitome block array; sample blocks for visual application</sub>
</p>

<hr>

## <a id="toc_mt_sampleblocks"></a> Millitome sample blocks

Created by intersecting block array with the organ model geometry. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Sample_blocks.png" height="300">
</p>
<p align = "center">
  <sub>Fig.3 Millitome sample blocks for visual application; intersection of block array & sample organ</sub>
</p>

<hr>.
  
## <a id="mt_organ"></a> Millitome organ

The organ model is used to form the mold in all of the assets. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Banana_sample.png" height="300">
</p>
<p align = "center">
  <sub>Fig.4 Model of the half banana used to form the modl in the millitome</sub>
</p>

<hr>

## <a id="mt_bisection"></a> Millitome organ bisection

The full organ model with all blocks, bisected into top and bottom section. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Banana_bisection.png" height="300">
</p>
<p align = "center">
  <sub>Fig.5 Model of the half banana used to form the modl in the millitome</sub>
</p>

<hr>


### Millitome Icebox laser cut sheet (.DXF)

The physical icebox is used to store physical organ samples in a compartmentalized container. The container layout matches the MT layout and provides a column/row coordinate system. Openscad produces a ready-to-use laser cut file in .DXF format.

<p align="center">
  <img src="images/Icebox_dxf.png" height="300">
</p>
<p align = "center">
  <sub>Fig.6 Cut sheet to produce the sample block storage box on a laser cutter</sub>
</p>

### Millitome Icebox 3d model (.STL)

A 3d model of the icebox. Could be 3d printed or used as virtual asset.

<p align="center">
  <img src="images/Banana_Icebox.png" height="300">
</p>
<p align = "center">
  <sub>Fig.7 Cut sheet to produce the sample block storage box on a laser cutter</sub>
</p>

<hr>

## Files (code)

### Calling/Master apps

Asset properties are set/selected in [MT-Customizer](#customizer-scad) or [MT-Master](#master-scad), which then runs the appropriate sub-module ([MT-Generator](#generator-scad),[MT-Icebox](#icebox-scad)). Sub-modules can also be launched directly (for testing and debugging), in which case the open properties block has to be un-commented. If the open properties block is un-commented, it will NOT run properly when called from MT-Customizer or MT-Master because the properties in MT-Generator/MT-Icebox will override properties set in the calling app. 

### <a id="customizer-scad"></a> MT-Customizer


<p align="center">
  <img src="images/mt-customizer-1.png" width="200">
</p>
<p align = "center">
  <sub>Fig.8 Openscad Customizer for MT production</sub>
</p>

This program allows configuration of all properties necessary to create one Millitome-related asset at a time.
The "product" selector determines if a Millitome, an Icebox or a Organ-Bisection is produced. The following list shows properties available through the open properties block:

#### gender
1. female
2. male

#### organ
1. kidney_l
2. kidney_r
3. spleen
4. pancreas
5. banana (experimental)
6. vb_pancreas (experimental)

#### laterality
1. bottom
2. top
3. bottom no ID (bottom half, text markers surpressed)

#### organ scale
1. large (115%)
2. medium (100%)
3. small (85%)

#### blocktype
1. uniform (i.e. 20x20mm)
2. userXY (i.e. 15x20mm, 35x5mm, etc)
3. blockCount (set number of blocks in X and Y directions)

#### block size (for uniform blocktype)
1. 10
2. 15
3. 20

#### block xsize (X size for userXY blocktype)
1. 10
2. 15
3. 20

#### block ysize (Y size for userXY blocktype)
1. 10
2. 15
3. 20

#### blocks x (X number of blocks blockcount blocktype)
1. integer

#### blocks y (Y number of blocks blockcount blocktype)
1. integer

#### product
1. MT-physical
2. MT-block array
3. MT-sample blocks
4. MT-organ
5. IB-physical
6. IB-virtual
7. MT_Organ_Bisect

To produce .STL/.DXF output the object must be rendered (F6) and saved to the appropriate file format.  


### <a id="master-scad"></a> MT-Master

Where [MT-Customizer](#customizer-scad) gives the user access to the open properties block through a simple interface, MT-Master serves as a remote control for [MT-Generator](#generator-scad) and [MT-Icebox](#icebox-scad). When MT-Master is executed by itself, it will call [MT-Generator](#generator-scad) with the properties defined in the open properties block and produce the requested out.

It is designed to serve as a property passthrough between [mt-export](#bash-script) and [MT-Generator](#generator-scad). 

[mt-export](#bash-script) will call MT-Master repeatedly, as required, to produce millitome assets automatically. To do this, it needs to pass commandline parameters into the OpenScad environment. The names of these parameters must match pre-defined variables in OpenScad; that means the parameters passed in will override the pre-defined values.  

### <a id="generator-scad"></a> MT-Generator

This program is run automatically from MT-Customizer if needed. It receives all needed properties from customizer. 
MT-Generator can run as stand-alone program in Openscad but clearly marked property variables in the header must be uncommented to prevent an error.

### <a id="icebox-scad"></a> MT-Icebox

Same as for MT-Generator.

### mt-organs.config

List of organs MT-Generator knows about. The dimensions and filenames for the organ models are required for proper operation. 3d organ models are kept in a folder named "organs".

### <a id="bash-script"></a> mt-export.bash

Terminal script to produce bulk millitome assets. This has not yet been updated to work with MT-Generator V12.







