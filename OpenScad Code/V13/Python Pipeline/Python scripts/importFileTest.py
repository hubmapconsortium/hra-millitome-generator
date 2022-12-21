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
