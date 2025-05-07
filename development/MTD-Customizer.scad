
product         = "MT-physical";   // [MT-physical,MT-block array,MT-sample blocks,MT-organ,MT-full array,MT-full organ bisection,UI-organ,IB-physical,IB-virtual]

gender          = "female";    // [female,male]
organ           = "kidney_l";   // [kidney_l,kidney_r,spleen,pancreas,banana,g_pancreas,ovary_l,ovalry_l,ovalry_l_penn,kidney_y,pnnl_pancreas,pnnl_pancreas_head,pnnl_pancreas_nothead]
 
laterality      = "bottom";    // [bottom,top,bottom no ID]

blocktype       = "uniform";    // [uniform,userXY,blockCount]

blocksize       = 20 ;  // [5:30]

blocksize_x     = 20;   // [5:30]
blocksize_y     = 20;   // [5:30]

blocks_x        = 3;    // [1:50]
blocks_y        = 6;   // [1:50]

organscale      = 100; // [25:200]

module __Customizer_Limit__ () {}  // show in customizer up to here
    shown_by_customizer = false;
//=======any commented ('//') lines above this will be shown in the Customizer window!!=========================

// MTD-Customizer
// developer version; can produce export all asset types

// Peter Kienle, CNS
// master controller to launch MT-Generator & MT-Icebox applications

// V0.61 2023-5-30
//  2023-5-30   replace kidney_x with kidney_y
//  2023-5-24   changed #5 vb_pancreas->g_pancreas
//  2023-3-23   added f10,f11,f12 pnnl_pancreas
//  2023-2-20   added ovalry_l_penn for testing; extended organ scale top limit to 200%
//  2023-2-17   added sliders for numerical input
//  2023-2-16   added ovalry_l for testing; added flexible organ scale %
//  2023-1-12   added ovary_l for testing
//  2022-10-25  added organ bisection
//  2022-10-26  added block full array


// defaults for MT building properties; [] items in comments are used by customizer; must match entries in property lists

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY

// property lists------------------------------------------------
// extract property IDs from string lists in Customizer
genders = ["female","male"];
genderID = [ for (i = [0:1:len(genders)]) if (gender==genders[i]) i][0];    //returns a list!! Need [0] at the end to get first item

organs = ["kidney_l","kidney_r","spleen","pancreas","banana","g_pancreas","ovary_l","ovalry_l","ovalry_l_penn","kidney_y","pnnl_pancreas","pnnl_pancreas_head","pnnl_pancreas_nothead"];
organID = [ for (i = [0:1:len(organs)]) if (organ==organs[i]) i][0];

lateralities = ["bottom","top","bottom no ID"];
lateralityID = [ for (i = [0:1:len(lateralities)]) if (laterality==lateralities[i]) i][0];
    
//organscales = ["large","medium","small"];
//organscaleID = [ for (i = [0:1:len(organscales)]) if (organscale==organscales[i]) i][0];
    
type_list = ["uniform","userXY","blockCount"];
typeID = [ for (i = [0:1:len(type_list)]) if (blocktype==type_list[i]) i][0];
    
product_list = ["MT-physical","MT-block array","MT-sample blocks","MT-organ","MT-full array","MT-full organ bisection","UI-organ","IB-physical","IB-virtual"];
productID = [ for (i = [0:1:len(product_list)]) if (product==product_list[i]) i][0];
    
generic_x   = 1;
generic_y   = 1;
generic_z   = 1;

// call needed includes with appropriate asset type ID as per user request
if (productID == 0) millitome_physical();
if (productID == 1) millitome_blockarray();
if (productID == 2) millitome_sampleblocks();
if (productID == 3) millitome_organ();
if (productID == 4) blockfull_bisection();
if (productID == 5) organ_bisection();
if (productID == 6) ui_organ();
if (productID == 7) icebox_physical();
if (productID == 8) icebox_virtual();


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

module ui_organ() {
   asset_typeID = 0;
   
//    rotate([248,-105,162])
//        translate([-32.07,69.87,266.48])
//            color("indianred")
//            import("organs/f_3_pancreas.stl",convexity=3);
    
    translate([0,0,0])
        rotate([-112,-9.5,0])
            color("lightblue")
            import("organs/f_9_kidney_y.stl",convexity=3);
    
    rotate([0,00,0])
        color("indianred")
        import ("organs/kidney_y_source.stl",convexity=3);
}


module icebox_physical() {
    asset_typeID = 0;
    include<MTD-Icebox.scad>;
}

module icebox_virtual() {
    asset_typeID = 1;
    include<MTD-Icebox.scad>;
}
    
