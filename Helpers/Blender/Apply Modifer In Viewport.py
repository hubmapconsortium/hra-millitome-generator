import bpy

for ob in bpy.context.selected_objects:
    bpy.context.view_layer.objects.active = ob
    for name in [m.name for m in ob.modifiers]:
        modifier = ob.modifiers[name]
        if modifier.show_viewport:
            bpy.ops.object.modifier_apply( modifier = name )