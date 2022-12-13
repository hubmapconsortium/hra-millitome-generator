# MT Python pipeline
# for V13
# adapted from mt_organics.bash

# 2022-12-13

import subprocess
import os

appName         = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'

#workDirectory  = '/Users/pmkienle/Desktop/CNS IoT/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/'    # main output folder
#workDirectory   = os.getcwd() + '/'     # terminal needs to point to correct DIR
workDirectory   = os.path.realpath(os.path.dirname(__file__)) + '/' # get location where this script lives
mtGeneratorName     = 'MT-Organics.scad'    # openscad program code to run
outputFolderName    = 'block_exports/'       # main output folder

# build file names
fileGenerator   = workDirectory + mtGeneratorName

# configuration is here=========================
asset_typeID    = 6      # 6 = organblocks, 7 = boxblocks

# block segmentation
count_x=3
count_y=8
count_z=3

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
if asset_typeID == 7:
    subfolderType = "box_blocks"

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

            fileOutputName = 'OrganBlock_' + row + '-' + column + '-' + layer + '.stl'

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
            print([args])


# switch back to workDirectory
os.chdir(workDirectory)
