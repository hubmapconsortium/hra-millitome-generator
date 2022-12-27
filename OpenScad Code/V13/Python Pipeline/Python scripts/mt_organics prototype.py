# MT Python pipeline
# for V13 - prototype for concept testing

# 2022-12-27

# run in or call from Blender by running "runtest.py"
# - creates, imports, applies bounding boxes and materials
# - materials are added looping through a materials list
# - organ type, gender, size, etc. are used as defined in "MT-Organics.scad"

import bpy
import subprocess
import os

# configuration is here=========================
asset_typeID    = 6         # 6 = organblocks, 7 = boxblocks
boundingBoxes   = False     # make bounding boxes?

# block segmentation, how many blocks in x,y,
# x=width, y=length, z=height
count_x=3
count_y=6
count_z=3

# which specific block?
#location_x=2
#location_y=5
#location_z=4
#========END=========================

#======FUNCTIONS=========
#=====create, import, add bounding boxes and material to single block
def make_block(location_x,location_y,location_z,thisMaterial):
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

    # only need for organ blocks, bypass for boxes
    if (asset_typeID == 6) and (boundingBoxes == True):
        # create bounding box using geometry node
        # first add a node
        bpy.ops.object.modifier_add(type='NODES')
        # then pick specific GeometryNode by name (modify the modifier)
        bpy.data.objects[obj.name].modifiers["GeometryNodes"].node_group = bpy.data.node_groups["bounding_box"]
        # then apply
        bpy.ops.object.modifier_apply(modifier="GeometryNodes")

    # add material
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

# init materials
numOfMaterials = len(bpy.data.materials)
thisMaterial = 0

# check if main export folder exists; if not, create it
if not os.path.exists(workDirectory + outputFolderName):
    os.makedirs(workDirectory + outputFolderName)
    
# switch to output folder - /temp_exports
# may not be necessary if we use predefined string
os.chdir(workDirectory + outputFolderName)
  
# row, column, layer are only for filename
for location_x in range(count_x):
    row = (asciiList[location_x])

    for location_y in range(count_y):
        column = str(location_y + 1)

        for location_z in range(count_z):
            layer = (romanList[location_z])

            make_block(location_x,location_y,location_z,thisMaterial)

            # loop through materials, make sure materials stay within available range
            thisMaterial += 1
            if (thisMaterial == numOfMaterials):
                thisMaterial = 0


# switch back to workDirectory
os.chdir(workDirectory)
