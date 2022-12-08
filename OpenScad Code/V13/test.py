

#import os
#os.system("open /Applications/OpenSCAD.app")

fileName = 'MT-Organics.scad'
# appName = 'OpenSCAD.app/Contents/MacOS/OpenSCAD'
appName = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'

import subprocess
args = [appName, fileName, "-o export1.stl"]
subprocess.call(args) 
