# Millitome Generator

<h3>Function overview</h3>

A millitome is a device designed to hold a freshly procured organ and facilitate cutting it into many small tissue blocks for usage in single cell analysis. A millitome has discrete, equally placed cutting grooves in both the x and y directions to guide a carbon steel cutting knife. The millitome is used to produce uniformly sized slices or cubes of tissue material that can be registered to organs from the CCF 3D Reference Object Library.

Millitome Generator uses modified 3D-models from the HuBMAP organ repository to generate 3D-printable millitomes, delivered as STL files. The exact shape, proportions and dimensions of the generated millitome depend directly on the properties of the organ model used.

Along with the 3d-printed millitome a researcher needs a lookup document. This comes in the form of a spreadsheet file, where data about the individual sample blocks can be recorded. This lookup file is needed in CSV format.

<h3>Software Tools</h3>

In order to match millitomes to specific organs, a 3d modeling application such as Blender, Maya or Cinema 4D is used to simplify the organ model. This modified organ is then used in <a href="https://openscad.org">Openscad</a> to generate the matching STL file.

Unlike regular 3D modelling software, which relies on a visual point-and-click interface, OpenScad is fully code based. That means, the 3D geometry is only created after the user executes the text-based code. This makes it easy to create variations of a 3D object (e.g., millitomes for different organ sizes or tissue block sizes) by changing relevant parameters in the code.

The user adjusts a handfull of variables, such as organ type, gender, block size and selects which part of the millitome (top, bottom) should be generated. OpenScad will build the requested geometry, which can then be exported as an STL file for 3D-printing.

To create a matching Lookup file in CSV format for a specific millitome, any spreadsheet application can be used, or even a text editor.

<h3><a href="https://github.com/hubmapconsortium/hra-millitome-generator/tree/main/OpenScad%20Code/V10">Millitome Generator V10</a></h3>

V10 was programmed to export one single Millitome STL after setting the required properties directly in the Openscad code. This is practical to produce a handful of STL files or to troubleshoot errors in the code or parameters. Complete millitome sets for several organs can require 100 or more individual STL files. It is very time-consuming to tweak parameters and export each STL manually.

<h3><a href="https://github.com/hubmapconsortium/hra-millitome-generator/tree/main/OpenScad%20Code/V11">Millitome Generator V11</a></h3>

Just like V10, V11 can still be used to export individual STL files. But now this can also be initiated through the command line in a Terminal app. A bash terminal script automates the creation of (at the moment) 144 individual STL files; all named consistently, created into matching folders, each folder compressed into a ZIP file.

While the terminal script runs Openscad, it also generates a correctly configured and named CSV Lookup file for each STL file. CSV files are also saved into the correct folder and included in the generated ZIP file.
