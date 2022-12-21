# MT Python pipeline
# for V13
# adapted from mt_organics.bash
# 
# this script runs in Blender

# 2022-12-14

#-----------------------------------
# ---------this section calls OpenSCAD and produces STL segments

import subprocess
import os



appName         = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'

workDirectory  = '/Volumes/Venus/Earth/Projects/SICE/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/'    # main output folder
#workDirectory   = os.getcwd() + '/'     # terminal needs to point to correct DIR
#workDirectory   = os.path.realpath(os.path.dirname(__file__)) + '/' # get location where this script lives
mtGeneratorName     = 'MT-Organics.scad'    # openscad program code to run
outputFolderName    = 'block_exports/'       # main output folder

# build file names
fileGenerator   = workDirectory + mtGeneratorName

# configuration is here=========================
asset_typeID    = 7      # 6 = organblocks, 7 = boxblocks

# block segmentation
count_x=2
count_y=3
count_z=2

# location_x=1
# location_y=2
# location_z=1
#========END==========================

asciiList = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']  # lookup table for column IDs
romanList = ['I','II','III','IV','V']   # lookup table for layer IDs

# check if main export folder exists; if not, create it
if not os.path.exists(workDirectory + outputFolderName):
    os.makedirs(workDirectory + outputFolderName)
    
    
if asset_typeID == 6:
    subfolderType = "organ_blocks"
    outputTypeName = "organblock_"
if asset_typeID == 7:
    subfolderType = "box_blocks"
    outputTypeName = "boxblock_"

outputSubfolder = subfolderType + '_' + str(count_x) + 'x' + str(count_y) + 'x' + str(count_z) + '/'


if not os.path.exists(workDirectory + outputFolderName + outputSubfolder):
    os.makedirs(workDirectory + outputFolderName + outputSubfolder)
    
# switch to output folder
os.chdir(workDirectory + outputFolderName + outputSubfolder)

# row, column, layer are only for filename
for location_x in range(count_x):
    row = (asciiList[location_x])

    for location_y in range(count_y):
        column = str(location_y + 1)

        for location_z in range(count_z):
            layer = (romanList[location_z])

            fileOutputName = outputTypeName + row + '-' + column + '-' + layer + '.stl'

            args = [appName,\
                fileGenerator,\
                "-o",fileOutputName,\
                "-D asset_typeID=" + str(asset_typeID),\
                "-D location_x=" + str(location_x),\
                "-D location_y=" + str(location_y),\
                "-D location_z=" + str(location_z),\
                "-D count_x=" + str(count_x),\
                "-D count_y=" + str(count_y),\
                "-D count_z=" + str(count_z)]
            subprocess.call(args) 
            #print([args])
            
            #bpy.ops.import_mesh.stl(filepath="C://Users//Dom//Documents//DomCorp.//mymodel.stl", filter_glob="*.stl",  files=[{"name":"mymodel.stl", "name":"mymodel.stl"}], directory="C://Users//Dom//Documents//DomCorp.")

# switch back to workDirectory
os.chdir(workDirectory)




#-----------------------------------
# ---------this section processes STL items in specific folders

# import files from folder test
# 2022-12-14

import bpy
import os
import glob
from pathlib import Path

# Model directory
model_dir = '/Volumes/Venus/Earth/Projects/SICE/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/block_exports/box_blocks_2x3x2/'

collectionName = 'organ_blocks_2x3x2'
myCollection = bpy.data.collections.new(collectionName)
bpy.context.scene.collection.children.link(myCollection)
bpy.ops.collection.create (name=collectionName)

defaultCollection = bpy.context.scene.collection

model_files = glob.glob(os.path.join(model_dir, "*.stl"))

# import stl
for f in model_files:
    bpy.ops.import_mesh.stl(filepath=f)

    objs = bpy.context.selected_objects
    obj = objs[0]
    
    defaultCollection.objects.unlink(obj)
    myCollection.objects.link(obj)
     
        
print("done!")

#-----------------------------------
# ---------this section processes STL items in specific folders

modifiers["Subdivision"].levels



#======
#=====create, import and add material to single block

# derive name IDs from lists
row = (asciiList[location_x])
column = str(location_y + 1)
layer = (romanList[location_z])

outputFileName = outputTypeName + row + '-' + column + '-' + layer + '.stl'

# set up commandline for openSCAD
args = [appName,\
    fileGenerator,\
    "-o",outputFileName,\
    "-D asset_typeID=" + str(asset_typeID),\
    "-D location_x=" + str(location_x),\
    "-D location_y=" + str(location_y),\
    "-D location_z=" + str(location_z),\
    "-D count_x=" + str(count_x),\
    "-D count_y=" + str(count_y),\
    "-D count_z=" + str(count_z)]
subprocess.call(args) 
    
        
# import the temp file into Blender
bpy.ops.import_mesh.stl(filepath=workDirectory + outputFolderName + outputFileName)
# address first object in Scene Collection
objs = bpy.context.selected_objects
obj = objs[0]
# move it to myCollection
defaultCollection.objects.unlink(obj)
myCollection.objects.link(obj)     
        
# ??? confirm active object???   
bpy.context.view_layer.objects.active = obj

# add material
thisMaterial=0
mat = bpy.data.materials[thisMaterial]
obj.data.materials.append(mat)

#==============================
