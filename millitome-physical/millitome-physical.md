# **Millitome Asset Production inside Blender**

2022/12/27

<img title="a title" alt="Alt text" src="Documentation/GitHub/doc-001.png">

## **Overview**
[V12 of the Millitome Generation suite](https://github.com/hubmapconsortium/hra-millitome-generator/blob/0630ed0476f09b0d3d0bd3792b234a3199058ba4/OpenScad%20Code/V12/ReadMe.md) is based on a bash terminal script to control creation of 3d assets. This is a fairly robust workflow and works reliably across MacOS, Windows and Linux installations. 

There are two significant shortcomings in that workflow:
- bash script language is not easy to write and modify
- 3d assets consisting of individual organ blocks, produced by running MT-Organics.scad for each block, need to be combined into a single 3d file. Depending on what is required, bounding boxes must be created and materials applied. V12 requires significant manual postprocessing for that in Blender.

Many procedures in Blender can be scriped via Python. Python can also run OpenSCAD scripts to generate the 3d assets, import them directly into Blender and perform required modifications. Using a Python scripting environment within Blender bypasses the cryptic bash script and offers greatly improved expandability. Other advantages are better error tracking and fewer software tools.

<img title="a title" alt="Alt text" src="Documentation/GitHub/doc-002.png">

## **Project Status**

The current version of the Python script is limited to defining the following properties for the produced items:
- organblocks/boxblocks (asset_typeID)
- bounding boxes for organ blocks? (boundingBoxes) 
- block segmentation matrix (count_x,y,z)

Organ type and other properties are defined in the OpenSCAD code, which produces the actual 3d entities: [MT-Organics.scad](https://github.com/hubmapconsortium/hra-millitome-generator/blob/a20d1cfa0c8b9dd2479ac4e709ab286fd30092bf/OpenScad%20Code/V13/MT-Organics.scad)

## **File Setup**

A working setup requires these four items in the same folder:
- organs (folder with organ geometries)
- MT-Pipeline.blend (Blender work file )
- mt-organs.config (configuration file for OpenSCAD)
- MT-Organics.scad (OpenSCAD code producing the millitome)

## **Running it**

## **The Python script**

Talk about paths.

## **Improvements**