// Millitome Generator Icebox Module V15
//  developer: Peter Kienle, CNS

// V15  2023-2-17
//  2022-9-22   moved to active github

// dimensions are in mm
//
// in 3D editor usually X & Z represent the plane, Y is height ==> OpenScad reverses Y<==>Z!!
//
// ymin => height below center plane
// ymax => height above center plane
// yreal => total height of organ (abs(ymin+ymax))
//
//
// display and rendering system defaults - don't change
$fa = 1;
$fs = 0.4;

//================================================================
// exposed variables-------use to select
//
// change values here for single run from Openscad
// or run from terminal using command line; variables can be overrides using -D <property>=n
//  - genderID      0=female, 1=male
//  - organID       0=kidney_l, 1=kidney_r, 2=spleen, 3=pancreas, 4=banana, 5=vb_pancreas
//  - lateralityID  0=bottom, 1=top
//  - typeID        0=fixed block size, 1=user block size, 2=user block count

//  - blocksize     5-30

//  - blocksize_x   5-30
//  - blocksize_y   5-30

//  - blocks_x      1-50
//  - blocks_y      1-50

//  - organscale    25-150

//  - asset_typeID  // 0=physical MT, 1=virtual block array, 2=virtual block/organ cut, 3=virtual organ model

//  - output_flag   0=ECHO everything, 1=ECHO insert line only, 2=ECHO col/row insert ONLY
//================================================================
//------when running from MT-Customizer or MT-Master these variables must be disabled, otherwise they will override variables from master script!!
/*
genderID        = 0;    // 0=female, 1=male, needs to be integer selector
organID         = 4;    // index for list lookup
lateralityID    = 0;    // 0=bottom, 1=top, 2=bypass MT creation                       

typeID          = 0;    // 0=fixed block size, 1=user block size, 2=user block count

blocksize       = 20 ;  // used for type 0, uniform x/y block size for cubes

blocksize_x     = 10;   // used for type 1, different x/y block size
blocksize_y     = 20;

blocks_x        = 7;    // used for type 2, number of blocks along x, used for calculated blocksize
blocks_y        = 14;   // number of blocks along y

organscale      = 100; 

asset_typeID    = 0;    // 0=physical MT, 1=virtual block array, 2=virtual block/organ cut, 3=virtual organ model, 4=blockfull_bisection, 5=organ bisection

output_flag     = 0;    // 0 = ECHO everything, 1 = ECHO insert line only, 2 = ECHO col/row insert ONLY
*/

//================================================================
// Object Generation Area
//  uncomment function(s) to be executed when running program
//================================================================


//===display of organ percentage user setting, organ name & size, millitome dimensions in console (look for ECHO:)
// IMPORTANT: this must be activated when running from Terminal for automatic geometry/sheet creation
// output_flag parameter controls what information is shown in console
dimensions();

if (asset_typeID == 0) icebox_2d();
if (asset_typeID == 1) icebox_3d();

//icebox_alignment_box_2d();
//letter_array(start_character);
//number_array(start_number); 

//================================================================
// construction variables - no need for user access
//================================================================
wall_width      = 10;       // thickness for walls and bottoms - only for outer_box
wall_height     = 10;       // height of outer box wall
bottom_height   = 5;        // was 10; bottom thickness of inner_box & insert (*2 for full MT bottom thickness)

inner_frame_block  = 10;    // was 20; inner frame block size around insert

cut_width       = 1;        // was 1; width of cutting tool
cut_depth       = 1;        // how far to cut below specimen

start_character = 65;       // is A - for column letters
start_number    = 49;       // is 0 - for row numbers

type_thickness  = 5;        // vertical thickness of letters (extrusion into +Z)

organ_folder    = "organs/";// location of organ models

//================================================================
// organ definitions, used to create the mold
//  filename,x,y,z_min,z_max,z_real
//
// Dimensions of organs - must be as accurate as possible - but rounded up to next integer
// all other enclosure dimensions are derived from these
// measurements from "Organ Placing.c4d" xpresso
// 
//================================================================
filename    = 0;    // organ_list member offsets
dimx        = 1;
dimy        = 2;
dimz_min    = 3;    // how much below baseline
dimz_max    = 4;    // how much above baseline
dimz_real   = 5;    // full height of organ, should be (abs(z_min))+z_max (or 2*z_max)

scaling_factor  = organscale/100;

include <mt-organs.config>;

// populate organ dimensions from organ_lists
organ_lists = [organ_list_f,organ_list_m];      // gender ID selects organ_list from here
organ_list  = organ_lists[genderID];              // female or male organ_list, genderID is selector

organ_properties    = organ_list[organID];     // retrieve property list for this organ, organID is selector

organ_file      = organ_properties[filename];   // retrieve properties from list entry
organ_xdim      = organ_properties[dimx] * scaling_factor;
organ_ydim      = organ_properties[dimy] * scaling_factor;

organ_zmin      = organ_properties[dimz_min] * scaling_factor;
organ_zmax      = organ_properties[dimz_max] * scaling_factor;
organ_zreal     = organ_properties[dimz_real] * scaling_factor;

//================================================================
// calculated dimensions, don't mess with these!
//================================================================
// put block sizes in x and y lists, then retrieve what we need based on type parameter as index
xlist = [blocksize,blocksize_x,(organ_xdim+cut_width)/blocks_x];
ylist = [blocksize,blocksize_y,(organ_ydim+cut_width)/blocks_y];

// fetch block sizes according to requested type ID, corrected for 0 index
block_xdim      = xlist[typeID];
block_ydim      = ylist[typeID];

echo ("block_xdim=",block_xdim," block_ydim=",block_ydim);

// insert box dim., rounded to next full blocksize, mode 1&2 only
1insert_box_xdim = (((organ_xdim-(organ_xdim % block_xdim))/block_xdim)*block_xdim)+block_xdim;  // next full block_size
1insert_box_ydim = (((organ_ydim-(organ_ydim % block_ydim))/block_ydim)*block_ydim)+block_ydim;  // next full block_size

// insert box dim., no-rounding, mode 3 only
3insert_box_xdim = organ_xdim;
3insert_box_ydim = organ_ydim;

//evaluate mode flag and select appropriate size
insert_box_xdim= typeID<3 ? 1insert_box_xdim:3insert_box_xdim;
insert_box_ydim= typeID<3 ? 1insert_box_ydim:3insert_box_ydim;

//calculate height of insert_box, add 2mm for cutting depth
insert_box_zdim = organ_zreal/2+bottom_height;

// inner_frame_box dim., based on insert dim., added block_size around
inner_box_xdim  = insert_box_xdim+2*inner_frame_block;  
inner_box_ydim  = insert_box_ydim+2*inner_frame_block;
inner_box_zdim  = insert_box_zdim+bottom_height;


// outer_frame_box dim., based on inner_frame_box dim., added spill_width around
outer_box_xdim  = inner_box_xdim+2*wall_width;
outer_box_ydim  = inner_box_ydim+2*wall_width;
outer_box_zdim  = inner_box_zdim+wall_height+bottom_height;

//================================================================
// functions 3d version
//================================================================

//=============icebox stuff section===============================
// these variables depend on stuff from above lines!!!
icebox_platform_extra_edge  = 5;
icebox_material_thickness   = 2;
icebox_nub_height           = icebox_material_thickness + 3;
icebox_nub_length           = 10;
icebox_nub_latch_length     = 5;
icebox_nub_latch_thickness  = 3;    // latch sticking out at bottom
icebox_nub_gap              = 1;    // slot in platform is longer by this value
icebox_slot_gap             = 0.5;  // gap between top of latch and bottom of platform
cutting_gap                 = 1;    // gap between laser cuts

icebox_xdim                 = insert_box_xdim + icebox_platform_extra_edge*2;
icebox_ydim                 = insert_box_ydim + icebox_platform_extra_edge*2;
icebox_zdim                 = organ_zreal/3;


module icebox_3d() {
    icebox_platform();  
    icebox_column_array();
    icebox_row_array();
}
    
module icebox_2d() {
    icebox_platform_2d();
    icebox_column_array_2d();
    icebox_row_array_2d();
}
    


module icebox_platform_box() {
    color("tan")
    translate([-icebox_platform_extra_edge-10,-insert_box_ydim - icebox_platform_extra_edge,-(icebox_material_thickness)]) 
        cube([icebox_xdim+10,icebox_ydim+8,icebox_material_thickness]);
}

module icebox_alignment_box_2d() {
    projection (cut = true)
    translate([-icebox_platform_extra_edge+10,-insert_box_ydim - icebox_platform_extra_edge,-(icebox_material_thickness)]) 
        cube([icebox_xdim-10,icebox_ydim-10,icebox_material_thickness]);
}



module icebox_platform() {
    difference() {
        icebox_platform_box();
        icebox_nub_slot_cutter();
        letter_array(start_character);
number_array(start_number); 
    }
}


// these create the 2D versions for cutfile
module icebox_platform_2d() {   
    projection (cut = true)
    icebox_platform();
}


module icebox_column_array_2d() {
    translate ([-10,icebox_ydim+1+8,0])
        projection (cut = true)
            for (i = [0:1:insert_box_xdim/block_xdim]) {
                translate ([i*(icebox_zdim+cutting_gap+icebox_material_thickness+icebox_nub_latch_thickness+icebox_slot_gap),0,0]) 
                    rotate ([0,90,0])
                        icebox_column();
            }
}


module icebox_row_array_2d() {
    translate ([-8,icebox_zdim+icebox_ydim+7+8,0])         // why 7?
        projection (cut = true)
            for (i = [0:1:insert_box_ydim/block_ydim]) {
                translate ([0,i*(icebox_zdim+cutting_gap),0])
                   rotate ([90,0,0])
                        icebox_row();      
            }
}


// column dividers============================================

// column divider 
//  adds two connector nubs on each column piece
module icebox_column_box() {  
    color("tan")
    union() {
        // actual column
        translate([0,-insert_box_ydim - icebox_platform_extra_edge,0])
            cube([icebox_material_thickness,icebox_ydim,icebox_zdim]);
        
        // connector nubs
        translate([0,-icebox_nub_length*2,-icebox_nub_height])      // nub 1
            cube([icebox_material_thickness,icebox_nub_length,icebox_zdim+icebox_nub_height]);
        translate([0,-icebox_nub_length*2 -icebox_nub_latch_length,-icebox_nub_latch_thickness-icebox_material_thickness-icebox_slot_gap])
            cube([icebox_material_thickness,icebox_nub_length+icebox_nub_latch_length,icebox_nub_latch_thickness]);

        translate([0,-insert_box_ydim + icebox_nub_length,-icebox_nub_height])  // nub 2
            cube([icebox_material_thickness,icebox_nub_length,icebox_zdim+icebox_nub_height]);
        translate([0,-insert_box_ydim + icebox_nub_length-5,-icebox_nub_latch_thickness-icebox_material_thickness-icebox_slot_gap])
            cube([icebox_material_thickness,icebox_nub_length+icebox_nub_latch_length,icebox_nub_latch_thickness]);
    }
}


module icebox_nub_slot_cutter() {  
    for (dx = [0:block_xdim:insert_box_xdim]) {
        translate([dx,0,0])
            // connector nubs
            union() {
            translate([0,-icebox_nub_length*2 -icebox_nub_latch_length+5,-icebox_nub_latch_thickness-icebox_material_thickness-icebox_slot_gap])
                cube([icebox_material_thickness,icebox_nub_length+icebox_nub_latch_length+icebox_nub_gap,icebox_nub_latch_thickness+4]);
        
            translate([0,-insert_box_ydim + icebox_nub_length,-icebox_nub_height])
                cube([icebox_material_thickness,icebox_nub_length+icebox_nub_latch_length+icebox_nub_gap,icebox_nub_latch_thickness+4]);
            }
    }
}


module icebox_column() {
    difference() {
        icebox_column_box();
        icebox_row_half_array();
    }
}
 
// column divider array
module icebox_column_array() {
    for (dx = [0:block_xdim:insert_box_xdim]) {
        translate([dx,0,0])
            icebox_column();
    }
}

// column divider half height
module icebox_column_half() {  
    color("gold")
    translate([0,-insert_box_ydim - icebox_platform_extra_edge,-icebox_material_thickness])
        cube([icebox_material_thickness,icebox_ydim,icebox_zdim/2+icebox_material_thickness]);
}

// column divider half height array
module icebox_column_half_array() {
    for (dx = [0:block_xdim:insert_box_xdim]) {
        translate([dx,0,0])
            icebox_column_half();
    }
}


// row dividers===============
module icebox_row_box() {
    color("tan")
    translate([0-icebox_platform_extra_edge,0,0])
        cube([icebox_xdim,icebox_material_thickness,icebox_zdim]);
}

module icebox_row() {
    difference() {
        icebox_row_box();
        icebox_column_half_array();
    }
}

// row divider array
module icebox_row_array() {
    for (dy = [0:-block_ydim:-insert_box_ydim]) {
        translate([0,dy,0])
            icebox_row();
    }
}

// row divider half height
module icebox_row_half() {
    color("gold")
    translate([0-icebox_platform_extra_edge,0,icebox_zdim/2])
        cube([icebox_xdim,icebox_material_thickness,(icebox_zdim/2)+icebox_material_thickness]);
}

// row divider half height array
module icebox_row_half_array() {
    for (dy = [0:-block_ydim:-insert_box_ydim]) {
        translate([0,dy,0])
            icebox_row_half();
    }
}
//==========end icebox stuff=====================================



// block numbering & lettering=============================== 

// output one number character, position shifted, font size adjusted
module block_number(character) {
    //for character centering in x (y can stay static) 
    font_size   = block_ydim/2.5;
    font_width  = font_size/1.375;
    font_gap    = (inner_frame_block-font_width)/2;
    
    linear_extrude(type_thickness)
    translate([-(font_width+font_gap)-4,-block_ydim*0.6,0])    //-inner_frame_block*0.75
    
    // interprets two-digit numbers up to 29
    if (character < start_number+9)
    {
        text(chr(character),size=font_size);
    } else {
        
        if ((character > start_number+8) && (character < start_number+19))
        {
            text(chr([49,character-10]),size=font_size);
        } else {
            text(chr([50,character-20]),size=font_size);
        }
    }  
}

// all numbers, line feed depends on block_ydim
module number_array(character) {
    for (dy = [0:-block_ydim:-insert_box_ydim+block_ydim]) {        
        translate([0,dy,-3])
        block_number(character+(-dy/block_ydim));
    }
}

// all numbers, for top half, reverse side and rotate
module numbertop_array(character) {
    for (dy = [0:-block_ydim:-insert_box_ydim+block_ydim]) {    
        translate([block_xdim*(insert_box_xdim/block_xdim),dy,0])
        rotate([0,180,0])
        block_number(character+(-dy/block_ydim));
    }
}

// output one letter character, position shifted, font size&position adjusted
module block_letter(character) {
    font_size   = block_xdim/2.5;
    font_gap    = (inner_frame_block-font_size)/2;
    
    linear_extrude(type_thickness)
    translate([block_xdim*0.3,font_gap,0])
    text(chr(character),size=font_size);
}

// all letters, col. feed depends on block_xdim================
module letter_array(character) {
    for (dx = [0:block_xdim:insert_box_xdim-block_xdim]) {
        translate([dx,0,-3])
        block_letter(character+dx/block_xdim);        
    }
}

// letters for top frame columns, reverse sequence, rotated================
module lettertop_array(character) {
    character = character-1;
    for (dx = [block_xdim:block_xdim:insert_box_xdim]) {
        translate([dx,0,0])
        rotate([0,180,0])
        block_letter(character+dx/block_xdim);        
    }
}



// all IDs for block_array===================
module block_ids(character,number) {
    for (dx = [0:block_xdim:insert_box_xdim-block_xdim]) {
        translate([dx,0,0])
        
        for (dy = [0:-block_ydim:-insert_box_ydim+block_ydim]) {
            translate([0,dy,0])
            block_id(character+dx/block_xdim,number+(-dy/block_ydim));
        }
    }
}

//output one letter/number ID, position shifted, font size&position adjusted
module block_id(character,number) {  
    block_dim   = block_xdim<block_ydim ? block_xdim:block_ydim;  // use smaller dim
    font_size   = block_dim/3.6;
    font_width  = font_size/1.1;
    id_width    = font_width*2;
    font_gap    = (block_xdim-id_width)/2.5;
    
    linear_extrude(type_thickness)
    translate([font_gap,-block_ydim*0.65,0])
    
     // interprets two-digit numbers up to 29
    if (number < start_number+9)
    {
        text(chr(character,number),size=font_size);
    } else {
        
        if ((number > start_number+8) && (number < start_number+19))
        {
            text(chr([character,49,number-10]),size=font_size);
        } else {
            text(chr([character,50,number-20]),size=font_size);
        }
    }  
   
}



// console output======================
module dimensions()
{
// draws organ percentage, x and y dimensions of organ top/left
//    font_size   = block_xdim/2;
//    
//    // dim x
//    linear_extrude(type_thickness)
//        translate([-block_xdim,block_ydim*1.5,0])
//            text(str(organ_xdim),size=font_size);
//    
//    // dim y
//    linear_extrude(type_thickness)
//        translate([-block_xdim*1.5,-block_ydim,0])
//            rotate([0,0,90])
//                text(str(organ_ydim),size=font_size);
//    
//    // scaling percentage & organ file
//    linear_extrude(type_thickness)
//        translate([-block_xdim,block_ydim*2.2,0])
//            text(str(scaling_factor*100,"% ",organ_file),size=font_size*1.2);
    
    if (output_flag == 0) {
        echo(str("Organ Scale & Type: ",scaling_factor*100,"% ",organ_file));
        echo(str("Organ dimensions: X = ",organ_xdim," Y = ",organ_ydim));  
        // dimensions of inner_box() = full perimeter size of millitome
        echo(str("Millitome dimensions: X = ",inner_box_xdim," Y = ",inner_box_ydim," Z = ",inner_box_zdim+type_thickness));
        echo(str("Columns: ",insert_box_xdim/block_xdim, " Rows: ",insert_box_ydim/block_ydim));
    }
        
    // coa list IDs
    _gender         = 0;    // 0=female, 1=male, needs to be integer selector
    _organ1         = 1;    // organID
    _organ2         = 2;  
    _organ_scale    = 3;    // 0 to 2
    _laterality     = 4;    // 0=bottom, 1=top
    
    // cmd_output_array.....
    coa = [
        ["F","M"],
        ["Kidney_L","Kidney_R","Spleen","Pancreas"],
        ["Kidney left","Kidney right","Spleen","Pancreas"],
        ["Large","Medium","Small"],
        ["Bottom","Top"]
    ];
    
    // echoes all data to console
    if (output_flag == 1) {
        echo (str(
            ">>",
            coa[_gender][genderID],",",
            coa[_organ1][organID],",",
            coa[_organ2][organID],",",
            block_size,",",
            coa[_organ_scale][organ_scaleID],",",
            coa[_laterality][lateralityID],",",        
            insert_box_xdim/block_xdim,",",
            insert_box_ydim/block_ydim,
            "<<"
            ));
    }
    
    // echoes column & block counters only like: (this is what bash script is looking for)
    // ECHO: ">col:4<col"
    // ECHO: ">row:7<row"
    if (output_flag == 2) {
        echo (str(
            ">col:",
            insert_box_xdim/block_xdim,
            "<col"
        ));
        
        echo (str(
            ">row:",
            insert_box_ydim/block_ydim,
            "<row"
        ));      
    } 
}




  