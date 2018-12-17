// Copyright (C) 2018 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Dec 17, 2018 	DA Gutz		Created
// 


// LHY block custom and library add
// Create superblock by selecting elements on Xcos diagram and right-click
// Customeize name and color by Format-->Edit
// Populate availabe parameters by adding to Context or defining at cli
// Add mask.  Right-click-->Superblock mask-->Create
// Insert what you want
// Save superblock to new, empty Xcos file, e.eg.  LYY_Xcos_Lib.xcos
// Right-click on Palettes of Palettes brower -->Create
// Rename  --> "LHY"
// Palettes menu --> Open folder at tope of Palettes menu--> LHY_Xcos_Lib.xcos
// Move file to folder "LHY"   Select file and drag to folder "LHY"
// Rename.   Palettes-->LHY  modify on the right the name as "LHY_Xcos"

// Create pallette with LIMINT
loadXcosLibs;
exec('lim_int_intf.sci', -1);
style = struct();
style.fillColor="red";

block_img = SCI + "/modules/xcos/images/blocks/RAMP.svg";
// protect drive letter
if getos() == "Windows" then
    block_img = "/" + block_img;
end
//style.image="file://" + block_img;
o = LIMINT("define");
pal = xcosPal("My palette");
//add block to this palette using e.g. RAMP icon
//pal = xcosPalAddBlock(pal, o, SCI + "/modules/xcos/images/palettes/RAMP.png", style);
pal = xcosPalAddBlock(pal, o, '', style);
xcosPalAdd(pal);
// Right-click on Palettes of Palettes brower -->Create
// Rename  --> "LIMINT"
// New xcos diagram and add block.  Edit properties name LIMINT.  Save as LIMINT.xcos
// Move "My palette" to folder "LIMINT" 
// Right-click on Palettes of Palettes brower -->Create
// Rename  --> "Demo"
// Palettes menu --> Open --> LIMINT.xcos
// double-click Palettes folder on Palettes menu to open it
// add LIMINT.xcos fo Palettes/Demo
// Rename resultant folder


