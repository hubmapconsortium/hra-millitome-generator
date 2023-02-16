#!/bin/bash

# V4.1 - works with V12 of MT_generator
# Peter Kienle, CNS
#  2022-10-25
#   properly handles organID 5 and user block counts

# will not work properly with flexible organscale!! think about how to pass in organscale 1-nnn%-------------

# run in terminal:
# - navigate terminal to folder, this script resides in (V12) using 'cd'
# - at prompt$ 'bash mt_export.bash'
# - creates output folders if not already present; will replace content

consoleOutput="_logfile.txt"        # console gets logged to this temp file to be extracted for .csv files
outputFolder="exports"              # main output folder
mtGenerator="MT-Master.scad"        # openscad program code; V12 uses MT-Generator/MT-Icebox controlled from MT-Master
outputFlag=2                        # 2=column/row inserts only (use this), openscad console output: 0=everything, 1=full inserts

# check if main export folder exists; if not, create it
if [ ! -d ${outputFolder} ]
then
    mkdir ${outputFolder}
fi

# IDs used to configure Openscad output. Must match 'exposed properties' in MT_Generator
# this is the task list! Assets in these lists are created are created.
genderIDs=(0)
organIDs=(5)
blocksizeIDs=(2)    #====only if blocktypeID=0
blockxsizeIDs=(1)   #====only if blocktypeID=1
blockysizeIDs=(1)   #====only if blocktypeID=1
lateralityIDs=(0)
scaleIDs=(1)
productIDs=(0 1)  # can't use ID 3 alone, no col/row info to console, CSV creation will fail

blocktypeID=2       # 0=uniform, 1=userXY, 2=blockcount !! ID=1 is not covered yet!!
blocksx=2           #=====only if blocktypeID=2
blocksy=25          #=====only if blocktypeID=2

# Used to assemble filenames for .STL & .CSV files. Lists must match MT_Generator & ID lists (above)
genderList=(F M)
genderNamesList=(Female Male)
organList=(Kidney_L Kidney_R Spleen Pancreas Banana VB_Pancreas)
organList2=("Kidney left" "Kidney right" Spleen Pancreas Banana VB_Pancreas)
blockTypeList=("uniform" "userXY" "blockcount")
blocksizeList=(10 15 20)
blockxsizeList=(10 15 20)
blockysizeList=(10 15 20)
lateralityList=(Bottom Top BottomOnly)
scaleList=(Large Medium Small)
productList=(Millitome Block_array Sample_blocks Organ IceboxDXF IceboxSTL)

asciiList=(X A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) # lookup table for column IDs

blocktype=${blockTypeList[$blocktypeID]}

# loop to iterate through complete ID lists
# - runs openscad with correct config properties for each organ
# - saves STL files with proper filename to outputFolder
# - saves properly named CSV lookup files for each MT to outputFolder
# - current lists will create 144 files each for STL & CSV
for genderID in ${genderIDs[@]}; do     # genders: 2
    gender=${genderList[$genderID]}
    genderName=${genderNamesList[$genderID]}

    for organID in ${organIDs[@]}; do   # organs: 5
        organ=${organList[$organID]}
        organ2=${organList2[$organID]}

        for blocksizeID in ${blocksizeIDs[@]}; do   # blocksizes: 3
            blocksize=${blocksizeList[$blocksizeID]}

            # create output subfolder if it doesn't exist------------
            if [ $blocktypeID -eq 0 ] ; then
                outputSubfolder=VH_${gender}_${organ}_${blocksize}_Millitomes
            fi

            if [ $blocktypeID -eq 2 ] ; then
                outputSubfolder=VH_${gender}_${organ}_${blocksx}x${blocksy}blocks_Millitomes
            fi


            cd $outputFolder    # create it in outputFolder
            if [ ! -d ${outputSubfolder} ]
            then
                mkdir ${outputSubfolder}
            fi
            cd - #change directory back to work directory

            for lateralityID in ${lateralityIDs[@]}; do # top/bottom: 2
                laterality=${lateralityList[$lateralityID]}

                for scaleID in ${scaleIDs[@]}; do       # scale: 3
                    scale=${scaleList[$scaleID]}

                    touch $consoleOutput    # time stamp? creates the file?
                    exec 3<&1               # save original stdout to 3
                    exec &> $consoleOutput  # direct all out and err to the log file
                    
                    for productID in ${productIDs[@]}; do   # product ID
                        product=${productList[productID]}

                        fileSuffix="stl"        # STL is default fileSuffix
                        dxfSuffixID=$((4))      # must make explicit string 
                        productTestID=$((productID))    #explicit string
                        if [ $productTestID -eq $dxfSuffixID ] ; then    
                            fileSuffix="dxf"
                        fi

                        if [ $blocktypeID -eq 0 ] ; then
                            #runs openscad program, properly configured for uniform blocksize, blocktypeID=0
                            openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/VH_${gender}_${organ}_${blocksize}_${scale}_${laterality}_${product}.${fileSuffix} \
                            -D productID=${productID} \
                            -D lateralityID=${lateralityID} \
                            -D genderID=${genderID} \
                            -D organID=${organID} \
                            -D organ_scaleID=${scaleID} \
                            -D block_size=${blocksize} \
                            -D output_flag=${outputFlag}
                            #echo "blocktype 0"
                        fi

                        if [ $blocktypeID -eq 2 ] ; then
                            #runs openscad program, properly configured for blockcount version, blocktypeID=2
                            openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/VH_${gender}_${organ}_${blocksx}x${blocksy}blocks_${scale}_${laterality}_${product}.${fileSuffix} \
                            -D productID=${productID} \
                            -D lateralityID=${lateralityID} \
                            -D genderID=${genderID} \
                            -D organID=${organID} \
                            -D organ_scaleID=${scaleID} \
                            -D typeID=${blocktypeID} \
                            -D blocks_x=${blocksx} \
                            -D blocks_y=${blocksy} \
                            -D output_flag=${outputFlag}
                            #echo "blocktype 2"
                        fi

                     done
                           
                    exec 1>&3 # restore original stdout

                    input=$consoleOutput    # use this file to parse column/row data from logfile; (outputFlag=2)

                    while read -r line      # read from input and parse for column & row data
                        do
                            if [[ $line =~ "ECHO: \">col:" ]] ; then    # find line that starts with....
                                line2=${line/ECHO: \">col:/}            # extract everything after...
                                columnsStr=${line2/<col\"}              # extract everything before = columns as string
                            fi

                            if [[ $line =~ "ECHO: \">row:" ]] ; then    # find line that starts with...
                                line2=${line/ECHO: \">row:/}            # extract everything after..
                                rowsStr=${line2/<row\"}                 # extract everything before = rows as string
                            fi
                        done < "$input"     # close input

                    columnCount=$((columnsStr))         # make explicit int number of columns
                    rowCount=$((rowsStr))               # explicit int number of rows
                    
                    # make name, filename & content of CSV
                    # assemble technical name w/ underscores
                    # content of line1...

                    # different lines per blocktypeID
                    if [ $blocktypeID -eq 0 ] ; then
                        csvLine2="${genderName} ${organ2} ${blocksize}x${blocksize}mm ${scale} ${laterality},"
                        csvName=VH_${gender}_${organ}_${blocksize}_${scale}_${laterality} 
                    fi

                    if [ $blocktypeID -eq 2 ] ; then
                        csvLine2="${genderName} ${organ2} ${blocksx}x${blocksy}blocks ${scale} ${laterality},"
                        csvName=VH_${gender}_${organ}_${blocksx}x${blocksy}blocks_${scale}_${laterality} 
                    fi

                    csvFileName=${outputSubfolder}/${csvName}.csv       # assemble filename by appending file type
                    csvLine1=${csvName},  
                    csvLine3="Millitome ID,Sample ID,"
                    
                    cd $outputFolder                # change directory to output folder (for some reason subfolder didn't work echo redirect)

                    # write lines to CSV file
                    echo $csvLine1 > $csvFileName   # CSV name
                    echo $csvLine2 >> $csvFileName  # CSV meta data
                    echo $csvLine3 >> $csvFileName  # CSV column info

                    # iterate column/row counters to create A1.....Nx matrix
                    rowCounter=1                        # rows start at 1
                    until [ $rowCounter -gt $rowsStr ]  # need to use 'strings' here
                        do
                            colCounter=1                # columns start at 1; pulls chars from pos 1 @ $asciiList
                            until [ $colCounter -eq $columnsStr ]
                                do
                                    rowString=${asciiList[$colCounter]}$rowCounter, # assemble row string
                                    echo $rowString >> $csvFileName                 # row string to file
                                    ((colCounter++))
                                done

                            ((rowCounter++))
                        done
                        cd -    # back to main folder
                        echo $csvName
                    done
                done
                # here after folder is done
                # zip this folder
                cd $outputFolder                                    # zip command runs in outputFolder
                zip -r ${outputSubfolder}.zip ${outputSubfolder}    # zip all contents and use name for zip file
                rm -r ${outputSubfolder}                            # remove folder
                cd -                                                # back to main folder
            done
        done
    done
done
