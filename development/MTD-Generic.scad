
// Width of generic (mm)
generic_x    =   20; // [5:40]
// Length of generic (mm)
generic_y    =   30; // [5:60]
// Height of generic (mm)
generic_z    =   20; // [5:40]

// select asset type
product         = "MT-physical";   // [MT-physical,MT-block array,MT-sample blocks,MT-organ,MT-full array,MT-full organ bisection,IB-physical,IB-virtual]
 
// select top or bottom
laterality      = "bottom";    // [bottom,top,bottom no ID]        

// select size of blocks or count of blocks 
blocktype       = "uniform";    // [uniform,userXY,blockCount]

// size X/Y for uniform blocks
blocksize       = 20;   // [5:30]

// size X for blocks
blocksize_x     = 20;   // [5:30]

// size Y for blocks
blocksize_y     = 20;   // [5:30]

// number of segments along X
blocks_x        = 3;    // [1:50]
// number of segments along Y
blocks_y        = 5;    // [1:50]

module __Customizer_Limit__ () {}  // show in customizer up to here
    shown_by_customizer = false;

// MT_Generic 
// by Peter Kienle, CNS
//
// uses configurable ellipsoid as organ cast
//
//  V0.2    2023/3/2
//  2023-3-2    full Customizer integration; use genderID & organID to switch organic/generic MT-Generator 224


// defaults for MT building properties; [] items in comments are used by customizer; must match entries in property lists

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY

// property lists------------------------------------------------
// extract property IDs from string lists in Customizer
//genders = ["female","male"];
genderID = 2;   // selects for genric in MT_Generator
organID = 0;    // default (use to decide on generator?

lateralities = ["bottom","top","bottom no ID"];
lateralityID = [ for (i = [0:1:len(lateralities)]) if (laterality==lateralities[i]) i][0];
    
type_list = ["uniform","userXY","blockCount"];
typeID = [ for (i = [0:1:len(type_list)]) if (blocktype==type_list[i]) i][0];
    
product_list = ["MT-physical","MT-block array","MT-sample blocks","MT-organ","MT-full array","MT-full organ bisection","IB-physical","IB-virtual"];
productID = [ for (i = [0:1:len(product_list)]) if (product==product_list[i]) i][0];
    
organscale = 100;   // default
    

// call needed includes with appropriate asset type ID as per user request
if (productID == 0) millitome_physical();
if (productID == 1) millitome_blockarray();
if (productID == 2) millitome_sampleblocks();
if (productID == 3) millitome_organ();
if (productID == 4) blockfull_bisection();
if (productID == 5) organ_bisection();
if (productID == 6) icebox_physical();
if (productID == 7) icebox_virtual();


module millitome_physical() {
    asset_typeID = 0;
    include<MTD-Generator.scad>;
}

module millitome_blockarray() {
    asset_typeID = 1;
    include<MTD-Generator.scad>;  
}

module millitome_sampleblocks() {
    asset_typeID = 2;
    include<MTD-Generator.scad>;  
}

module millitome_organ() {
    asset_typeID = 3;
    include<MTD-Generator.scad>;  
}

module blockfull_bisection() {
    asset_typeID = 4;
    include<MTD-Generator.scad>;
}

module organ_bisection() {
    asset_typeID = 5;
    include<MTD-Generator.scad>;  
}

module icebox_physical() {
    asset_typeID = 0;
    include<MTD-Icebox.scad>;
}

module icebox_virtual() {
    asset_typeID = 1;
    include<MTD-Icebox.scad>;
}
    
