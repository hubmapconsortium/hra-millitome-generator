import os
import bpy
#exec(compile(open("importFileTest.py","r").read(),"importFileTest.py","exec"))
#bpy.app.debug_wm = True

#/Volumes/Venus/Earth/Projects/SICE/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/Python Pipeline/Python scripts
filename = os.path.join(os.path.dirname(bpy.data.filepath), "import_test.py")
exec(compile(open(filename).read(), filename, 'exec'))