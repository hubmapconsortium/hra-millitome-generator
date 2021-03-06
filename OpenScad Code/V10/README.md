# Millitome Generator V10

![Millitome Generator V10!](images/Millitome-Generator-V10.png "Millitome Generator V10")

Implemented in OpenScad 2021.01.<br>


# Folder Contents

### images
This folder contains images used for documentation. Not required for proper operation of *Millitome Generator V10*.

### organs
Contains 24 files in STL format, used by *Millitome Generator V10* to cut the correct mold shapes. This folder must reside in the same directory from which *Millitome Generator V10.scad* is launched.

There are three STL files for each organ:

Edited, simplified geometry of left female kidney:<br>
*f_0_kidney_l.stl*<br>
![f_0_kidney_l.png!](images/f_0_kidney_l.png "f_0_kidney_l.png")

Model with straight extended top; used to cut bottom molds:<br>
*_bf_0_kidney_l.stl*<br>
![_bf_0_kidney_l.png!](images/_bf_0_kidney_l.png "_bf_0_kidney_l.png")

Model with straight extended bottom; used to cut top molds:<br>
*_tf_0_kidney_l.stl*<br>
![_tf_0_kidney_l.png!](images/_tf_0_kidney_l.png "_tf_0_kidney_l.png")

### Millitome Generator V10.scad
Program code to be run in Openscad.

# Configuration 

## Customization variables
### Organ selection

gender:<br> 
0 = female<br>
1 = male<br>

organ_id:<br>
0 = kidney_l<br>
1 = kidney_r<br>
2 = spleen<br>
3 = pancreas<br>

organ_scale:<br>
1 = 100%<br>
1.15 = 115%<br>
0.85 = 85%<br>

### Blocking mode and properties
type:<br>
1 = fixed block size, length & width are equal<br>
2 = user block size, length & width are different<br>
3 = user block count, count of blocks along length & width<br><br>

block_size:<br>
in millimeters, used for type 1, all blocks are equal length & width<br>

block_xsize, block_ysize:<br>
in millimeters, used for type 2, length & width are different<br>

blocks_x:<br>
used for type 3, number of blocks along X (width), number of blocks = full organ width/blocks_x<br>
blocks_y:<br>
number of blocks along Y (length)<br>

## Object generation functions

These functions are in the Object Generation Area. To generate exportable geometry from OpenScad, uncomment any of the functions in the list below. Click the Preview button for quick preview. Click the Render button to generate geometry then Export As STL.<br>

### full millitome with the requested parameters, for 3d printing

> complete_bottom();  // bottom half of millitome
> 
> complete_top();   //top half of millitome

### matching block array functions, for use in RUI selection interface or illustrations

> blockbottom_cutout();    // blocks overlapping with the organ, for illustration, bottom
> 
> blocktop_cutout();    // same for top
> 
> blockbottom_array();    // blocks, dissecting the actual organ, no ID labels are produced, bottom
> 
> blocktop_array();    // same for top  
> 
> block_ids(start_character,start_number);    // produces ID labels for block array, for illustration
> 
> block_array_with_letters();    // blocks, dissectiong the actual organ, each block has a ID label


### often used components

> insert();    // area immediately surrounding the organ, with organ mold
> 
> inserttop();    // same for top
> 
> inner_frame_with_letters();    // enclosure around insert, with column/row identifiers on each block
> 
> innertop_frame_with_letters();    // same for top,row of letters if reverse
>
> outer_frame();    // outer frame, with cutting slots, higher than inner frame, not really necessary


### display of organ percentage user setting, organ name & size, millitome dimensions in console (look for ECHO:)

> dimensions(); 

### shows the 3d model of the used organ for reference

> organ();


### following functions produce individual components; for documentation, etc, makes it easier to texture

> inner_frame();    // inner frame (enclosure) around insert, no col/row IDs are produced
> 
> innertop_frame();    // same for top
> 
> insert_frame();    // mold cutout without slots
> 
> inserttop_frame();    // same for top
> 
> letter_array(start_character);    // produces the column IDs (letters A,B,C.....) for inner frame
> 
> lettertop_array(start_character);    // same for top
> 
> number_array(start_number);    // produces the row IDs (numbers 1,2,3,4....) for inner frame
> 
> numbertop_array(start_number);    // same for top
> 
> layer_info_top();    // produces "t" identifier in top layer
> 
> layer_info_bottom();    // produces "b" identifier in bottom layer


### basic components, for debugging and documentation

> column_slot_array();    // virtual blades cutting column slots in all components which need them
> 
> row_slot_array();    // virtual blades cutting row slots in all components which need them
> 
> organ_top();    // organ to cut the top half, extended on bottom, used for mold cutting
> 
> organ_bottom();    // same for top
> 
> inner_box_cut();    // makes the hole in inner_frame()
> 
> innertop_box_cut();    // same for top
> 
> inner_box_hollow();    // inner frame without cutting slots
> 
> innertop_box_hollow();    // same for top
> 
> outer_box_hollow();    // outer frame without cutting slots, probably not used

### most basic components, just boxes for various components

> outer_box();    // dimensions of outer frame box (type dependent)
> 
> bounding_box();    // box enclosing the organ exactly
> 
> insert_box();
> 
> inserttop_box();
> 
> inner_box();    // box for inner part
> 
> innertop_box();    // same for top
> 
> blockbottom_box();    // dimensions of block array box (type dependent)
> 
> blocktop_box();    // same for top
