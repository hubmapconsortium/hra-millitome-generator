import bpy

# 2022-12-1
# apply bounding boxes and materials
# we need PeterBB GeometryNode to do the bounding boxes
# select all organblocks to be treated

numOfMaterials = len(bpy.data.materials)
thisMaterial = 0

for ob in bpy.context.selected_objects:
    bpy.context.view_layer.objects.active = ob
     
    # first add a node
    bpy.ops.object.modifier_add(type='NODES')
    # then pick specific GeometryNode by name (modify the modifier)
    bpy.data.objects[ob.name].modifiers["GeometryNodes"].node_group =  bpy.data.node_groups["PeterBB"]
    # then apply; now we can add material
    bpy.ops.object.modifier_apply(modifier="GeometryNodes")
        
    # add material
    mat = bpy.data.materials[thisMaterial]
    ob.data.materials.append(mat)
    
    # make sure materials stay within available range
    thisMaterial += 1
    if (thisMaterial == numOfMaterials):
        thisMaterial = 0
