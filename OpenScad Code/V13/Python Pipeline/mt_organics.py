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
    
    