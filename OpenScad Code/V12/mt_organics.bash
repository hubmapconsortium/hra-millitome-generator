#!/bin/bash

# V1 - works with V12 of MT_organics
# Peter Kienle, CNS
#  2022-11-3

# produces individual segments using MT_Organics.scad


# run in terminal:
# - navigate terminal to folder, this script resides in (V12) using 'cd'
# - at prompt$ 'bash mt_organics.bash'
# - creates output folders if not already present; will replace content

consoleOutput="_logfile.txt"        # console gets logged to this temp file to be extracted for .csv files
outputFolder="block_exports"              # main output folder
mtGenerator="MT-Organics.scad"        # openscad program code; V12 uses MT-Generator/MT-Icebox controlled from MT-Master
outputFlag=2                        # 2=column/row inserts only (use this), openscad console output: 0=everything, 1=full inserts

# check if main export folder exists; if not, create it
if [ ! -d ${outputFolder} ]
then
    mkdir ${outputFolder}
fi

# IDs used to configure Openscad output. Must match 'exposed properties' in MT_Generator
# this is the task list! Assets in these lists are created are created.
# genderIDs=(0)
# organIDs=(5)
# blocksizeIDs=(2)    #====only if blocktypeID=0
# blockxsizeIDs=(1)   #====only if blocktypeID=1
# blockysizeIDs=(1)   #====only if blocktypeID=1
# lateralityIDs=(0)
# scaleIDs=(1)
# productIDs=(0 1)  # can't use ID 3 alone, no col/row info to console, CSV creation will fail

# blocktypeID=2       # 0=uniform, 1=userXY, 2=blockcount !! ID=1 is not covered yet!!
# blocksx=2           #=====only if blocktypeID=2
# blocksy=25          #=====only if blocktypeID=2

# block segmentation
count_x=2
count_y=25
count_z=2

# location_x=1
# location_y=2
# location_z=1

# Used to assemble filenames for .STL & .CSV files. Lists must match MT_Generator & ID lists (above)
# genderList=(F M)
# genderNamesList=(Female Male)
# organList=(Kidney_L Kidney_R Spleen Pancreas Banana VB_Pancreas)
# organList2=("Kidney left" "Kidney right" Spleen Pancreas Banana VB_Pancreas)
# blockTypeList=("uniform" "userXY" "blockcount")
# blocksizeList=(10 15 20)
# blockxsizeList=(10 15 20)
# blockysizeList=(10 15 20)
# lateralityList=(Bottom Top BottomOnly)
# scaleList=(Large Medium Small)
# productList=(Millitome Block_array Sample_blocks Organ IceboxDXF IceboxSTL)

outputSubfolder=Blocks_${count_x}x${count_y}x${count_z}
cd $outputFolder    # create it in outputFolder
            if [ ! -d ${outputSubfolder} ]
            then
                mkdir ${outputSubfolder}
            fi
            cd - #change directory back to work directory


for (( location_x=0; location_x < count_x; location_x++ )); do

    for (( location_y=0; location_y < count_y; location_y++ )) do

        for (( location_z=0; location_z < count_z; location_z++ )) do

            #runs openscad program, properly configured for blockcount version, blocktypeID=2
            openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/Block_${location_x}x${location_y}x${location_z}.stl \
            -D location_x=${location_x} \
            -D location_y=${location_y} \
            -D location_z=${location_z} \
            -D count_x=${count_x} \
            -D count_y=${count_y} \
            -D count_z=${count_z}

            echo ${outputFolder}/${outputSubfolder}/Block_${location_x}x${location_y}x${location_z}.stl

        done

    done

done

