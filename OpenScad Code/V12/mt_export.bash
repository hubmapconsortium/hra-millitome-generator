#!/bin/bash

# V3 - works with V12 of MT_generator
# Peter Kienle, CNS
#  2022-9-29
# added product IDs
# support for STL/DXF suffix
#   2022-10-4
# now makes eports proper dxf/stl file extensions


# run in terminal:
# - navigate terminal to folder tjis script resides in (V11) using 'cd'
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
# this is the task list! These items are created.
genderIDs=(1)
organIDs=(4)
blocksizeIDs=(2)
lateralityIDs=(2)
scaleIDs=(1)
productIDs=(0 1 2 3 4 5)

# Used to assemble filenames for .STL & .CSV files. Lists must match MT_Generator & ID lists (above)
genderList=(F M)
genderNamesList=(Female Male)
organList=(Kidney_L Kidney_R Spleen Pancreas Banana)
organList2=("Kidney left" "Kidney right" Spleen Pancreas Banana)
blocksizeList=(10 15 20)
lateralityList=(Bottom Top BottomOnly)
scaleList=(Large Medium Small)
productList=("" Block_array Sample_blocks Organ IceboxDXF IceboxSTL)

asciiList=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) # lookup table for column IDs

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
            outputSubfolder=VH_${gender}_${organ}_${blocksize}_Millitomes
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
                        if [ $productTestID -eq $productTestID ] ; then    
                            fileSuffix="dxf"
                        fi

                        
                        # runs openscad program, properly configured
                        openscad ${mtGenerator} -o ${outputFolder}/${outputSubfolder}/VH_${gender}_${organ}_${blocksize}_${scale}_${laterality}_${product}.${fileSuffix} \
                        -D productID=${productID} \
                        -D lateralityID=${lateralityID} \
                        -D genderID=${genderID} \
                        -D organID=${organID} \
                        -D organ_scaleID=${scaleID} \
                        -D block_size=${blocksize} \
                        -D output_flag=${outputFlag}
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
                    csvName=VH_${gender}_${organ}_${blocksize}_${scale}_${laterality}       # assemble technical name w/ underscores
                    csvFileName=${outputSubfolder}/${csvName}.csv                           # assemble filename by appending file type
                    csvLine1=${csvName},                                                    # content of line1...
                    csvLine2="${genderName} ${organ2} ${blocksize}x${blocksize}mm ${scale} ${laterality},"
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
                            colCounter=0                # columns start at 0 because of retrieval from $asciiList
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
