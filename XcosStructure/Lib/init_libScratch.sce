// init_libScratch.sce
// Initialize library icons
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
// Dec 17, 2018    DA Gutz      Created for Scilab 5.5.2
// 

// ******************  Temporary palette for C-blocks
funcprot(0);
loadXcosLibs;
try
    xcosPalDelete("libScratch");
end
pal = xcosPal("libScratch");
xcosPalAdd(pal);
getd('../Lib');
xcos('../Lib/LibXcosStructure.xcos');
lib_path = get_absolute_file_path(sfilename());
chdir(lib_path)

// Remove any old gif because they cause bomb in xcosPalAddBlock calls
if getos() == 'Windows' then
    unix('del '+TMPDIR+'\*.gif');
else
    unix('rm -f '+TMPDIR+'/*.gif');
end        

// ****************** Create pallette with FRICTION
style = struct();
style.fillColor="blue";
block_img = lib_path + "/images/blocks/FRICTION.png";
// protect drive letter
if getos() == "Windows" then
    block_img = "/" + block_img;
end
style.image="file://" + block_img;
o = FRICTION("define");
pal = xcosPalAddBlock(pal, o, '', style);

// ****************** Create pallette with LIMINT
style = struct();
style.fillColor="red";
block_img = SCI + "/modules/xcos/images/blocks/RAMP.svg";
// protect drive letter
if getos() == "Windows" then
    block_img = "/" + block_img;
end
style.image="file://" + block_img;
o = LIMINT("define");
pal = xcosPalAddBlock(pal, o, '', style);

// Finalize the palette
xcosPalAdd(pal);
disp('init done')
