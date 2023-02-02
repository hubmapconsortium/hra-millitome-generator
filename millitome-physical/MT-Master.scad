// MT-Master, Peter Kienle, CNS
// V0.4 2023-2-2
//
//  2023-02-02  unified carry-over variable names to match with customizer  
//  2022-10-25  added organ bisection
//  2022-10-26  added block full array

// Open Properties Block=========
//  these variables must be defined here and are carried into MT-Generator & MT-Icebox
//  in case this is run from a bash script the properties are over-ridden by the parameters passed in

product         = 0;    // 0=millitome_physical, 1=icebox_physical

gender          = 0;    // 0=female, 1=male, needs to be integer selector
organ           = 0;    // 0=kidney_l,1=kidney_r,2=spleen,3=pancreas,4=banana,5=vb_pancreas
laterality      = 0;    // 0=bottom, 1=top, 2=bypass MT creation      
organscale      = 1;    // 0=large,1=medium,2=small                    

blocktype       = 0;    // 0=fixed block size, 1=user block size, 2=user block count

blocksize       = 20 ;  // used for blocktype=0, uniform x/y block size for cubes

blocksize_x     = 10;   // used for blocktype=1, different x/y block size
blocksize_y     = 20;

blocks_x        = 7;    // used for blocktype=2, number of blocks along x, used for calculated block_size
blocks_y        = 14;   // number of blocks along y

//===============================END Open properties=============

asset_typeID    = 0;    // 0=physical MT, 1=virtual block array, 2=virtual block/organ cut, 3=virtual organ model, 4=blockfull_bisection, 5=organ_bisection, 

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY

// matching variable names to pass through to MT_Generator
productID       = product;
genderID        = gender;
organID         = organ;
lateralityID    = laterality;
organscaleID    = organscale;
typeID          = blocktype;

// call with appropriate asset type ID as per user request
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



