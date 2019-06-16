// Copyright (C) 2019 - Dave Gutz
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
// Mar 2, 2019    DA Gutz        Created
// 

o  Linearization of SCICOS model scs_m - 
    - sqrt will not linearize unless it's block properties are set to 'complex'
    
o  Save to Workspace blocks appear to stop working
    "Error in post_xcos_simulate: ending simulation"
    and when run StopFcn:
    "tWALL = WALL.time(:,1);
                       !--error 250 
    Recursive extraction is not valid in this context."
    -  solver is DP45.  Has it always been?

o "Undefined variable: Resume_line_args"
    Caused by leaving a masked subsystem unmasked.   Right click
    on the block and select "Superblock Mask - Create mask"
    
    Also, if you have been messing with a masked block then
    you may need to completely restart scilab to clear messages of the 
    order "unable to compile block"
 
o NaN in chained line models
    Can be caused by too high damping in lines ('c')
    
o SQRT xcos does not seem to work
    Double-click on SQRT blocks and change 2 to 1 - complex -> real.
    Default value is bad in that block.
