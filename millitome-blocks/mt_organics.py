# MT Python pipeline
# for V14

# 2023-3-5
# allow generics

# check pancreas, does not make blocks!!

# - organs and gender configured in this file
# - collection names and block names reflect organ names & gender
# - added support for all organs
# - delete temp_exports folder when necessary
# - OpenSCAD will not produce file when nothing to export, check if a STL file has been produced before importing

# run in or call from Blender by running "runtest.py"
# - creates, imports, applies bounding boxes and materials
# - materials are added looping through a materials list


import bpy
import subprocess
import os
import shutil

# configuration is here=========================
#  these are passed on to Openscad
genderID        = 2    # 0=female, 1=male, 2=generic (requires organID=0)
organID         = 0    # 0=kidney_l, 1=kidney_r, 2=spleen, 3=pancreas, 4=banana, 5=vb_pancreas

asset_typeID    = 6    # 6 = organblocks, 7 = boxblocks

generic_x       = 40
generic_y       = 60
generic_z       = 30

# block segmentation, how many blocks in x,y,
# x=width, y=length, z=height
count_x=2
count_y=2
count_z=2

# which specific block?
#location_x=2
#location_y=5
#location_z=4

#======this is handled in this script
boundingBoxes   = False     # make bounding boxes?
#========END=========================

#======FUNCTIONS=========
#=====create, import, add bounding boxes and material to single block
def make_block(location_x,location_y,location_z,thisMaterial):
    # derive name IDs from lists
    row = (asciiList[location_x])
    column = str(location_y + 1)
    layer = (romanList[location_z])

    outputFileName = blockName + row + '-' + column + '-' + layer + '.stl'

    # set up commandline for openSCAD
    args = [appName,\
        fileGenerator,\
        "-o",outputFileName,\
        "-D genderID=" + str(genderID),\
        "-D organID=" + str(organID),\
        "-D generic_x=" + str(generic_x),\
        "-D generic_y=" + str(generic_y),\
        "-D generic_z=" + str(generic_z),\
        "-D asset_typeID=" + str(asset_typeID),\
        "-D location_x=" + str(location_x),\
        "-D location_y=" + str(location_y),\
        "-D location_z=" + str(location_z),\
        "-D count_x=" + str(count_x),\
        "-D count_y=" + str(count_y),\
        "-D count_z=" + str(count_z)]
    subprocess.call(args) 

    print(*args)
        
            
    # import the temp file into Blender
    if os.path.exists(workDirectory + outputFolderName + outputFileName):
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
workDirectory       = '/Volumes/Venus/Earth/Projects/SICE/2021/HubMap/Millitome/hra-millitome-generator/millitome-blocks/' # main output folder
mtGeneratorName     = 'MT-Organics.scad' # openscad program code to run
outputFolderName    = 'temp_exports/' # main output folder

# define base name for new collection and block naming
if asset_typeID == 6:
    if boundingBoxes == True:
        collectionBaseName = "boundingboxes_"
        outputTypeName = "bb_"
    else:
        collectionBaseName = "organblocks_"
        outputTypeName = "ob_"
if asset_typeID == 7:
    collectionBaseName = "boxblocks_"
    outputTypeName = "bx_"
if asset_typeID < 6:
    collectionBaseName = "tests_"
    outputTypeName = "test_"


# lookup tables for columns and layers
asciiList = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']  # lookup table for column IDs
romanList = ['I','II','III','IV','V']   # lookup table for layer IDs

# lookup tables for organs
organs = ('kidney_l','kidney_r','spleen','pancreas','banana','vb_pancreas','ovary_l')
generics = ('oval','oval')
genderList = ('f','m','g')
organLists = (organs,organs,generics)
organList = organLists[genderID]

collectionName = genderList[genderID] + '_'\
    + organList[organID] + '_'\
    + collectionBaseName + '_'\
    + str(count_x) + 'x'\
    + str(count_y) + 'x'\
    + str(count_z)

blockName = genderList[genderID] + '_'\
    + organList[organID] + '_'\
    + outputTypeName

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

# check if main export folder exists; delete and create new; existing files could interfere
if os.path.exists(workDirectory + outputFolderName):
    shutil.rmtree(workDirectory + outputFolderName)
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
            print("make_block: " + str(location_x) + " " + str(location_y) + " "  + str(location_z))

            # loop through materials, make sure materials stay within available range
            thisMaterial += 1
            if (thisMaterial == numOfMaterials):
                thisMaterial = 0


# switch back to workDirectory
os.chdir(workDirectory)
