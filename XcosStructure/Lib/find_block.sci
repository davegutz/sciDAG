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
// Feb 18, 2019    DA Gutz        Created
// 
function blk_f = find_block(parent_m, label)
    // Return scicos_block equivalent to block with label ="label"
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
