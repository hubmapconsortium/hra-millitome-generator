# Millitome Asset Production inside Blender

## Overview
[V12 of the Millitome Generation suite](https://github.com/hubmapconsortium/hra-millitome-generator/blob/0630ed0476f09b0d3d0bd3792b234a3199058ba4/OpenScad%20Code/V12/ReadMe.md) is based on a bash terminal script to control creation of 3d assets. This is a fairly robust workflow and works reliably across MacOS, Windows and Linux installations. 

There are two significant shortcomings in that workflow:
- bash script language is not easy to write and modify
- 3d assets consisting of individual organ blocks, produced by running MT-Organics.scad for each block, need to be combined into a single 3d file. Depending on what is required, bounding boxes must be created and materials applied. V12 requires significant manual postprocessing for that in Blender.

Many procedures in Blender can be scriped via Python. Python can also run OpenSCAD scripts to generate the 3d assets, import them directly into Blender and perform required modifications. Using a Python scripting environment within Blender bypasses the cryptic bash script and offers greatly improved expandability. Other advantages are better error tracking fewer software tools.



