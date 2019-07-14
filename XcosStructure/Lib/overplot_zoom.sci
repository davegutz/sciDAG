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
// Jul 14, 2019    DA Gutz        Created
// 
function overplot_zoom(sig_names, c, %title, %tlim, %ylim)
    if length(%tlim) then
        zooming = %t;
        xmin = %tlim(1); xmax = %tlim(2);
    else
        xmin = 0;
        xmax = evstr(sig_names(1)+'.time($)');
        zooming = %f;
    end
    ymin = %inf;  ymax = -%inf;
    if argn(2)>4 then
        if length(%ylim) then
            yooming = %t;
            ymin = %ylim(1); ymax = %ylim(2);
        else
            yooming = %f;
        end
    else
        yooming = %f;
    end
    xtitle(%title)
    [n, m] = size(sig_names);
    [nc, mc] = size(c);
    for i=1:m
        plot(evstr(sig_names(i)+'.time'), evstr(sig_names(i)+'.values'), c(i))
        if zooming then
            zoom_range = find(evstr(sig_names(1)+'.time')>%tlim(1) & ...
                    evstr(sig_names(1)+'.time')<%tlim(2));
            if ~yooming then
                ymin = min(ymin, min(evstr(sig_names(i)+'.values(zoom_range)')));
                ymax = max(ymax, max(evstr(sig_names(i)+'.values(zoom_range)')));
            end
        end
    end
    set(gca(),"grid",[1 1])
    legend(sig_names);
    if zooming | yooming then
        set(gca(),"data_bounds", [xmin xmax ymin ymax])
    end
endfunction
