

// f_9_kidney_y (added for test 2023-5-30)
//  x = 66.11
//  ymin = -29.47
//  ymax = 32.32
//  yreal = 58.93
//  z = 133.67
// - extended numbers
// step 2 BB
// Px = 7.687
// Py = 23.82
// Pz = 9.942
// step 2 organ
// Px = -7.687
// Py = -23.82
// Pz = -9.942
// step 4 rotation
// Rx = 112
// Ry = 9.5
// Rz = 0
// step 5 butterfly mesh axis =100,0,100
// Px = -3.112
// Py = 0.082
// Pz = 6.623
// step 7 organ out of harness
// Px =	-8.73
// Py =	-0.376
// Pz =	17.564
// Rx =	112
// Ry =	9.5	
// Rz = 0

bounding_box();
//organ_rotated();
organ_source();

// female organ list, dimensions are rounded up
// main file name, x, z, ymin, ymax, yreal
organ_list = [
    ["f_0_kidney_l.stl",65.53,133.68,-31.17,31.1,62.27],
    ["f_1_kidney_r.stl",63,111,-29,29,58],
    ["f_2_spleen.stl",75.86,116.79,-25.4,25.43,50.8],
    ["f_3_pancreas.stl",57.86,178.31,-37.2,27.5,74.41],
    ["f_4_banana.stl",60.68,178.5,-16.42,16.42,49.42],
    ["f_5_gpancreas.stl",49.6,178.68,-24.71,24.71,49.42],
    ["f_6_ovary_l.stl",9.59,25.41,-3.99,3.67,7.97], 
    ["f_7_ovalry_l.stl",20.02,30.05,-10.06,10.06,20.12],
    ["f_8_ovalry_l_penn.stl",30.01,60.01,-10.06,10.06,20.12],
    ["f_9_kidney_y.stl",66.11,133.67,-29.47,32.32,58.93],
	["f_10_pnnl_pancreas.stl",64.64,241.16,-32.64,32.64,65.28],
    ["f_11_pnnl_pancreas_head.stl",55.9,68.65,-30.85,30.85,61.71],
    ["f_12_pnnl_pancreas_nothead.stl",61.17,168.24,-32.64,32.64,65.28]
];

scaling_factor = 1;

filename    = 0;    // organ_list member offsets
dimx        = 1;
dimy        = 2;
dimz_min    = 3;    // how much below baseline
dimz_max    = 4;    // how much above baseline
dimz_real   = 5;    // full height of organ, should be (abs(z_min))+z_max (or 2*z_max)



organID = 9;
organ_properties    = organ_list[organID];      // retrieve property list for this organ, organID is selector

organ_file      = organ_properties[filename];   // retrieve properties from list entry
organ_xdim      = organ_properties[dimx] * scaling_factor;
organ_ydim      = organ_properties[dimy] * scaling_factor;

organ_zmin      = organ_properties[dimz_min] * scaling_factor;
organ_zmax      = organ_properties[dimz_max] * scaling_factor;
organ_zreal     = organ_properties[dimz_real] * scaling_factor;

organ_zdim      = organ_zreal;





module organ_rotated() {
translate([0,0,0])
    rotate([-112,-9.5,0])
        color("lightblue")
        import("organs/f_9_kidney_y.stl",convexity=3);
}

module organ_source(){
rotate([0,00,0])
    color("indianred")
    import ("organs/kidney_y_source.stl",convexity=3);
}


// exact perimeter around the organ, based on organ dimensions
module bounding_box() {
    color("RoyalBlue")
    translate([76.87,99.42,238.2])
    //translate([87.3,3.76,175.64])
        rotate([-112,-9.5,0])
        cube([organ_xdim,organ_ydim,organ_zdim],center=true);
}