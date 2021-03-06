// function [pal] = init_add_struct(name, fill_color, image_path, pal);
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
// Dec 31, 2018    DA Gutz        Created
// 
function [pal] = init_add_struct(name, fill_color, image_path, pal);
    // Add temporary library palette item made from local c-file
    style = struct();
    if  ~isempty(fill_color) then
        style.fillColor = fill_color;
    end
    if ~isempty(image_path) then
        block_img = image_path;
        // protect drive letter
        if getos() == "Windows" then
            block_img = "/" + block_img;
        end
        style.image="file://" + block_img;
    end


    o = evstr(name+"(''define'')");
    pal = xcosPalAddBlock(pal, o, '', style);

endfunction
