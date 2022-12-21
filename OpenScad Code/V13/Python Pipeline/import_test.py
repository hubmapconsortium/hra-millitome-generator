
import os
import glob

print("I am import test")
# Model directory
model_dir = '/Users/pmkienle/Desktop/CNS IoT/2021/HubMap/Millitome/hra-millitome-generator/OpenScad Code/V13/block_exports_done/box_blocks_3x8x3'

# Specify OBJ files
# Specify OBJ files
model_files = os.path.join(model_dir, "*.stl")
#model_files = glob.glob(model_dir + "*.stl")
print(model_files)