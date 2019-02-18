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
function blk_f = find_block(parent_m, label)
    if typeof(parent_m)=="diagram" then
//        mprintf('searching %s for %s.   %ld objects...\n', parent_m.props.title, label, length(parent_m.objs));
    end
    for i = 1:length(parent_m.objs)
//        mprintf('i=%ld, type=%s\n', i, typeof(parent_m.objs(i)));
        if typeof(parent_m.objs(i))=="Block" & parent_m.objs(i).gui=="SUPER_f" then
//            mprintf('i=%ld, gui=%s\n', i, parent_m.objs(i).gui);
            blk_f = find_block(parent_m.objs(i).model.rpar, label);
            if typeof(blk_f)=="scicos_block"
                return;
            end
        end
        if typeof(parent_m.objs(i))=="Block" then
//            mprintf('checking %s for %s..\n', parent_m.objs(i).model.label, label);
            if parent_m.objs(i).model.label==label then
                blk_f = model2blk(parent_m.objs(i).model);
//                mprintf('*****found %s*******typeof=%s\n', label, typeof(blk_f))
                return
            end
        end    
    end
    if ~exists('blk_f') then
        blk_f = "not found";
    end
endfunction

clear bl_start
bl_start = find_block(scs_m, 'start');
if typeof(bl_start)~="scicos_block" then
    error('start not found');
end
clear bl_mv
bl_mv = find_block(scs_m, 'mv');
if typeof(bl_mv)~="scicos_block" then
    error('mv not found');
end
clear bl_mvtv
bl_mvtv = find_block(scs_m, 'mvtv');
if typeof(bl_mvtv)~="scicos_block" then
    error('mvtv not found');
end
clear bl_hs
bl_hs = find_block(scs_m, 'hs');
if typeof(bl_hs)~="scicos_block" then
    error('hs not found');
end

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


