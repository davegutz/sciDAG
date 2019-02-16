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
// Dec 17, 2018     DA Gutz         Created
// 

// Library is ../Lib.   execute make_libScratch.sce and init_libScratch.sce to
// rebuild.   May have to re-drag libScratch blocks out of Pallette browser for
// some rebuild configurations.   The functions below call init_libScratch 
// automatically but do not call make_libScratch.   When you call 
// make_libScratch it will do a clear/close so that you are forced to re-run
// the init_libScratch and avoid a lot of headscratching.

// Start flow system development
// c-code model run first in Linux Ubuntu to generate .csv files in Data folder
// First version to zoom on each component
exec('init_start04detail.sce', -1);
// press play.   May throw memory error.   Activate "stacksize('max')" line
// in PreLoadFcn_start04detail.sce.   May not run on all platforms - comment
// it back out to run without bomb
// interactive result in Results/expected_start04detail*.png
// Formal plots in Results/expected_start04detail_formal*.png
// Second version to let components interact.  Explicit initialization.
exec('init_start04.sce', -1);
// press play.  Same memory issues as detail
// interactive results in Results.   Formal plots in Results



exec('init_start04detail.sce', -1);
// press play.   May throw memory error.   Activate "stacksize('max')" line
// in PreLoadFcn_start04detail.sce.   May not run on all platforms - comment
// it back out to run without bomb
// interactive result in Results/expected_start04detail*.png
// Formal plots in Results/expected_start04detail_formal*.png

// Test pipes
exec('init_pipe.sce', -1);
// press play
// expected result in Results/expected_pipe.png

// Test orifices
exec('init_orifice.sce', -1);
// press play
// expected result in Results/expected_orifice.png

// Test valve
exec('init_valve.sce', -1);
// press play
// expected result in Results/expected_valve.png

// Test table
exec('init_table.sce', -1);
// press play
// expected result in Results/expected_table.png

// Test sec_order_x
exec('init_sec_order_1.sce', -1);
// press play
// expected result in Results/expected_sec_order_1.png
exec('init_sec_order_2.sce', -1);
// press play
// expected result in Results/expected_sec_order_2.png
exec('init_sec_order_3.sce', -1);
// press play
// expected result in Results/expected_sec_order_3.png
exec('init_sec_order_4.sce', -1);
// press play
// expected result in Results/expected_sec_order_4.png
exec('init_sec_order_5.sce', -1);
// press play
// expected result in Results/expected_sec_order_5.png
exec('init_sec_order_6.sce', -1);
// press play
// expected result in Results/expected_sec_order_6.png

// Load scratch552_UseLib.xcos
exec(init_scratch552_UseLib.sce, -1);

