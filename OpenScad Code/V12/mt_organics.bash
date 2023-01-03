#!/bin/bash

# V2 - works with V12 of MT_organics
# Peter Kienle, CNS
#  2022-11-21
#   - added organblocks/box blocks
#   - added x,y,z => number,letter, roman numeral naming scheme

# problems: how to add offset of 1 to rowString (line 67)

# produces individual segments using MT_Organics.scad


# run in terminal:
# - navigate terminal to folder, this script resides in (V12) using 'cd'
# - at prompt$ 'bash mt_organics.bash'
# - creates output folders if not already present; will replace content

consoleOutput="_logfile.txt"    # console gets logged to this temp file to be extracted for .csv files
outputFolder="block_exports"    # main output folder
mtGenerator="MT-Organics.scad"  # openscad program code; V12 uses MT-Generator/MT-Icebox controlled from MT-Master
outputFlag=2                    # 2=column/row inserts only (use this), openscad console output: 0=everything, 1=full inserts

# configuration is here=========================
# this script offers only the following options; organ selection etc. is determined in MT_-Organics.scad
asset_typeID=6  # 6 = organblocks, 7 = boxblocks

# block segmentation
count_x=3
count_y=6
count_z=3

# location_x=1
# location_y=2
# location_z=1
#========END==========================


asciiList=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) # lookup table for column IDs
romanList=(I "II" "III" "IV" V)   # lookup table for layer IDs

# check if main export folder exists; if not, create it
if [ ! -d ${outputFolder} ]
then
    mkdir ${outputFolder}
fi

if [ $asset_typeID -eq 6 ] ; then
    subfolderType="organ_blocks"
fi
if [ $asset_typeID -eq 7 ] ; then
    subfolderType="box_blocks"
fi

outputSubfolder=${subfolderType}_${count_x}x${count_y}x${count_z}
cd $outputFolder    # create it in outputFolder
            if [ ! -d ${outputSubfolder} ]
            then
                mkdir ${outputSubfolder}
            fi
            cd - #change directory back to work directory


for (( location_x=0; location_x < count_x; location_x++ )); do

    for (( location_y=0; location_y < count_y; location_y++ )) do

        for (( location_z=0; location_z < count_z; location_z++ )) do

            rowString=$((location_y +1))
            #rowString=${location_y}
            columnString=${asciiList[$location_x]}
            layerString=${romanList[$location_z]}

            if [ $asset_typeID -eq 6 ] ; then
                #runs openscad program, properly configured for blockcount version, blocktypeID=2
                openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/OrganBlock_${rowString}-${columnString}-${layerString}.stl \
                -D asset_typeID=${asset_typeID} \
                -D location_x=${location_x} \
                -D location_y=${location_y} \
                -D location_z=${location_z} \
                -D count_x=${count_x} \
                -D count_y=${count_y} \
                -D count_z=${count_z}

                echo ${outputFolder}/${outputSubfolder}/OrganBlock_${rowString}-${columnString}-${layerString}.stl
            fi

            if [ $asset_typeID -eq 7 ] ; then
                openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/BoxBlock_${rowString}-${columnString}-${layerString}.stl \
                -D asset_typeID=${asset_typeID} \
                -D location_x=${location_x} \
                -D location_y=${location_y} \
                -D location_z=${location_z} \
                -D count_x=${count_x} \
                -D count_y=${count_y} \
                -D count_z=${count_z}

                echo ${outputFolder}/${outputSubfolder}/BoxBlock_${rowString}-${columnString}-${layerString}.stl
            fi

        done

    done

done

