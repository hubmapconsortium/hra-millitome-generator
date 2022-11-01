
gender          = "female";    // [female,male]
organ           = "kidney_l";   // [kidney_l,kidney_r,spleen,pancreas,banana, vb_pancreas]
 
laterality      = "bottom";    // [bottom,top,bottom no ID]
organ_scale     = "large";    // [large,medium,small]                   

blocktype       = "uniform";    // [uniform,userXY,blockCount]

block_size      = 10 ;  // [10,15,20]

block_xsize     = 10;   // [10,15,20]
block_ysize     = 20;   // [10,15,20]

blocks_x        = 7;    // used for type 3, number of blocks along x, used for calculated block_size
blocks_y        = 14;   // number of blocks along y

product         = "MT-physical";   // [MT-physical,MT-block array,MT-sample blocks,MT-organ,IB-physical,IB-virtual,MT_Organ_Bisect,MT_Full_Array]

module __Customizer_Limit__ () {}  // show in customizer up to here
    shown_by_customizer = false;
//=======any commented ('//') lines above this will be shown in the Customizer window!!=========================

// MT-Customizer

// Peter Kienle, CNS
// master controller to launch MT-Generator & MT-Icebox applications

// V0.1 2022-10-26
//  2022-10-25  added organ bisection
//  2022-10-26  added block full array


// defaults for MT building properties; [] items in comments are used by customizer; must match entries in property lists

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY

// property lists------------------------------------------------
// extract property IDs from string lists in Customizer
genders = ["female","male"];
genderID = [ for (i = [0:1:len(genders)]) if (gender==genders[i]) i][0];    //returns a list!! Need [0] at the end to get first item

organs = ["kidney_l","kidney_r","spleen","pancreas","banana", "vb_pancreas"];
organID = [ for (i = [0:1:len(organs)]) if (organ==organs[i]) i][0];

lateralities = ["bottom","top","bottom no ID"];
lateralityID = [ for (i = [0:1:len(lateralities)]) if (laterality==lateralities[i]) i][0];
    
organ_scales = ["large","medium","small"];
organ_scaleID = [ for (i = [0:1:len(organ_scales)]) if (organ_scale==organ_scales[i]) i][0];
    
type_list = ["uniform","userXY","blockCount"];
typeID = [ for (i = [0:1:len(type_list)]) if (blocktype==type_list[i]) i][0];
    
product_list = ["MT-physical","MT-block array","MT-sample blocks","MT-organ","IB-physical","IB-virtual","MT_Organ_Bisect","MT_Full_Array"];
productID = [ for (i = [0:1:len(product_list)]) if (product==product_list[i]) i][0];
    

// call needed includes with appropriate asset type ID as per user request
if (productID == 0) millitome_physical();
if (productID == 1) millitome_blockarray();
if (productID == 2) millitome_sampleblocks();
if (productID == 3) millitome_organ();
if (productID == 4) icebox_physical();
if (productID == 5) icebox_virtual();
if (productID == 6) organ_bisection();
if (productID == 7) blockfull_bisection();


module millitome_physical() {
    asset_typeID = 0;
    include<MT-Generator.scad>;
}

module millitome_blockarray() {
    asset_typeID = 1;
    include<MT-Generator.scad>;  
}

module millitome_sampleblocks() {
    asset_typeID = 2;
    include<MT-Generator.scad>;  
}

module millitome_organ() {
    asset_typeID = 3;
    include<MT-Generator.scad>;  
}

module icebox_physical() {
    asset_typeID = 0;
    include<MT-Icebox.scad>;
}

module icebox_virtual() {
    asset_typeID = 1;
    include<MT-Icebox.scad>;
}

module organ_bisection() {
    asset_typeID = 4;
    include<MT-Generator.scad>;  
}
    
module blockfull_bisection() {
    asset_typeID = 5;
    include<MT-Generator.scad>;
}