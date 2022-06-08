#!/bin/bash

# Peter Kienle, CNS
#    with help from Mike Gallant
# V1 2022-6-2
# - loop to iterate through millitome creation property lists
# - NOTE: blocksizeIDs are not used to configure openscad; but as look up IDs 
# 2022-6-7
# - log output to files; code cleanup; commenting
#
# run in terminal:
# - navigate terminal to folder (V11) using 'cd'
# - bash mt_export.bash
# - creates output folders if not already present; will replace the content

consoleOutput="_logfile.txt"        # console gets saved to this temp file to be extracted for .csv files
stlOutputFolder="exports_stl/"      # STLs export folder; automatically created if not present
csvOutputFolder="exports_csv/"      # CSVs export folder; automatically created if not present
mtGenerator="MT-Generator.scad"     # openscad program code
outputFlag=2                        # openscad console output: 0=everything, 1=full inserts, 2=column/row inserts only (use this)

# check if export folders exist; if not, create them
if [ ! -d ${stlOutputFolder} ]
then
    mkdir ${stlOutputFolder}
fi

if [ ! -d ${csvOutputFolder} ]
then
    mkdir ${csvOutputFolder}
fi

# IDs used to configure Openscad output. Must match 'exposed properties' in MT_Generator
genderIDs=(0 1)
organIDs=(0 1 2 3)
blocksizeIDs=(0 1 2)
lateralityIDs=(0 1)
scaleIDs=(0 1 2)

# Used to assemble filenames for .STL & .CSV files. Lists must match MT_Generator & ID lists (above)
genderList=(F M)
genderNamesList=(Female Male)
organList=(Kidney_L Kidney_R Spleen Pancreas)
organList2=("Kidney left" "Kidney right" Spleen Pancreas)
blocksizeList=(10 15 20)
lateralityList=(Bottom Top)
scaleList=(Large Medium Small)

asciiList=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) # lookup table for column IDs

# loop to iterate through complete ID lists
# - runs openscad with correct config properties for each organ; saves STL files with proper filename to stlOutputFolder
# - saves properly named CSV lookup files for each MT
# - current lists will create 144 files each for STL & CSV
for genderID in ${genderIDs[@]}; do     # genders: 2
    gender=${genderList[$genderID]}
    genderName=${genderNamesList[$genderID]}

    for organID in ${organIDs[@]}; do   # organs: 4
        organ=${organList[$organID]}
        organ2=${organList2[$organID]}

        for blocksizeID in ${blocksizeIDs[@]}; do   # blocksizes: 3
            blocksize=${blocksizeList[$blocksizeID]}

            for lateralityID in ${lateralityIDs[@]}; do # top/bottom: 2
                laterality=${lateralityList[$lateralityID]}

                for scaleID in ${scaleIDs[@]}; do       # scale: 3
                    scale=${scaleList[$scaleID]}

                        touch $consoleOutput    # time stamp? creates the file?
                        exec 3<&1               # save original stdout to 3
                        exec &> $consoleOutput  # direct all out and err to the log file
                      
                        # runs openscad program, properly configured
                        openscad ${mtGenerator} -o ${stlOutputFolder}/VH_${gender}_${organ}_${blocksize}_${scale}_${laterality}.stl -D laterality=${lateralityID} -D gender=${genderID} -D organ_id=${organID} -D organ_scale=${scaleID} -D block_size=${blocksize} -D output_flag=${outputFlag}

                        exec 1>&3 # restore original stdout

                        input=$consoleOutput    # use this file to parse column/row data from logfile; (outputFlag=2)

                        while read -r line      # read lines and parse for column & row data
                        do
                            if [[ $line =~ "ECHO: \">col:" ]] ; then
                                line2=${line/ECHO: \">col:/}
                                columnsStr=${line2/<col\"}  # columns as string
                            fi

                            if [[ $line =~ "ECHO: \">row:" ]] ; then
                                line2=${line/ECHO: \">row:/}
                                rowsStr=${line2/<row\"}     # rows as string
                            fi
                        done < "$input"

                        columnCount=$((columnsStr))         # make explicit int number of columns
                        rowCount=$((rowsStr))               # explicit int number of rows
                        
                        # make name, filename & content of CSV
                        csvName=VH_${gender}_${organ}_${blocksize}_${scale}_${laterality}
                        csvFileName=${csvOutputFolder}${csvName}.csv
                        csvLine1=${csvName},
                        csvLine2="${genderName} ${organ2} ${blocksize}x${blocksize}mm,"
                        csvLine3="Millitome ID,Sample ID,"
                        
                        # write lines to CSV file
                        echo $csvLine1 > $csvFileName   # CSV name
                        echo $csvLine2 >> $csvFileName  # CSV meta data
                        echo $csvLine3 >> $csvFileName  # CSV column info

                        # iterate column/row counters to create A1.....Nx matrix
                        rowCounter=1                        # rows start at 1
                        until [ $rowCounter -gt $rowsStr ]  # need to use 'strings' here
                        do
                            colCounter=0                    # columns start at 0 because of retrieval from asciiList
                            until [ $colCounter -eq $columnsStr ]
                            do
                                rowString=${asciiList[$colCounter]}$rowCounter, # assemble row string
                                echo $rowString >> $csvFileName                 # row string to file
                                ((colCounter++))
                            done

                             ((rowCounter++))
                        done
                    done
                done
            done
        done
    done
done
