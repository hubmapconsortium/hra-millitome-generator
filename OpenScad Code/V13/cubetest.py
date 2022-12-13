# test calling OpenSCAD from Python with parameters

# -o output file, needs full path and enclosed in quotes, otherwise .stl extension is not detected
# -D variable overrides can be single string (if numbers only?)


import subprocess
import os

args = ['/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD',\
    '/Users/pmkienle/Desktop/CNS IoT/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/cubetest.scad',\
    "-o", "/Users/pmkienle/Desktop/CNS IoT/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/cubtest.stl",\
    "-D x=80",\
    "-D y=200",\
    "-D z=20"]

subprocess.call(args)
print([args])