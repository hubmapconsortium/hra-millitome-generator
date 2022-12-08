# MT Python pipeline
# for V13
# adapted from mt_organics.bash

# 2022-12-8

import subprocess
import os

appName         = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'

#workDirectory  = '/Users/pmkienle/Desktop/CNS IoT/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/'    # main output folder
workDirectory   = os.getcwd() + '/'     # directory from where this script runs
mtGenerator     = 'MT-Organics.scad'    # openscad program code to run
outputFolder    = 'block_exports/'       # main output folder

# build file names
fileGenerator   = workDirectory + mtGenerator

# configuration is here=========================
asset_typeID    = 6      # 6 = organblocks, 7 = boxblocks

# block segmentation
count_x=2
count_y=2
count_z=2

# location_x=1
# location_y=2
# location_z=1
#========END==========================

asciiList = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']  # lookup table for column IDs
romanList = ['I','II','III','IV','V']   # lookup table for layer IDs

# check if main export folder exists; if not, create it
if not os.path.exists(workDirectory + outputFolder):
    os.makedirs(workDirectory + outputFolder)

if asset_typeID == 6:
    subfolderType = "organ_blocks"
if asset_typeID == 7:
    subfolderType = "box_blocks"

outputSubfolder = subfolderType + '_' + str(count_x) + 'x' + str(count_y) + 'x' + str(count_z) + '/'
print (outputSubfolder)

if not os.path.exists(workDirectory + outputFolder + outputSubfolder):
    os.makedirs(workDirectory + outputFolder + outputSubfolder)


# switch to output folder
os.chdir(outputFolder + outputSubfolder)


# row, column, layer are only for filename
for location_x in range(count_x):
    row = (asciiList[location_x])


    for location_y in range(count_y):
        column = str(location_y + 1)

        for location_z in range(count_z):
            layer = (romanList[location_z])

            fileOutput = 'OrganBlock_' + row + '-' + column + '-' + layer + '.stl'

            args = [appName, fileGenerator, "-o " + fileOutput, \
                "-D asset_typeID=" + str(asset_typeID), \
                "-D location_x=" + str(location_x), \
                "-D location_y=" + str(location_y), \
                "-D location_z=" + str(location_z), \
                "-D count_x=" + str(count_x), \
                "-D count-y=" + str(count_y), \
                "-D count_z=" + str(count_z)]
            subprocess.call(args) 
            print([args])

args = ['/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD',\
    '/Users/pmkienle/Desktop/CNS IoT/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/MT-Organics.scad',\
    '-o OrganBlock_C-7-III.stl',\
    '-D asset_typeID=6 -D location_x=2 -D location_y=6 -D location_z=2 -D count_x=3 -D count-y=8 -D count_z=3']

subprocess.call(args)
print([args])

# switch back to workDirectory
os.chdir(workDirectory)

# openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/OrganBlock_${rowString}-${columnString}-${layerString}.stl \
# -D asset_typeID=${asset_typeID} \
# -D location_x=${location_x} \
# -D location_y=${location_y} \
# -D location_z=${location_z} \
# -D count_x=${count_x} \
# -D count_y=${count_y} \
# -D count_z=${count_z}
