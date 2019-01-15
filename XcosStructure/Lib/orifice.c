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
// Jan 1, 2019     DA Gutz     Created 
//                          from http://www.scicos.org/ScicosCBlockTutorial.pdf
// install "Microsoft Visuall C++ 2013 Resistributable (x64)"
// verify proper install by 
// -->findmsvccompiler() ==> msvc120express
// and 
// -->haveacompiler() ==> T
//// libs = 'C:\Program"" ""Files\scilab-5.5.2\bin\scicos'
// libs = 'C:\PROGRA~1\SCILAB~1.2\bin\scicos'
// incs = 'C:\PROGRA~1\SCILAB~1.2\modules\scicos_blocks\includes'
// ilib_for_link('friction','friction_comp.c',libs,'c','','LibScratchLoader.sce', 'Scratch', '','-I'+incs, '', '');
// This is the computational function for a Scicos model block.
// The model is of a dynamic/static friction model
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "hyd_mod.h"
#define r_IN(n, i)  ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define CD (GetRparPtrs(blk)[0]) // Coeffient of discharge
#define SG (GetRparPtrs(blk)[1]) // Fluid specific gravity
// Object parameters.  1st index is 1-based, 2nd index is 0-based.
// See below with each block

// ************COR_APTOW
// inputs
#define A   (r_IN(0,0))     // Orifice area, sqin
#define PS  (r_IN(1,0))     // Supply pressure, psia
#define PD  (r_IN(2,0))     // Discharge pressure, psia
// states - none
// outputs
#define WF  (r_OUT(0,0))    // Supply flow in, pph
// other constants - none
void cor_aptow(scicos_block *blk, int flag)
{
    // inputs and outputs
    double ao = A;
    double ps = PS;
    double pd = PD;
    double cd = CD;
    double sg = SG;
    double wf;
    // compute info needed for all passes
    wf = OR_APTOW(ao, ps, pd, cd, sg);
    WF = wf;
}

// ************COR_AWPSTOPD
// inputs
#define A   (r_IN(0,0))     // Orifice area, sqin
#define WF  (r_IN(1,0))     // Supply flow in, pph
#define PS  (r_IN(2,0))     // Supply pressure, psia
// states - none
// outputs
#define PD  (r_OUT(0,0))    // Discharge pressure, psia
// other constants - none
void cor_awpstopd(scicos_block *blk, int flag)
{
    // inputs and outputs
    double ao = A;
    double wf = WF;
    double ps = PS;
    double pd = PD;
    double cd = CD;
    double sg = SG;
    // compute info needed for all passes
    pd = OR_AWPSTOPD(ao, wf, ps, cd, sg);
    PD = pd;
}


// ************COR_AWPDTOPS
// inputs
#define A   (r_IN(0,0))     // Orifice area, sqin
#define WF  (r_IN(1,0))     // Supply flow in, pph
#define PD  (r_IN(2,0))     // Discharge pressure, psia
// states - none
// outputs
#define PS  (r_OUT(0,0))    // Supply pressure, psia
// other constants - none
void cor_awpdtops(scicos_block *blk, int flag)
{
    // inputs and outputs
    double ao = A;
    double wf = WF;
    double pd = PD;
    double ps = PS;
    double cd = CD;
    double sg = SG;

    // compute info needed for all passes
    ps = OR_AWPDTOPS(ao, wf, pd, cd, sg);
    PS = ps;
}
