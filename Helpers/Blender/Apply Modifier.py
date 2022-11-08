import bpy

print ("hello1")
for ob in bpy.context.selected_objects:
    bpy.context.view_layer.objects.active = ob
    for name in [m.name for m in ob.modifiers]:
        logging.info ("hello")
        bpy.ops.object.modifier_apply (modifier = name )