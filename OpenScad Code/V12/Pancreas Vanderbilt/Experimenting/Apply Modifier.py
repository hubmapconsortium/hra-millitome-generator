import bpy

for ob in bpy.context.selected_objects:
    bpy.context.view_layer.objects.active = ob
     
    bpy.ops.object.modifier_add(type='NODES')
    bpy.data.objects[ob.name].modifiers["GeometryNodes"].node_group =  bpy.data.node_groups["PeterBB"]
