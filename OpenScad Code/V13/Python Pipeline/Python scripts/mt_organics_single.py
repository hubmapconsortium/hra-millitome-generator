# exports one single specific block
# 2022-12-21
import bpy
import subprocess
import os

# configuration is here=========================
asset_typeID    = 6      # 6 = organblocks, 7 = boxblocks

# block segmentation, how many blocks in x,y,
# x=width, y=length, z=height
count_x=4
count_y=8
count_z=6

# which specific block?
location_x=2
location_y=5
location_z=4
#========END=========================

#======FUNCTIONS=========
#=====create, import and add material to single block
def make_block(location_x,location_y,location_z):
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


#======global defs===================
appName             = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD' # path to OpenSCAD
workDirectory       = '/Volumes/Venus/Earth/Projects/SICE/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/' # main output folder
mtGeneratorName     = 'MT-Organics.scad' # openscad program code to run
outputFolderName    = 'temp_exports/' # main output folder

# define base name for new collection and block naming
if asset_typeID == 6:
    collectionBaseName = "organblocks_"
    outputTypeName = "organblock_"
if asset_typeID == 7:
    collectionBaseName = "boxblocks_"
    outputTypeName = "boxblock_"

# lookup tables for columns and layers
asciiList = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']  # lookup table for column IDs
romanList = ['I','II','III','IV','V']   # lookup table for layer IDs

collectionName = collectionBaseName + '_' + str(count_x) + 'x' + str(count_y) + 'x' + str(count_z)

# makes a new collection named collectionName
myCollection = bpy.data.collections.new(collectionName)
bpy.context.scene.collection.children.link(myCollection)
bpy.ops.collection.create (name=collectionName)

# stuff gets imported into 'Scene Collection'
defaultCollection = bpy.context.scene.collection  # scene collection

# build file name of MT_<generator> to be used
fileGenerator   = workDirectory + mtGeneratorName

# check if main export folder exists; if not, create it
if not os.path.exists(workDirectory + outputFolderName):
    os.makedirs(workDirectory + outputFolderName)
    
# switch to output folder - /temp_exports
# may not be necessary if we use predefined string
os.chdir(workDirectory + outputFolderName)

make_block(location_x,location_y,location_z)
          
# switch back to workDirectory
# just to be save!!!
os.chdir(workDirectory)

