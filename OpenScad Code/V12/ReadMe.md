# Millitome Generator Suite V12

2022-11-1

## Table of Contents
- [Overview](#toc_overview)
  - [Millitome for 3d print](#toc_mt_print)
  - [Millitome block array](#toc_mt_blockarray)
  - [Millitome sample blocks](#toc_mt_sampleblocks)
  - [Millitome organ](#toc_mt_organ)
  - [Millitome organ bisection](#toc_mt_organ_bisection)
  - [Millitome block array bisection](#toc_mt_fullblock_bisection)
  - [Millitome Icebox laser cut sheet](#toc_icebox_cutsheet)
  - [Millitome Icebox 3d model](#toc_icebox_model)
- [Files Overview](#toc_files)
  - [Master Apps](#toc_master_apps)
    - [MT-Customizer](#toc_customizer_scad)
    - [MT-Master](#toc_master_scad)
  - [Generator Apps](#toc_generator_apps)
    - [MT-Generator](#toc_generator_scad)
    - [MT-Icebox](#toc_icebox_scad)
  - [Helper Files](#toc_helper_file) 
    - [mt-organs.config](#toc_organs_config) 
    - [mt-export.bash](#toc_bash_script) 
  - [Open properties code block](#toc_open_properties)

---

# <a id="toc_overview"></a> Overview

[Constucting A Millitome SOP](https://docs.google.com/document/d/1x7tr9LrJfKZmED83aAj_K9FMvmjbxZ883Km93CsrgUM/edit#heading=h.cd53uti4az4)

[Using Millitomes SOP](https://docs.google.com/document/d/1Gdpph-Rx3EkNxe2y1rvhUSNMkFkt6be7DdIL_IeGe-g/edit#heading=h.cd53uti4az4)

The following millitome-related assets can be created from the Openscad pipeline, directly from [MT-Customizer](#customizer-scad) or from [MT-Master](#master-scad) through a terminal script. 

Note: In this document the word milltiome is sometimes abbreviated to MT.


## <a id="toc_mt_print"></a> Millitome for 3d print

Produces 3d-printable millitomes, based on user-defined properties, exported to .STL file. This file can be printed on a 3d-printer directly or used as virtual asset.

<p align="center">
  <span>
  <img src="images/MT-render.png" height="300">
  <img src="images/MT-photo.jpg" height="300">
  </span>
</p>
<p align = "center">
  <sub>Fig.1 Millitome for half banana .STL file; physical 3d print</sub>
</p>



## <a id="toc_mt_blockarray"></a> Millitome block array

Sample block array used in the MT generation process. This block array corresponds to the column/row matrix, in this case columns A-C and rows 1-8 on this specific millitome. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Block_array.png" height="300">
</p>
<p align = "center">
  <sub>Fig.2 Millitome block array; sample blocks for visual application</sub>
</p>



## <a id="toc_mt_sampleblocks"></a> Millitome sample blocks

This is created by intersecting the block array with the organ model geometry. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Sample_blocks.png" height="300">
</p>
<p align = "center">
  <sub>Fig.3 Millitome sample blocks for visual application; intersection of block array & sample organ</sub>
</p>


  
## <a id="toc_mt_organ"></a> Millitome organ

The organ model is used to form the mold in all of the assets. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Banana_sample.png" height="300">
</p>
<p align = "center">
  <sub>Fig.4 Model of the half banana used to form the mold in the millitome</sub>
</p>


## <a id="toc_mt_fullblock_bisection"></a> Millitome block array bisection

This array contains a complete set of blocks for the complete organ. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Full_Block_array.png" height="300">
</p>
<p align = "center">
  <sub>Fig.5 Full block array, bisected into two layers</sub>
</p>


## <a id="toc_mt_organ_bisection"></a> Millitome organ bisection

The full organ model with all blocks, bisected into top and bottom section. Exported to .STL file. Virtual asset.

<p align="center">
  <img src="images/Banana_bisection.png" height="300">
</p>
<p align = "center">
  <sub>Fig.6 Full organ model sliced, diced and bisected into two layers</sub>
</p>


## <a id="toc_icebox_cutsheet"></a> Millitome Icebox laser cut sheet

The physical icebox is used to store organ samples in a compartmentalized container. The container layout matches the grid layout of the millitome and provides the same column/row coordinate system. Openscad produces a ready-to-use laser cut file in .DXF format.

<p align="center">
  <img src="images/Icebox_dxf.png" height="300">
  <img src="images/Icebox_acrylic.jpg" height="300">
</p>
<p align = "center">
  <sub>Fig.7 Left: icebox laser cut sheet; right: physial icebox</sub>
</p>



## <a id="toc_icebox_model"></a> Millitome Icebox 3d model

A 3d model of the icebox. Used as virtual asset but could be 3d printed (although it is not very practical, as it takes a lot of filament and time). Exported to .STL file.

<p align="center">
  <img src="images/Banana_Icebox.png" height="300">
</p>
<p align = "center">
  <sub>Fig.8 3D model of icebox</sub>
</p>

---

# <a id="toc_files"></a> Files Overview

MT_Generator V12 requires the following files/folders in the same folder:
- [MT-Customizer.scad](#toc_customizer_scad)
- [MT-Master.scad](#toc_master_scad)
- [MT-Generator.scad](#toc_generator_scad)
- [MT-Icebox.scad](#toc_icebox_scad)
- [mt-organs.config](#toc_organs_config)
- [mt_export.bash](#toc_export_bash)
- [organs (folder)](#toc_organs)

In addition the following files/folders are created at runtime:
- [exports (folder)](#toc_exports)
- [_logfile.txt](#toc_logfile)



## <a id="toc_master_apps"></a> Master Apps

Asset properties are set/selected in [MT-Customizer](#customizer-scad) or [MT-Master](#master-scad), which then runs the appropriate sub-module ([MT-Generator](#generator-scad), [MT-Icebox](#icebox-scad)). For testing and debugging sub-modules can also be launched directly, in which case the [Open Properties Code Block](#toc_open_properties) has to be un-commented. However, while the [Open Properties Code Block](#toc_open_properties) is un-commented, it will NOT run properly when called from [MT-Customizer](#customizer-scad) or [MT-Master](#master-scad), because the properties in [MT-Generator](#generator-scad)/[MT-Icebox](#icebox-scad) will override properties set in the calling app. 


## <a id="toc_customizer_scad"></a> MT-Customizer


<p align="center">
  <img src="images/mt-customizer-1.png" width="200">
</p>
<p align = "center">
  <sub>Fig.9 Openscad Customizer for MT production</sub>
</p>

This program allows the configuration of all properties necessary to create one Millitome-related asset at a time. The "product" selector at the bottom determines if a Millitome, an Icebox or a Organ-Bisection is produced. 

With some combinations of properties not all settings are relevant. For example if "blocktype" is set to "uniform" "blocksize" is used to determine the X and Y dimensions of a sample block; in that case "block xsize", "block ysize" and "blocks x" and "blocks y" are ignored.

The following list shows properties available through the [Open Properties Code Block](#toc_open_properties) and exposed for user interaction in the customier interface:

#### **gender**
1. female
2. male

#### **organ**
1. kidney_l
2. kidney_r
3. spleen
4. pancreas
5. banana (experimental)
6. vb_pancreas (experimental)

#### **laterality**
1. bottom
2. top
3. bottom no ID (bottom half, text markers surpressed)

#### **organ scale**
1. large (115%)
2. medium (100%)
3. small (85%)

#### **blocktype**
1. uniform (i.e. 20x20mm)
2. userXY (i.e. 15x20mm, 35x5mm, etc)
3. blockCount (set number of blocks in X and Y directions)

#### **block size** (for uniform blocktype only)
1. 10
2. 15
3. 20

#### **block xsize** (X size for userXY blocktype only)
1. 10
2. 15
3. 20

#### **block ysize** (Y size for userXY blocktype only)
1. 10
2. 15
3. 20

#### **blocks x** (X number of blocks; blockcount blocktype only)
1. integer

#### **blocks y** (Y number of blocks; blockcount blocktype only)
1. integer

#### **product**
1. MT-physical
2. MT-block array
3. MT-sample blocks
4. MT-organ
5. MT-full block array
6. MT-full organ bisecttion
7. IB-physical
8. IB-virtual


To produce .STL/.DXF output from OpenScad, the object must be rendered (F6) and saved to the appropriate file format.  

[MT-Customizer.scad](https://MT-Customizer.scad)


## <a id="toc_master_scad"></a> MT-Master

Where [MT-Customizer](#customizer-scad) gives the user access to the [Open Properties Code Block](#toc_open_properties) through a simple interface, [MT-Master](#master-scad) serves as a remote control interface for [MT-Generator](#generator-scad) and [MT-Icebox](#icebox-scad). When [MT-Master](#master-scad) is executed by itself, it will call [MT-Generator](#generator-scad) or [MT-Icebox](#icebox-scad) with the properties defined in the [Open Properties Code Block](#toc_open_properties) and produce the requested output.

However, it is designed to serve as a property passthrough between [mt-export](#bash-script) and [MT-Generator](#generator-scad). 

[mt-export](#bash-script) will call [MT-Master](#master-scad) repeatedly, as required, to produce millitome assets automatically. To do this, it needs to pass commandline parameters into the OpenScad environment. The names of these parameters must match pre-defined variables in OpenScad; passed-in parameters will override the pre-defined values in the [Open Properties Code Block](#toc_open_properties) of [MT-Master](#master-scad).  

## <a id="toc_generator_apps"></a> Generator Apps

The generation of graphics assets takes place in one of the two generator apps. Both, [MT-Generator](#generator-scad) and [MT-Icebox](#icebox-scad), are OpenScad code files which get called from one of the master apps. In the regular MT production chain no code needs to be accessed here. For debugging either one can be ran as stand-alone app, after un-commenting their [Open Properties Code Block](#toc_open_properties).

## <a id="toc_generator_scad"></a> MT-Generator

This program is called automatically from [MT-Customizer](#customizer-scad) or [MT-Master](#master-scad) if needed. It receives all required properties from the calling master app. 

[MT-Generator](#generator-scad) produces all 3d assets which are created through interaction with the organ model (i.e. Millitome, block arrays, etc.)

[MT-Generator](#generator-scad) can run as stand-alone program in Openscad but the [Open Properties Code Block](#toc_open_properties) must be uncommented to prevent an error.

## <a id="toc_icebox_scad"></a> MT-Icebox

This program is called automatically from [MT-Customizer](#customizer-scad) or [MT-Master](#master-scad) if needed. It receives all required properties from the calling master app. 

[MT-Icebox](#icebox-scad) produces 3d assets related to the icebox, a optional sample storage container. It can create to types of outout: A cut file for laser cutting the physical parts for the box from acrylic sheet material in .DXF format, and an .STL file of the complete assembled box.

[MT-Icebox](#icebox-scad) can run as stand-alone program in Openscad but the [Open Properties Code Block](#toc_open_properties) must be uncommented to prevent an error.


## <a id="toc_helper_files"></a> Helper Files

## <a id="toc_organs_config"></a> mt-organs.config

List of organs MT-Generator knows about. The dimensions and filenames for the organ models are required for proper operation. 3d organ models are kept in a folder named "organs".

## <a id="toc_bash_script"></a> mt-export.bash

Terminal script to produce bulk millitome assets. This has not yet been updated to work with MT-Generator V12.

## <a id="toc_open_properties"></a> Open properties code block



```// Open Properties Block=========
//  these variables must be defined here and are carried into MT-Generator & MT-Icebox
//  in case this is run from a bash script the properties are over-ridden by the parameters passed in

productID       = 6;    // 0=millitome_physical, 1=millitome_blockarray, 2=millitome_sampleblocks, 3=millitome_organ, 4=full_array_bisection, 5=organ_bisection, 6=icebox_physical, 7=icebox_virtual

genderID        = 0;    // 0=female, 1=male, needs to be integer selector
organID         = 5;    // index for list lookup
lateralityID    = 0;    // 0=bottom, 1=top, 2=bypass MT creation      
organ_scaleID   = 1;    // 0=large,1=medium,2=small                    

typeID          = 0;    // 0=fixed block size, 1=user block size, 2=user block count

block_size      = 20 ;  // used for type 0, uniform x/y block size for cubes

block_xsize     = 10;   // used for type 1, different x/y block size
block_ysize     = 20;

blocks_x        = 7;    // used for type 2, number of blocks along x, used for calculated block_size
blocks_y        = 14;   // number of blocks along y

asset_typeID    = 5;    // 0=physical MT, 1=virtual block array, 2=virtual block/organ cut, 3=virtual organ model, 4=blockfull_bisection, 5=organ_bisection, 

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY

//===============================
```









