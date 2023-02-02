
product         = "Millitome";   // [Millitome,Icebox]

gender          = "female";    // [female,male]
organ           = "kidney_l";   // [kidney_l,kidney_r,spleen,pancreas,banana,vb_pancreas]
 
laterality      = "bottom";    // [bottom,top,bottom no ID]
organscale      = "medium";    // [large,medium,small]                   

blocktype       = "uniform-blocksize";    // [uniform-blocksize,XY-blocksize,XY-blockcount]

blocksize       = 20 ;  // [10,15,20]

blocksize_x     = 20;   // [10,15,20]
blocksize_y     = 20;   // [10,15,20]

blocks_x        = 3;    // used for blocktype=3, number of blocks along x, used for calculated blocksize
blocks_y        = 5;   // number of blocks along y

module __Customizer_Limit__ () {}  // show in customizer up to here
    shown_by_customizer = false;
//=======any commented ('//') lines above this will be shown in the Customizer window!!=========================

// MT-Customizer
//  production version

// Peter Kienle, CNS
// master controller to launch MT-Generator & MT-Icebox applications

// V0.4 2023-2-2
//  2023-1-19   remove uncommon asset types
//  2022-10-25  added organ bisection
//  2022-10-26  added block full array


// defaults for MT building properties; [] items in comments are used by customizer; must match entries in property lists

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY

// property lists------------------------------------------------
// extract property IDs from string lists in Customizer

product_list = ["Millitome","Icebox"];
productID = [ for (i = [0:1:len(product_list)]) if (product==product_list[i]) i][0];
    
genders = ["female","male"];
genderID = [ for (i = [0:1:len(genders)]) if (gender==genders[i]) i][0];    //returns a list!! Need [0] at the end to get first item

organs = ["kidney_l","kidney_r","spleen","pancreas","banana", "vb_pancreas"];
organID = [ for (i = [0:1:len(organs)]) if (organ==organs[i]) i][0];

lateralities = ["bottom","top","bottom no ID"];
lateralityID = [ for (i = [0:1:len(lateralities)]) if (laterality==lateralities[i]) i][0];
    
organscales = ["large","medium","small"];
organscaleID = [ for (i = [0:1:len(organscales)]) if (organscale==organscales[i]) i][0];
    
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

