# Creating Customized Millitome Assets

## Millitome for 3D print

<p align="center">
  <span>
  <img src="images/MT-render.png" height="200">
  <img src="images/MT-photo.jpg" height="200">
  </span>
</p>


## Icebox for laser-cut acrylic
<p align="center">
  <img src="images/Icebox_dxf.png" height="200">
  <img src="images/Icebox_acrylic.jpg" height="200">
</p>

## Create and Export Customized Asset

- launch "MT-Customizer.scad
- if Customizer panel is not open, use -> Window-> Customizer

<p align="center">
  <img src="images/mt-customizer-1.png" height="500">
</p>

- select product (Millitome, Icebox)
- select gender (female, male)
- select organ
- select laterality (top, bottom)
- select organ scale (medium=100%, large=115%, small=85%)
- select blocktype (uniform-blocksize, XY-blocksize, XY-blockcount)
- select blocksize for uniform-blocksize blocksize sets X and Y to selected value


/size (needs a bit more explanation)

- OpenSCAD renders preview (use Design->Preview if necessary)
- to create geometry for export: execute render (can take a while)
- after render is complete export as STL for millitome, DXF for Icebox



---
at the moment this is only created when using BASH script

---


## Matching CSV lookup file
<p align="center">
  <img src="images/CSV-lookup.png" height="300">
</p>



