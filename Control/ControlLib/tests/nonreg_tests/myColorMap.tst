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
// Sep 26, 2018 	DA Gutz		Created
// 
clear
clearglobal
funcprot(0);
mclose('all');
getd('../ControlLib')
n_fig = -1;
xdel(winsid())

t=0:10;
for i = 1:20
    x($+1, :) = t+i-1;
    normal_legend($+1) = string(i);
end
t= t';
x = x';
n_fig = n_fig+1;
n_fig_normal = n_fig;
scf(n_fig_normal); clf(); f=gcf();
plot(t, x)
title('Normal cyclic map shown',"fontsize",3);
xlabel("t", "fontsize",4);
ylabel("$y$","fontsize",4);
legend(normal_legend);

myFgMap = [2 13 5 4 6 32 1];
for i = 1:5
    myFgMap = [myFgMap myFgMap];
end
hx = 0.48;
n_fig = n_fig+1;
n_fig_xpolys = n_fig;
scf(n_fig_xpolys); clf(); fig=gcf();
immediate_drawing = fig.immediate_drawing;
fig.immediate_drawing = "off";
sciCurAxes = gca();
axes = sciCurAxes;
wrect = axes.axes_bounds;
//axes.axes_bounds = [wrect(1)+0, wrect(2)+0, wrect(3)*1.0, wrect(4)*hx*0.95];
axes.data_bounds = [min(t), min(x); max(t), max(x)];
axes.grid = color("lightgrey")*ones(1, 3);
axes.axes_visible = "on";
axes.clip_state = "clipgrf";
//plot2d(0,0,1,rect=[0,0,max(t),max(x)], frameflag=3)
[n, mn] = size(x);
if size(x, 2) > 1 & size(t, 2) == 1 then
    xpolys(t(:, ones(1, mn)), x);
else
    xpolys(t, x);
end
e = gce();
n_lines = size(e.children, "*");
for i=1:n_lines
    e.children(i).foreground = myFgMap(n_lines-i+1);
end
discr = %f;
if discr & fmax <> [] & max(frq) < fmax then
    xpoly(max(frq)*[1; 1], axes.y_ticks.locations([1 $]));
    e = gce();
    e.foreground = 5;
end
xtitle("", _("t"), _("x"));
fig.immediate_drawing = immediate_drawing;
// Return to the previous scale
set("current_axes", sciCurAxes);
legend(normal_legend);
title('Manual cyclic map shown',"fontsize",3);



