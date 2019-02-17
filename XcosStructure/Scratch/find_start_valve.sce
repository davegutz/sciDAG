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
// Feb 17, 2019    DA Gutz        Created
// 
clear blstart
for i = 1:length(scs_m.objs)
    if typeof(scs_m.objs(i)) == "Block" &..
         scs_m.objs(i).gui=="SUPER_f" &..
          scs_m.objs(i).model.label=="VBP"  then
          iVBP = i;
          break;
     end
end

for j = 1:length(scs_m.objs(iVBP).model.rpar.objs)
    if typeof(scs_m.objs(iVBP).model.rpar.objs(j))=="Block" &..
         scs_m.objs(iVBP).model.rpar.objs(j).gui=="VALVE_A" &..
          scs_m.objs(iVBP).model.rpar.objs(j).model.label=="start"  then
          jSTART = j;
          break;
     end
 end

o_start = scs_m.objs(iVBP).model.rpar.objs(jSTART).model;
bl_start = model2blk(o_start);

x = INI.vsv.x;
 
bl_start.inptr(1) = INI.ven_pd;
bl_start.inptr(2) = 0;
bl_start.inptr(3) = INI.p1so;
bl_start.inptr(4) = INI.p1so;
bl_start.inptr(5) = 0;
bl_start.inptr(6) = INI.ven_ps;
bl_start.inptr(7) = 0;

bl_start.rpar(1) = FP.sg;
bl_start.rpar(2) = 1;  // LINCOS_OVERRIDE doesn't seem to do anything this mode

bl_start.x(1) = x;
bl_start.x(2) = 0;

t = 0;
bl_start = callblk(bl_start, 0, t);
bl_start = callblk(bl_start, 1, t);
bl_start = callblk(bl_start, 9, t);

blstart.sg = bl_start.rpar(1);
blstart.LINCOS_OVERRIDE = bl_start.rpar(2);
blstart.wfs = bl_start.outptr(1);
blstart.wfd = bl_start.outptr(2);
blstart.wfh = bl_start.outptr(3);
blstart.wfvrs = bl_start.outptr(4);
blstart.wfvr = bl_start.outptr(5);
blstart.wfvx = bl_start.outptr(6);
blstart.v = bl_start.outptr(7);
blstart.x = bl_start.outptr(8);
blstart.uf = bl_start.outptr(9);
blstart.mode = bl_start.outptr(10);

blstart.V = bl_start.xd(1);
blstart.A = bl_start.xd(2);

blstart.mode = bl_start.mode;

blstart.surf0 = bl_start.g(1);
blstart.surf1 = bl_start.g(2);
blstart.surf2 = bl_start.g(3);
blstart.surf3 = bl_start.g(4);
blstart.surf4 = bl_start.g(5);


