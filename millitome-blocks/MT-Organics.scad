// Millitome Organics V15.001
//  developer: Peter Kienle, CNS

// V15  2023-3-14
//  2023-3-16   adjustments for Z=100% (whole organ is z positive)
//  2023-3-14   corrected alignment for multilayer and correct origin
//  2023-3-5    add generics
//  -added bounding_box_buffer, added to bounding box dimensions to ensure organ fits completely inside
// check in mt-organs.config which organs are updated already

// everything new is in organBlock section
// this runs stand-alone for individual segments as declared in Object Generation Area
// or is called from mt_organics.bash
// 

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
//  - organ_scaleID 0=large (115%, 1.15), 1=medium (100%, 1), 2=small (85%, 0.85)
//  - asset_typeID  6=organblocks, 7=boxblocks

//  - output_flag   0=ECHO everything, 1=ECHO insert line only, 2=ECHO col/row insert ONLY

//  - count_x       number of matrix segments along x
//  - count_y       number of matrix segments along y
//  - count_z       number of matrix segments along z

//  - location_x    specific block to cut along x (width,columns, A-Z)
//  - location_y    specific block to cut along y (length, rows, 1-n)
//  - location_z    specific block to cut along z (height, layers, I-r; roman numerals)

//================================================================

//======properties configuration list. When called from bash script these are overridden
genderID        = 0;    // 0=female, 1=male, 2=generic
organID         = 9;    // index for list lookup
organscale      = 100;  // scale as percentage

typeID          = 2;    // 0=fixed block size, 1=user block size, 2=user block count

// segment counts along three available axis
count_x          = 2;
count_y          = 3;
count_z          = 2;  

// specific segment to cut (values must not be greater than total segments counts, above)
location_x      = 0;    // wide (A-Z)
location_y      = 0;    // long (1-n)
location_z      = 1;    // high (I-r, roman numerals)

generic_x       = 50;
generic_y       = 80;
generic_z       = 40;

asset_typeID    = 6;    // 6=organblocks, 7=boxblocks, 0=organ
//=======END configuration============

block_size      = 20 ;  // used for type 0, uniform x/y block size for cubes

block_xsize     = 10;   // used for type 1, different x/y block size
block_ysize     = 20;

blocks_x        = 2;    // used for type 2, number of blocks along x, used for calculated block_size
blocks_y        = 5;   // number of blocks along y

output_flag     = 0;    // 0=ECHO everything, 1=ECHO insert line only, 2=ECHO col/row insert ONLY

//================================================================
// Object Generation Area
//  uncomment function(s) to be executed when running program
//================================================================
if (asset_typeID == 6) organblocks();
if (asset_typeID == 7) boxblocks();
if (asset_typeID == 0) organ();
if (asset_typeID == 1) bounding_box();
if (asset_typeID == 2) cutBlock(location_x,location_y,location_z);
    
module organblocks() {
    organBlock(location_x,location_y,location_z);
}

module boxblocks() {
    boxBlock(location_x,location_y,location_z);
}

//bounding_box();                 // box enclosing the organ exactly
//organ();

//stamper();
//selective(1,3,1);
//organBlock(1,3,1);



/*
module model()
    organBlock(1,3,1);
    
//model();
  color("red") 
%bbox() model();

module bbox() { 

    // a 3D approx. of the children projection on X axis 
    module xProjection() 
        translate([0,1/2,-1/2]) 
            linear_extrude(1) 
                hull() 
                    projection() 
                        rotate([90,0,0]) 
                            linear_extrude(1) 
                                projection() children(); 
  
    // a bounding box with an offset of 1 in all axis
    module bbx()  
        minkowski() { 
            xProjection() children(); // x axis
            rotate(-90)               // y axis
                xProjection() rotate(90) children(); 
            rotate([0,-90,0])         // z axis
                xProjection() rotate([0,90,0]) children(); 
        } 
    
    // offset children() (a cube) by -1 in all axis
    module shrink()
   
      intersection() {
        translate([ 1, 1, 1]) children();
        translate([-1,-1,-1]) children();
      }

   shrink() bbx() children(); 
}

*/

    


//===display of organ percentage user setting, organ name & size, millitome dimensions in console (look for ECHO:)
// IMPORTANT: this must be activated when running from Terminal for automatic geometry/sheet creation
// output_flag parameter controls what information is shown in console
dimensions(); 

//===matching block array functions, for use in RUI selection interface or illustrations
//blockbottom_cutout();         // blocks overlapping with the organ, bottom
//blocktop_cutout();            // same for top

//blockbottom_array();          // blocks, intersecting the actual organ, no ID labels are produced, bottom
//blocktop_array();             // same for top  

//blockfull_box();              // both block 


//block_ids(start_character,start_number); // produces block array ID labels only
//block_array_with_letters();     // blocks, dissectiong the actual organ, each block has a ID label


//-----often used components, used for debugging
//insert();                       // area immediately surrounding the organ, with organ mold
//inserttop();                    // same for top
//inner_frame_with_letters();     // enclosure around insert, with column/row identifiers on each block
//innertop_frame_with_letters();  // same for top,row of letters if reverse
//outer_frame();                  // outer frame, with cutting slots, higher than inner frame (unused)

//===shows the 3d model of the used organ for reference


//========these functions produce individual components; for documentation, etc, makes it easier to texture
//inner_frame();                  // inner frame (enclosure) around insert, no col/row IDs are produced
//innertop_frame();                 // same for top
//insert_frame();                   // mold cutout without slots
//inserttop_frame();                // same for top

//letter_array(start_character);  // produces the column IDs (letters A,B,C.....) for inner frame
//lettertop_array(start_character); // same for top
//number_array(start_number);     // produces the row IDs (numbers 1,2,3,4....) for inner frame
//numbertop_array(start_number);    // same for top
//layer_info_top();                 // produces "t" identifier in top layer
//layer_info_bottom();              // produces "b" identifier in bottom layer


//========basic components, for debugging and documentation
//column_slot_array();            // virtual blades, cutting column slots in all components which need them
//row_slot_array();               // virtual blades, cutting row slots in all components which need them  

//organ_top();                    // organ to cut the top half, extended straight on bottom, used for mold cutting  
//organ_bottom();                 // same for top

//inner_box_cut();                // makes the hole in inner_frame()
//innertop_box_cut();             // same for top
//inner_box_hollow();             // inner frame without cutting slots
//innertop_box_hollow();          // same for top
//outer_box_hollow();             // outer frame without cutting slots (unused)

//========most basic components, just boxes for various components                 
//outer_box();                    // dimensions of outer frame box (unused)

//insert_box();                   // rastered box for insert
//inserttop_box(); 

//insert_box_cut();               // 
//inserttop_box_cut();

//inner_box();                    // box for inner part
//innertop_box();                 // same for top

//blockbottom_box();              // dimensions of block array box (type dependent)
//blocktop_box();                 // same for top

//====module test



//================================================================
// construction variables - no need for user access
//================================================================
wall_width      = 20;       // thickness for walls and bottoms - only for outer_box
wall_height     = 20;       // height of outer box wall
bottom_height   = 5;        // was 10; bottom thickness of inner_box & insert (*2 for full MT bottom thickness)

inner_frame_block  = 15;    // was 20; inner frame block size around insert

cut_width       = 0.1;      // was 1; width of cutting tool
cut_depth       = 1;        // how far to cut below specimen
bounding_box_buffer = 0.1;  // is added to organ size to make bounding box

start_character = 65;       // is A - for column letters
start_number    = 49;       // is 0 - for row numbers

type_thickness  = 1;        // vertical thickness of letters (extrusion into +Z)

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

generic_list = [
    ["generic",generic_x,generic_y,-generic_z/2,generic_z/2,generic_z]
];

include <mt-organs.config>;

echo (genderID);
// populate organ dimensions from organ_lists
organ_lists         = [organ_list_f,organ_list_m,generic_list];     // genderID ID selects organ_list from here
organ_list          = organ_lists[genderID];            // female, male or generic organ_list, genderID is selector
organ_properties    = organ_list[organID];      // retrieve property list for this organ, organID is selector

organ_file      = organ_properties[filename];   // retrieve properties from list entry
organ_xdim      = organ_properties[dimx] * scaling_factor;
organ_ydim      = organ_properties[dimy] * scaling_factor;

organ_zmin      = organ_properties[dimz_min] * scaling_factor;
organ_zmax      = organ_properties[dimz_max] * scaling_factor;
organ_zreal     = organ_properties[dimz_real] * scaling_factor;

// organ block section==========================================

blockSizeX      = organ_xdim/count_x;
blockSizeY      = organ_ydim/count_y;
blockSizeZ      = organ_zreal/count_z;

module selective(dX,dY,dZ)
{
    translate([dX*blockSizeX,dY*blockSizeY,dZ*blockSizeZ]) 
        cube([blockSizeX,blockSizeY,blockSizeZ]);
}

module cutBlock(dX,dY,dZ)
{   
    difference() {
        bounding_box();
        //translate([0,-organ_ydim,-organ_zmax])
        translate([0,-blockSizeY,0])
            //translate([dX*blockSizeX,dY*blockSizeY,dZ*blockSizeZ]) 
            translate([dX*blockSizeX,-dY*blockSizeY,dZ*blockSizeZ])
                cube([blockSizeX,blockSizeY,blockSizeZ]);
    }    
}

module organBlock(dX,dY,dZ) {
    difference() {
        organ();   
        cutBlock(dX,dY,dZ);
   }
     
}

module boxBlock(dX,dY,dZ) {
    difference() {
        bounding_box();
        cutBlock(dX,dY,dZ);
    }  
}


module stamper() {
     translate([0,-organ_ydim,-organ_zmax])
     for (dX = [0:1:count_x-1]) {
        for (dY = [0:1:count_y-1]) {
            for (dZ = [0:1:count_z-1]) {
                echo((str("X=",dX*blockSizeX," Y=",dY*blockSizeY," Z=",dZ*blockSizeZ)));
                 translate([dX*blockSizeX,dY*blockSizeY,dZ*blockSizeZ]) 
                    cube([blockSizeX,blockSizeY,blockSizeZ]); 
            }
        }
    }
}


//================================================================
// calculated dimensions, don't mess with these!
//================================================================
// Type 1, square blocks, x=y
1block_xdim      = block_size;
1block_ydim      = block_size;

// Type 2, rectangular blocks, x!=y
2block_xdim      = block_xsize;   // need to seperate x and y block size
2block_ydim      = block_ysize;  

// Type 3, number of blocks, user requested, dimensions => organ_size/no.of blocks
3block_xdim      = (organ_xdim+cut_width)/blocks_x;
3block_ydim      = (organ_ydim+cut_width)/blocks_y;

//echo ("3block_xdim=",3block_xdim," 3block_ydim=",3block_ydim);

// put block sizes in x and y lists, then retrieve what we need based on type parameter as index
xlist = [1block_xdim,2block_xdim,3block_xdim];
ylist = [1block_ydim,2block_ydim,3block_ydim];

// fetch block sizes according to requested type ID, corrected for 0 index
block_xdim      = xlist[typeID];
block_ydim      = ylist[typeID];

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



// exact perimeter around the organ, based on organ dimensions
module bounding_box() {
    color("RoyalBlue")
    //translate([(organ_xdim+bounding_box_buffer)/2,-(organ_ydim+bounding_box_buffer)/2,0])
    translate([(organ_xdim+bounding_box_buffer)/2,-(organ_ydim+bounding_box_buffer)/2,organ_zreal/2])
        cube([organ_xdim+bounding_box_buffer,organ_ydim+bounding_box_buffer,organ_zreal+(2*bounding_box_buffer)],center=true);
}

module organ() {
    if (genderID > 1) {generic();} else {organ_sub();}
}


// imports regular organ polygon for display/rendering
module organ_sub() {
    echo ("using organic");
    scale([scaling_factor,scaling_factor,scaling_factor])
    rotate([0,0,0])
        translate([0,0,0])
        //translate([0,0,organ_zreal/2])
          //  import(organ_file,convexity=3);
            import(str(organ_folder,organ_file),convexity=3);
}

// fake organ, generic ellipsoid
module generic() {
   echo ("using generic");
    //translate ([organ_xdim/2,-organ_ydim/2,0])
    translate ([organ_xdim/2,-organ_ydim/2,organ_zreal/2])
    scale ([organ_xdim,organ_ydim,organ_zreal])
        sphere (d = 1, $fa=1, $fs=0.1); // $fa, $fs used for better resolution
}



//================================================================
// functions
//================================================================

// make complete millitomes
module complete_top() {
    inserttop(); 
    innertop_frame_with_letters();
}
   
module complete_bottom() {
    insert();
    inner_frame_with_letters();
}

module complete_bottom_noID() {
    insert();
    inner_frame_with_letters_noID();
}
    

// insert_box=====================================================
// size x/y is calculated to the next full block, aligned to origin, the mold cutout goes in here

module insert_box() {
    color("crimson")
    translate([0,-insert_box_ydim,-(insert_box_zdim)]) 
        cube([insert_box_xdim,insert_box_ydim,insert_box_zdim]);
    // -remove later
    //echo(str("insert_box: ",insert_box_xdim,",",insert_box_ydim,",",insert_box_zdim));
}

module inserttop_box() {
    color("darkred")
    translate([0,-insert_box_ydim,0]) 
        cube([insert_box_xdim,insert_box_ydim,insert_box_zdim]);
}

// cut insert_box opening into inner_box to make inner_frame
module insert_box_cut() {
    translate([0,-insert_box_ydim,-(insert_box_zdim)]) 
        cube([insert_box_xdim,insert_box_ydim,insert_box_zdim+cut_width]);   
}

module inserttop_box_cut() {
    translate([0,-insert_box_ydim,-cut_width])
        cube([insert_box_xdim,insert_box_ydim,insert_box_zdim+cut_width]);    
}



// insert_box with organ mold cutout, use top-extended organ_bottom()
module insert_frame() {
    difference() {
        insert_box();
        organ_bottom(); 
    } 
}

// insert_box with organ mold cutout, use bottom-extended organ_top()
module inserttop_frame() {
    difference() {
        inserttop_box();
        organ_top();
    } 
}



// insert_frame with cut slots and mold
module insert() {
    difference() {
        insert_frame();
        column_slot_array();
        row_slot_array();
    }  
}

module inserttop() {
    difference() {
        inserttop_frame();
        column_slot_array();
        row_slot_array();
    }  
}



// inner box======================================================
// raw frame box: rows & cols of blocks around insert_box, should contain labeling, slotted

module inner_box() {
    color("magenta")
    translate([-inner_frame_block,-(inner_box_ydim-inner_frame_block),-(inner_box_zdim)])
        cube([inner_box_xdim,inner_box_ydim,inner_box_zdim]);  
      // -remove later
    echo(str("inner_box: ",inner_box_xdim,",",inner_box_ydim,",",inner_box_zdim));  
}

module innertop_box() {
    color("darkviolet")
    translate([-inner_frame_block,-(inner_box_ydim-inner_frame_block),0])
        cube([inner_box_xdim,inner_box_ydim,inner_box_zdim]);    
}
 

// used to cut inner_box opening into outer_box to make outer_frame
module inner_box_cut() {
     translate([-inner_frame_block,-(inner_box_ydim-inner_frame_block),-(insert_box_zdim/2+block_size)])
        cube([inner_box_xdim,inner_box_ydim,outer_box_zdim]);       
}

module innertop_box_cut() {
     translate([-inner_frame_block,-(inner_box_ydim-inner_frame_block),insert_box_zdim/2+block_size-outer_box_zdim])
        cube([inner_box_xdim,inner_box_ydim,outer_box_zdim]);       
}


// inner_box with insert_box coutout
module inner_box_hollow() {
    difference() {
        inner_box();
        insert_box_cut();
    }
}

module innertop_box_hollow() {
    difference() {
        innertop_box();
        inserttop_box_cut();
    }
}


// inner_frame with slots
module inner_frame() {
    difference() {
        inner_box_hollow();
        column_slot_array();
        row_slot_array(); 
    }  
}

module innertop_frame() {
    difference() {
        innertop_box_hollow();
        column_slot_array();
        row_slot_array(); 
    }  
}


// inner_frame with slots and letters and layer ID
module inner_frame_with_letters() {
    inner_frame();
    letter_array(start_character);
    number_array(start_number); 
    layer_info_bottom();
}

module innertop_frame_with_letters() {
    innertop_frame();
    lettertop_array(start_character);
    numbertop_array(start_number);
    layer_info_top();
}

// inner_frame with slots and letters
module inner_frame_with_letters_noID() {
    inner_frame();
    letter_array(start_character);
    number_array(start_number); 
}


// outer box======================================================
// outer frame, thickness=spill_width, adjustable height, slotted
module outer_box() {
    color("indigo")
    translate([-(inner_frame_block+wall_width),-(outer_box_ydim-inner_frame_block-wall_width),-(outer_box_zdim)+wall_height])
        cube([outer_box_xdim,outer_box_ydim,outer_box_zdim]);    
}

// outer_box with inner_box coutout
module outer_box_hollow() {
    difference() {
        outer_box();
        inner_box_cut();       
    } 
}

// outer_frame with slots
module outer_frame() {
    difference() {
        outer_box_hollow();
        column_slot_array();
        row_slot_array();  
    }
}


// block array=====================================================
// based on insert dimensions
module blockbottom_box() {
    color("lightgreen")
        translate([0,-insert_box_ydim,-organ_zreal/2]) 
        cube([insert_box_xdim,insert_box_ydim,organ_zreal/2]);
}

module blockbottom_array() {
    difference() {
        blockbottom_box();
        column_slot_array();
        row_slot_array();
    }
}

module blockbottom_cutout() {   
    intersection() {
        blockbottom_array();
        organ();  
  }    
}

// block_array ID letters; needed only for bottom
module block_array_with_letters() {
    blockbottom_array();
    block_ids(start_character,start_number);
}

module blocktop_box() {
    color("lightblue")
        translate([0,-insert_box_ydim,0])
        cube([insert_box_xdim,insert_box_ydim,organ_zreal/2]);
}

module blocktop_array() {
    difference() {
        blocktop_box();
        column_slot_array();
        row_slot_array();
    }
}

module blocktop_cutout() {
    intersection() {
        blocktop_array();
        organ();
    }
}


module blockfull_box()
{
    color("lightgreen")
    translate([0,-insert_box_ydim,-organ_zreal/2]) 
    cube([insert_box_xdim,insert_box_ydim,organ_zreal]);   
}

module blockfull_array()
{
    difference() {
        blockfull_box();
        column_slot_array();
        row_slot_array();
        bisection_box();
    }
}

// cut organ intro upper and lower sectors
module bisection_box() {
    color("lightgreen")
        translate([-(block_xdim*2+wall_width),-outer_box_ydim+block_ydim,-(cut_width/2)])
        cube([outer_box_xdim+wall_width*2,outer_box_ydim+wall_width*2,cut_width]);
}




module bisection_organ() {
    difference() {
        organ();
        column_slot_array();
        row_slot_array();
        bisection_box();
    }

}




//organ==========================================================
// organ import, aligned to top/left origin, z aligned to bisection plane



// imports top-extended organ for mold-cutting in bottom box, name front extension
module organ_bottom() {
    scale([scaling_factor,scaling_factor,scaling_factor])
    rotate([0,0,0])
        translate([0,0,0])
            import(str(organ_folder,"_b",organ_file),convexity=3);
}

// imports bottom-extended organ for mold-cutting in top box, name front extension
module organ_top() {
    scale([scaling_factor,scaling_factor,scaling_factor])
    rotate([0,0,0])
        translate([0,0,0])
            import(str(organ_folder,"_t",organ_file),convexity=3);
}





// column slots============================================
// column cutting slot 
module column_slot() {  
    translate([-cut_width,-outer_box_ydim+block_ydim,-(organ_zreal/2+cut_depth)])
        cube([cut_width,outer_box_ydim+wall_width*2,organ_zreal+cut_depth*2]);
}
 
// column slot array
module column_slot_array() {
    for (dx = [0:block_xdim:insert_box_xdim]) {
        translate([dx,0,0])
            column_slot();
    }
}


// row slots===============================================
// row cutting slot
module row_slot() {
    translate([-(block_xdim*2+wall_width),0,-(organ_zreal/2+cut_depth)])
        cube([outer_box_xdim+wall_width*2,cut_width,organ_zreal+cut_depth*2]);
}

// row slot array
module row_slot_array() {
    for (dy = [0:-block_ydim:-insert_box_ydim]) {
        translate([0,dy,0])
            row_slot();
    }
}

// block numbering & lettering=============================== 

// output one number character, position shifted, font size adjusted
module block_number(character) {
    //for character centering in x (y can stay static) 
    font_size   = block_ydim/2.5;
    font_width  = font_size/1.375;
    font_gap    = (inner_frame_block-font_width)/2;
    
    linear_extrude(type_thickness)
    translate([-(font_width+font_gap)-3,-block_ydim*0.6,0])    //-inner_frame_block*0.75
    
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
        translate([0,dy,0])
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
        translate([dx,0,0])
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

// create bottom layer info text ("b") in zero corner
module layer_info_bottom() {
    font_size   = block_xdim/2;
    font_width  = font_size/1.375;
    font_gap    = (inner_frame_block-font_width)/2;
    
    linear_extrude(type_thickness)
    translate([-(font_width+font_gap),wall_width*0.15,0])
    text("b",size=font_size);
}

// create top layer info text ("t") in zero corner
module layer_info_top() {
    font_size   = block_xdim/2;
    font_width  = font_size/1.375;
    font_gap    = (inner_frame_block-font_width)/2;
    
    translate([((insert_box_xdim/block_xdim)*block_xdim)+wall_width/2,wall_width*0.15,0])
    rotate([0,180,0])
    linear_extrude(type_thickness)    
    text("t",size=font_size);
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
        echo(str("Organ dimensions: X = ",organ_xdim," Y = ",organ_ydim," Z = ",organ_zreal));  
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




  