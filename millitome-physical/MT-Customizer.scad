
product         = "millitome";   // [millitome,icebox]

gender          = "female";    // [female,male]
organ           = "kidney_l";   // [kidney_l,kidney_r,spleen,pancreas,banana,g_pancreas]
 
laterality      = "bottom";    // [bottom,top,bottom no ID]        

blocktype       = "uniform-blocksize";    // [uniform-blocksize,XY-blocksize,XY-blockcount]

blocksize       = 20;   // [5:30]

blocksize_x     = 20;   // [5:30]
blocksize_y     = 20;   // [5:30]

blocks_x        = 3;    // [1:50]
blocks_y        = 5;    // [1:50]

organscale      = 100;  // [25:150]         

module __Customizer_Limit__ () {}  // show in customizer up to here
    shown_by_customizer = false;
//=======any commented ('//') lines above this will be shown in the Customizer window!!=========================

// MT-Customizer
//  production version

// Peter Kienle, CNS
// master controller to launch MT-Generator & MT-Icebox applications

// V0.6 2023-5-24
//  2023-5-24   changed #5 vb_pancreas->g_pancreas
//  2023-2-17   added sliders for numerical input
//  2023-2-16   modified organscale to use 1-nnn flexible values; flexible blocksizes
//  2023-1-19   remove uncommon asset types
//  2022-10-25  added organ bisection
//  2022-10-26  added block full array


// defaults for MT building properties; [] items in comments are used by customizer; must match entries in property lists

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY

// property lists------------------------------------------------
// extract property IDs from string lists in Customizer

product_list = ["millitome","icebox"];
productID = [ for (i = [0:1:len(product_list)]) if (product==product_list[i]) i][0];
    
genders = ["female","male"];
genderID = [ for (i = [0:1:len(genders)]) if (gender==genders[i]) i][0];    //returns a list!! Need [0] at the end to get first item

organs = ["kidney_l","kidney_r","spleen","pancreas","banana", "g_pancreas"];
organID = [ for (i = [0:1:len(organs)]) if (organ==organs[i]) i][0];

lateralities = ["bottom","top","bottom no ID"];
lateralityID = [ for (i = [0:1:len(lateralities)]) if (laterality==lateralities[i]) i][0];
       
type_list = ["uniform-blocksize","XY-blocksize","XY-blockcount"];
typeID = [ for (i = [0:1:len(type_list)]) if (blocktype==type_list[i]) i][0];
    
// call needed includes with appropriate asset type ID as per user request
if (productID == 0) millitome_physical();
if (productID == 1) icebox_physical();

module millitome_physical() {
    asset_typeID = 0;
    include<MT-Generator.scad>;
}

module icebox_physical() {
    asset_typeID = 0;
    include<MT-Icebox.scad>;
}

