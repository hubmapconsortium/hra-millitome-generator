// Millitome Generator V10
//  developer: Peter Kienle, CNS


// V10  2022-4-26
//  - not sure how to handle block_array_ids
//  todo: male spleen & all female organs, align at y-center and make _t & _b files
//  2022-4-26
//  - added blocktop_array & intersection with organ  
//  2022-4-27
//  - added top millitome (inserttop,innertop_frame...etc)
//  2022-4-28
//  - all simple organs added in three iterations
//  2022-5-12
//  - added top/bottom layer "t","b" ID in top left corner of each MT, vertical alignment!!
//  2022-5-14
//  - added female pancreas
//  2022-5-16
//  - added male pancreas
//  - outer_frame() needs update if ever used again
//  2022-5-17
//  - added support for row numbers above 20 for blocks and insert
//  - fixed issue with block_array() -> blockbottom_array()
//  - added dimensions() output in console (look for ECHO: statements)
//  2022-5-18
//  - organ files now aquired from organ_folder 
//  2022-5-26
//  - dimension adjustments after test print (construction variables)
//  - changed: bottom_height=6, inner_frame_block=15, cut_width=2
//  - adjusted coordinate system letters/number sixe and position
//  - fixed wrong dimensions of insert_box_cut() & inserttop_box_cut()


// dimensions are in mm
//
// in 3D editor usually X & Z are in the plane, Y is height ==> OpenScad reverses Y<==>Z!!
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
// exposed variables-------use to select:
//  - gender    0 = female, 1 = male
//  - organ     0 = kidney_l, 1 = kidney_r, 2 = spleen, 3 = pancreas
//  - scale     1 = 100%, 1.15 = 115%, 0.85 = 85%
//  - blocking mode and properties
//================================================================
gender          = 1;    // 0=female, 1=male, needs to be integer selector
organ_id        = 1;    // index for list lookup     
organ_scale     = 0.5;    // scale 1 = 100%, 1.1 = 110% etc

type            = 1;    // 1 = fixed block size, 2 = user block size, 3 = user block count

block_size      = 10 ;   // used for type 1, fixed block size for cubes, only used there

block_xsize     = 10;   // used for type 2, different x/y block size
block_ysize     = 20;

blocks_x        = 2;    // used for type 3, number of blocks along x, used for calculated block_size
blocks_y        = 7;    // number of blocks along y

//================================================================
// Object Generation Area
//  uncomment function(s) to be executed when running program
//================================================================

//=== full millitome with the requested parameters, for 3d printing
//complete_bottom();            // bottom half of millitome
complete_top();               // top half of millitome


//===matching block array functions, for use in RUI selection interface or illustrations
//blockbottom_cutout();         // blocks overlapping with the organ, for illustration, bottom
//blocktop_cutout();            // same for top

//blockbottom_array();          // blocks, dissecting the actual organ, no ID labels are produced, bottom
//blocktop_array();             // same for top  

//block_ids(start_character,start_number); // produces ID labels for block array, for illustration
//block_array_with_letters();     // blocks, dissectiong the actual organ, each block has a ID label


//-----often used components
//insert();                       // area immediately surrounding the organ, with organ mold
//inserttop();                    // same for top
//inner_frame_with_letters();     // enclosure around insert, with column/row identifiers on each block
//innertop_frame_with_letters();  // same for top,row of letters if reverse
//outer_frame();                  // outer frame, with cutting slots, higher than inner frame, not really necessary


//===display of organ percentage user setting, organ name & size, millitome dimensions in console (look for ECHO:)
dimensions(); 

//===shows the 3d model of the used organ for reference
//organ();


//========following functions produce individual components; for documentation, etc, makes it easier to texture
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
//column_slot_array();            // virtual blades cutting column slots in all components which need them
//row_slot_array();               // virtual blades cutting row slots in all components which need them  

//organ_top();                    // organ to cut the top half, extended on bottom, used for mold cutting  
//organ_bottom();                 // same for top

//inner_box_cut();                // makes the hole in inner_frame()
//innertop_box_cut();             // same for top
//inner_box_hollow();             // inner frame without cutting slots
//innertop_box_hollow();          // same for top
//outer_box_hollow();             // outer frame without cutting slots, probably not used

//========most basic components, just boxes for various components                 
//outer_box();                    // dimensions of outer frame box (type dependent)
//bounding_box();                 // box enclosing the organ exactly
//insert_box();
//inserttop_box(); 

//insert_box_cut();
//inserttop_box_cut();

//inner_box();                    // box for inner part
//innertop_box();                 // same for top

//blockbottom_box();              // dimensions of block array box (type dependent)
//blocktop_box();                 // same for top

//================================================================
// construction variables - no need for user access
//================================================================
wall_width      = 20;       // thickness for walls and bottoms
wall_height     = 20;       // height of outer box wall
bottom_height   = 5;       // was 10; thickness of bottom of outer box (don't use if printing single MT)

inner_frame_block  = 15;    // was 20; inner frame block size around insert

cut_width       = 2;        // was 1; width of cutting tool
cut_depth       = 1;        // how far to cut below specimen

start_character = 65;       // is A - for column letters
start_number    = 49;       // is 0 - for row numbers

type_thickness  = 1;        // thickness of letters (extrusion into +Z)

organ_folder    = "organs/";// location of organ models

//================================================================
// organ definitions
//  filename,x,y,z_min,z_max,z_real
//
// Dimensions of organs - these have to be as accurate as possible - but rounded up to next integer
// all other enclosure dimensions are derived from these
// 
//================================================================
filename    = 0;    // organ_list member offsets
dimx        = 1;
dimy        = 2;
dimz_min    = 3;    // how much below baseline
dimz_max    = 4;    // how much above baseline
dimz_real   = 5;    // full height of organ, should be (abs(z_min))+z_max (or 2*z_max)


// Important! In OpenSCAD we are looking from top down 
//  In RUI looking from front, need to re-assign: x=>x, y<==>z
//
// f_0_kidney_l 
//  X=65.53
//  ymin = -31.17
//  ymax = 31.1
//  Y = 62.33
//  Z = 133.68

// f_1_kidney_r
//  x = 63.03
//  ymin = -28.79
//  ymax = 28.76
//  yreal = 57.57
//  z = 110.24

// f_2_spleen
//  x=75.86
//  ymin = -25.4
//  ymax = 25.43
//  yreal = 50.8
//  z = 116.79

// f_3_pancreas
//  x = 61.39
//  ymin = -28.1
//  ymax = 27.89
//  yreal = 56.21
//  z = 181.17

// female organ list
organ_list_f = [
    ["f_0_kidney_l.stl",66,134,-32,32,64],
    ["f_1_kidney_r.stl",63,111,-29,29,58],
    ["f_2_spleen.stl",76,117,-26,26,52],
    ["f_3_pancreas.stl",62,182,-28,28,56]
];


// m_0_kidney_l
//  x = 72
//  ymin = -24.31
//  ymax = 24.25
//  yreal = 48.56
//  z = 121.81

// m_1_kidney_r
//  x = 68.4
//  ymin = -21.88
//  ymax = 21.89
//  yreal = 43.76
//  z = 124.67

// m_2_spleen
//  x = 83.52
//  ymin = -31.7
//  ymax = 31.72
//  yreal = 63.41
//  z = 140.02

// m_3_pancreas
//  x = 57.51
//  ymin = -19.27
//  ymax = 19.29
//  yreal = 38.56
//  z = 135.56

// male organ list
organ_list_m = [
    ["m_0_kidney_l.stl",72,122,-25,25,50],  
    ["m_1_kidney_r.stl",69,125,-22,22,44],
    ["m_2_spleen.stl",84,140,-32,32,64],
    ["m_3_pancreas.stl",58,136,-20,20,40]
];


organ_lists = [organ_list_f,organ_list_m];      // gender ID selects organ_list from here
organ_list  = organ_lists[gender];              // female or male organ_list, gender is selector

organ_properties    = organ_list[organ_id];     // retrieve property list for this organ, organ_id is selector

organ_file      = organ_properties[filename];   // retrieve properties from list entry
organ_xdim      = organ_properties[dimx] * organ_scale;
organ_ydim      = organ_properties[dimy] * organ_scale;

organ_zmin      = organ_properties[dimz_min] * organ_scale;
organ_zmax      = organ_properties[dimz_max] * organ_scale;
organ_zreal     = organ_properties[dimz_real] * organ_scale;

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

//insert_box_zdim = organ_zdim/2+bottom_height;
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

// insert_box=====================================================
// size x/y is calculated to the next full block, aligned to origin, the mold cutout goes in here

module insert_box() {
    color("crimson")
    translate([0,-insert_box_ydim,-(insert_box_zdim)]) 
        cube([insert_box_xdim,insert_box_ydim,insert_box_zdim]);
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


// inner_frame with slots and letters
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


//organ==========================================================
// organ import, aligned to top/left origin, z aligned to bisection plane

// imports regular organ polygon for display/rendering
module organ() {
    scale([organ_scale,organ_scale,organ_scale])
    rotate([0,0,0])
        translate([0,0,0])
          //  import(organ_file,convexity=3);
            import(str(organ_folder,organ_file),convexity=3);
}

// imports top-extended organ for mold-cutting in bottom box, name front extension
module organ_bottom() {
    scale([organ_scale,organ_scale,organ_scale])
    rotate([0,0,0])
        translate([0,0,0])
            import(str(organ_folder,"_b",organ_file),convexity=3);
}

// imports bottom-extended organ for mold-cutting in top box, name front extension
module organ_top() {
    scale([organ_scale,organ_scale,organ_scale])
    rotate([0,0,0])
        translate([0,0,0])
            import(str(organ_folder,"_t",organ_file),convexity=3);
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
    translate([-(font_width+font_gap),-block_ydim*0.6,0])    //-inner_frame_block*0.75
    
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

// show dimensions=====================================
// draws organ percentage, x and y dimensions of organ top/left
module dimensions()
{
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
//            text(str(organ_scale*100,"% ",organ_file),size=font_size*1.2);

    echo(str("Organ Scale & Type: ",organ_scale*100,"% ",organ_file));
    echo(str("Organ dimensions: X = ",organ_xdim," Y = ",organ_ydim));  
    // dimensions of inner_box() = full perimeter size of millitome
    echo(str("Millitome dimensions: X = ",inner_box_xdim," Y = ",inner_box_ydim," Z = ",inner_box_zdim+type_thickness));
 
}




  