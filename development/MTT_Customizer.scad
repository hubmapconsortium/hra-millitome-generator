organs = ["kidney_l","kidney_r","spleen","pancreas","banana","vb_pancreas","ovary_l","ovalry_l","ovalry_l_penn"];

for


//organ           = "kidney_l";   // [kidney_l,kidney_r,spleen,pancreas,banana,vb_pancreas,ovary_l,ovalry_l,ovalry_l_penn]

module __Customizer_Limit__ () {}  // show in customizer up to here
    shown_by_customizer = false;
//=======any commented ('//') lines above this will be shown in the Customizer window!!=========================



organID = [ for (i = [0:1:len(organs)]) if (organ==organs[i]) i][0];
    
echo (organID);