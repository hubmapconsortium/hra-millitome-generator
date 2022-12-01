import bpy

# 2022-12-1
# applies materials
# select all organblocks to be treated

numOfMaterials = len(bpy.data.materials)
thisMaterial = 0

for ob in bpy.context.selected_objects:
    bpy.context.view_layer.objects.active = ob
   
    # add material
    mat = bpy.data.materials[thisMaterial]
    ob.data.materials.append(mat)
    
    # make sure materials stay within available range
    thisMaterial += 1
    if (thisMaterial == numOfMaterials):
        thisMaterial = 0
