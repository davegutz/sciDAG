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
// Dec 17, 2018     DA Gutz     Created for Scilab 5.5.2
// Jan 1, 2019      DA Gutz     Added valve
// Jan 7, 2019      DA Gutz     Added tables
// Jan 14, 2019     DA Gutz     Add or_aptow series
// 

// ******************  Make temporary palette for local C-blocks
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

// ****************** Create pallette
pal = init_add_struct('COR_AWPDTOPS', 'black', lib_path+'/images/blocks/COR_AWPDTOPS.png', pal);
pal = init_add_struct('COR_AWPSTOPD', 'black', lib_path+'/images/blocks/COR_AWPSTOPD.png', pal);
pal = init_add_struct('COR_APTOW', 'black', lib_path+'/images/blocks/COR_APTOW.png', pal);
pal = init_add_struct('CTAB1', 'orange', lib_path+'/images/blocks/CTAB1.png', pal);
pal = init_add_struct('HEAD_B', 'magenta', lib_path+'/images/blocks/HEAD_B.png', pal);
pal = init_add_struct('ACTUATOR_A_B', 'magenta', lib_path+'/images/blocks/ACTUATOR_A_B.png', pal);
pal = init_add_struct('ACTUATOR_A_C', 'magenta', lib_path+'/images/blocks/ACTUATOR_A_C.png', pal);
pal = init_add_struct('VALVE_A', 'green', lib_path+'/images/blocks/VALVE_A.png', pal);
pal = init_add_struct('TRIVALVE_A1', 'green', lib_path+'/images/blocks/TRIVALVE_A1.png', pal);
pal = init_add_struct('HLFVALVE_A', 'cyan', lib_path+'/images/blocks/HLFVALVE_A.png', pal);
pal = init_add_struct('VDP', 'blue', lib_path+'/images/blocks/VDP.PNG', pal);
pal = init_add_struct('CPMPS', 'blue', lib_path+'/images/blocks/CPMPS.PNG', pal);
pal = init_add_struct('CPMPD', 'blue', lib_path+'/images/blocks/CPMPD.PNG', pal);
pal = init_add_struct('FRICTION', 'blue', lib_path+'/images/blocks/FRICTION.png', pal);
pal = init_add_struct('LIMINT', 'red', SCI + '/modules/xcos/images/blocks/RAMP.svg', pal);
pal = init_add_struct('CLA_LRECPTOW', 'gray', lib_path+'/images/blocks/CLA_LRECPTOW.PNG', pal);
pal = init_add_struct('INTGL', 'gray', lib_path+'/images/blocks/INTGL.PNG', pal);

// Finalize the palette
xcosPalAdd(pal);

// Load the library
exec(lib_path+'LibScratchLoader.sce', -1);

mprintf('%s done\n', sfilename())
