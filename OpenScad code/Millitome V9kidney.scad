// Millitome organ cutter V9
//  developer: Peter Kienle, CNS
//
// dimensions are in mm
// when exporting to STL, may have to be divided by 10 during or after import into Blender to preserve scale
//
// VHFLeftKidney dimensions from HuBMAP:
//  "x_dimension": 73.11071700000001,
//  "y_dimension": 124.85636100000005,
//  "z_dimension": 77.579546,

// Measurements from C4D Left_Kidney_Orientation
//  X=73.43 (width)
//  Y=64.04 (height)
//  Z=132.75
//
// V9   2022-3-17
//  - added support for independent block dimensions
//  - added support to enter block counts in both directions
//  - letters/numbers/IDs will resize and reposition to fit
// V9   2022-3-25
//  - added "type" switch for type 1,2,3, selects inner frame size accordingly
//  - on type 3, exact x and y values are used (no rounding up), omits extra col & row
// V9   2022-4-2
//  - added two digit row numbers (this is a bit of a hack, only works to 19)
//  - this affects block array & insert
// V9   2022-4-8
//  - fixed organ model scaling (uncommented scale commands in import)
//  - added printed kidney dimensions and percentage


// display and rendering system defaults - don't change
$fa = 1;
$fs = 0.4;


// Important! In OpenSCAD looking from top down 
//              In RUI looking front, need to re-assign x,y,z!

//================================================================
// exposed variables-------use to adjust dimensions
//================================================================
organ_scale     = 0.85;   // scale 1 = 100%, 1.1 = 110% etc

// Dimensions of kidney - these have to be as accurate as possible
// all other enclosure dimensions are derived from these
// 
organ_xdim      = 73 * organ_scale;
organ_ydim      = 131 * organ_scale;
organ_zdim      = 64 * organ_scale;


// user settings -- technically the only user input happens here
type            = 3;    // 1 = fixed block size, 2 = user block size, 3 = user block count

block_size      = 20;   // used for mode 1, fixed block size for cubes, only used there

block_xsize     = 15;   // used for mode 2, different x/y block size
block_ysize     = 20;

blocks_x        = 4;    // used for mode 3, number of blocks along x, used for calculated block_size
blocks_y        = 7;    // number of blocks along y

//================================================================
//construction variables - no need for user access
//================================================================
wall_width      = 20; // thickness for walls and bottoms
wall_height     = 20; // height of outer box wall
bottom_height   = 10; // thickness of bottom of outer box (don't use if printing single MT)

inner_frame_block  = 20;   // inner frame block size around insert

cut_width       = 1; // width of cutting tool
cut_depth       = 1; // how far to cut below specimen

start_character = 65; // is A
start_number    = 49; // is 0

//================================================================
// object staging area
//  uncomment function(s) to be executed when running program
//================================================================
//===these three functions produce a full millitome with the requested parameters, for 3d printing
//insert();                       // area immediately surrounding the organ, with organ mold
//inner_frame_with_letters();     // enclosure around insert, with column/row identifiers on each block
//outer_frame();                  // outer frame, with cutting slots, higher than inner frame, not really necessary

//===produces matching block array, for use in RUI selection interface 
//block_array_with_letters();     // blocks, dissectiong the actual organ, each block has a ID label

//===produces a display of organ percentage user setting and resulting dimensions of organ
//dimensions();                   // these are shown top/left of inner frame, outer frame will cover them

//===shows the 3d model of the used organ for reference
//kidney();                       // kidney is rendered at user selected scale


//========following functions produce individual components; for documentation, etc, makes it easier to texture
//inner_frame();                  // inner frame (enclosure) around insert, no col/row IDs are produced
//block_array();                  // blocks, dissectiong the actual organ, no ID labels are produced
//letter_array(start_character);  // produces the column IDs (letters A,B,C.....) for inner frame
//number_array(start_number);     // produces the row IDs (numbers 1,2,3,4....) for inner frame
//block_ids(start_character,start_number); // produces ID labels for block array   

//========basic components, for debugging and documentation
//column_slot_array();            // virtual blades cutting column slots in all components which need them
//row_slot_array();               // virtual blades cutting row slots in all components which need them
//insert_frame();                 // box with the organ mold 

//inner_box_hollow();             // inner frame without cutting slots
//outer_box_hollow();             // outer frame without cutting slots

//========most basic components, just boxes for various components
//bounding_box();                 // box enclosing the organ exactly 
//insert_box();                   // dimensions of insert (varies with selected mode (type))
//inner_box();                    // dimensions of inner frame box (type dependent)                     
//outer_box();                    // dimensions of outer frame box (type dependent)
//block_box();                    // dimensions of block array box (type dependent)

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
3block_xdim      = organ_xdim/blocks_x;
3block_ydim      = organ_ydim/blocks_y;

// put block sizes in x and y lists, we can then retrieve what we need based on type parameter as index
xlist = [1block_xdim,2block_xdim,3block_xdim];
ylist = [1block_ydim,2block_ydim,3block_ydim];

// fetch block sizes according to requested type
block_xdim      = xlist[type-1];
block_ydim      = ylist[type-1];

// insert box dim., rounded to next full blocksize, mode 1&2 only
1insert_box_xdim = (((organ_xdim-(organ_xdim % block_xdim))/block_xdim)*block_xdim)+block_xdim;  // next full block_size
1insert_box_ydim = (((organ_ydim-(organ_ydim % block_ydim))/block_ydim)*block_ydim)+block_ydim;  // next full block_size

// insert box dim., no-rounding, mode 3 only
3insert_box_xdim = organ_xdim;
3insert_box_ydim = organ_ydim;

//evaluate mode flag and select appropriate size
insert_box_xdim= type<3 ? 1insert_box_xdim:3insert_box_xdim;
insert_box_ydim= type<3 ? 1insert_box_ydim:3insert_box_ydim;

insert_box_zdim = organ_zdim/2+bottom_height;

// inner_frame_box dim., based on insert dim., added block_size around
inner_box_xdim  = insert_box_xdim+2*inner_frame_block;  
inner_box_ydim  = insert_box_ydim+2*inner_frame_block;
inner_box_zdim  = insert_box_zdim+bottom_height;

// outer_frame_box dim., based on inner_frame_box dim., added spill_width around
outer_box_xdim  = inner_box_xdim+2*wall_width;
outer_box_ydim  = inner_box_ydim+2*wall_width;
outer_box_zdim  = inner_box_zdim+wall_height+bottom_height;


//================================================================
// here the actual functions
//================================================================

// insert_box=====================================================
// size x/y is calculated to the next full block, aligned to origin, the mold cutout goes in here
module insert_box() {
    color("crimson")
    translate([0,-insert_box_ydim,-(insert_box_zdim)]) 
        cube([insert_box_xdim,insert_box_ydim,insert_box_zdim]);
}

// used to cut insert_box opening into inner_box to make inner_frame
module insert_box_cut() {
    translate([0,-insert_box_ydim,-organ_zdim/2]) 
        cube([insert_box_xdim,insert_box_ydim,insert_box_zdim+wall_height]);      
}

// insert_box with organ mold cutout
module insert_frame() {
    difference() {
        insert_box();
        kidney();      
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


// inner box======================================================
// raw frame box: rows & cols of blocks around insert_box, should contain labeling, slotted
module inner_box() {
    color("magenta")
    translate([-inner_frame_block,-(inner_box_ydim-inner_frame_block),-(inner_box_zdim)])
        cube([inner_box_xdim,inner_box_ydim,inner_box_zdim]);    
}

// used to cut inner_box opening into outer_box to make outer_frame
module inner_box_cut() {
     translate([-inner_frame_block,-(inner_box_ydim-inner_frame_block),-(insert_box_zdim/2+block_size)])
        cube([inner_box_xdim,inner_box_ydim,outer_box_zdim]);       
}

// inner_box with insert_box coutout
module inner_box_hollow() {
    difference() {
        inner_box();
        insert_box_cut();
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

// inner_frame with slots and letters
module inner_frame_with_letters() {
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
module block_box() {
 color("lightgreen")
    translate([0,-insert_box_ydim,-organ_zdim/2]) 
    cube([insert_box_xdim,insert_box_ydim,organ_zdim/2]);
}

module block_array() {
    difference() {
        block_box();
        column_slot_array();
        row_slot_array();
    }
}

module block_array_with_letters() {
    block_array();
    block_ids(start_character,start_number);
}


//kidney==========================================================
// kidney import, aligned to top/left origin, z aligned to bisection plane
module kidney() {
    scale([organ_scale,organ_scale,organ_scale])
    rotate([0,0,0])
        translate([0,0,0])
            import("VHFKidney_L_aligned_new.stl",convexity=3);
}

// exact perimeter around the organ, based on organ dimensions
module bounding_box() {
    color("RoyalBlue")
    translate([organ_xdim/2,-organ_ydim/2,0])
        cube([organ_xdim,organ_ydim,organ_zdim],center=true);
}




// column slots============================================
// column cutting slot 
module column_slot() {  
    translate([-cut_width,-outer_box_ydim+block_ydim,-(organ_zdim/2+cut_depth)])
        cube([cut_width,outer_box_ydim+wall_width*2,organ_zdim+wall_height]);
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
    translate([-(block_xdim*2+wall_width),0,-(organ_zdim/2+cut_depth)])
        cube([outer_box_xdim+wall_width*2,cut_width,organ_zdim+wall_height]);
}

// row slot array
module row_slot_array() {
    for (dy = [0:-block_ydim:-insert_box_ydim]) {
        translate([0,dy,0])
            row_slot();
    }
}


// block numbering & lettering=============================== 

// all numbers, line feed depends on block_ydim
module number_array(character) {
    for (dy = [0:-block_ydim:-insert_box_ydim+block_ydim]) {
        translate([0,dy,0])
        block_number(character+(-dy/block_ydim));
    }
}

// output one number character, position shifted, font size adjusted
module block_number(character) {
    //for character centering in x (y can stay static) 
    font_size   = block_ydim/2;
    font_width  = font_size/1.375;
    font_gap    = (inner_frame_block-font_width)/2;
    
    linear_extrude(1)
    translate([-(font_width+font_gap),-block_ydim*0.75,0])    //-inner_frame_block*0.75
    
    if (character < start_number+9)
    {
        text(chr(character),size=font_size);
    } else
    {      
        text(chr([49,character-10]),size=font_size);
    }
}

// all letters, col. feed depends on block_xdim================
module letter_array(character) {
    for (dx = [0:block_xdim:insert_box_xdim-block_xdim]) {
        translate([dx,0,0])
        block_letter(character+dx/block_xdim);        
    }
}

// output one letter character, position shifted, font size&position adjusted
module block_letter(character) {
    font_size   = block_xdim/2;
    font_gap    = (inner_frame_block-font_size)/2;
    
    linear_extrude(1)
    translate([block_xdim*0.25,font_gap,0])
    text(chr(character),size=font_size);
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
    
    //echo(block_dim,font_size,font_width,id_width,font_gap);
    
    linear_extrude(1)
    translate([font_gap,-block_ydim*0.65,0])
    //text(chr([character,number]),size=font_size); // original
    
    if (number < start_number+9)
    {
        text(chr([character,number]),size=font_size);
    } else
    {      
        text(chr([character,49,number-10]),size=font_size);
    }  
}

// show dimensions=====================================
// draws organ percentage, x and y dimensions of organ top/left
module dimensions()
{
    font_size   = block_xdim/2;
    
    // dim x
    linear_extrude(1)
    translate([-block_xdim,block_ydim,0])
    text(str(organ_xdim),size=font_size);
    
    // dim y
    linear_extrude(1)
    translate([-block_xdim,-block_ydim,0])
    rotate([0,0,90])
    text(str(organ_ydim),size=font_size);
    
    // scaling percentage
    linear_extrude(1)
    translate([-block_xdim,block_ydim*1.5,0])
    text(str(organ_scale*100,"%"),size=font_size*1.2);
}




  