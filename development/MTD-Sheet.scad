
// trying to create CSV data to console
//  may not be possible without ECHO -> Openscad can't mnaipulate global variable in for-loop

csvLine1    = "VH_F_Kidney_L_20_Large_Top,";
csvLine2    = "Female Kidney left 20x20mm Large Top,";
csvLine3    = "Millitome ID,Sample ID,";
newline     = chr(13);

csvString   = str(csvLine1,newline,csvLine2,newline,csvLine3,newline);

x           = 3;
y           = 10;
z           = 1;

for (dx = [0:x]) {
    
    
    for (dy = [1:y]) {
        makeStr(dx,dy);
        //csvString = str(csvString,chr(dx+65),newline,dy,newline);
        //echo (chr(dx+65),newline,dy);
    }
    
}

module makeStr(dx,dy){
   
    csvString = str(csvString,chr(dx+65),newline,dy,newline);
    echo (dx);
    
}


echo (csvString);