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
// Jan 1, 2019  DA Gutz     Created
// 
function overplot(st, c, %title)
    xtitle(%title)
    [n, m] = size(st);
    [nc, mc] = size(c);
    for i=1:m
        plot(evstr(st(i)+'.time'), evstr(st(i)+'.values'), c(i))
    end
     set(gca(),"grid",[1 1])
    legend(st);
endfunction

global LINCOS_OVERRIDE figs
mprintf('In %s\n', sfilename())  

try close(figs); end
figs=[];
figs($+1) = figure("Figure_name", 'Start_Pressure_1', "Position", [10,30,610,460]);
subplot(221)
overplot(['start_ps'], ['r--'], 'Start Valve Pressures')
subplot(222)
overplot(['start_ph', 'start_prs'], ['b-', 'r--'], '')
subplot(223)
overplot(['start_pxr'], ['g--'], '')

figs($+1) = figure("Figure_name", 'Start_States', "Position", [10,50,610,460]);
subplot(221)
overplot(['START_X', 'start_x'], ['r-', 'b--'], 'Start Valve Position')
subplot(222)
overplot(['START_V', 'start_v'], ['r-', 'b--'], 'Start Valve Velocity')
subplot(223)
overplot(['START_UF', 'start_uf'], ['r-', 'b--'], 'Start Valve Unbal Force')
subplot(224)
overplot(['START_MODE'], ['r-'], 'Start Valve ZCD Mode0')

figs($+1) = figure("Figure_name", 'Start_Flow_1', "Position", [10,70,610,460]);
subplot(221)
overplot(['START_WFS', 'start_wfs'], ['r-',  'b--'], 'Start Valve Supply Flow')
subplot(222)
overplot(['START_WFH', 'start_wfh'], ['r-',  'b--'], 'Start Valve Head Flow')
subplot(223)
overplot(['START_WFVRS', 'start_wfvrs'], ['r-',  'b--'], 'Start Valve Reference Opposite Spring End')
subplot(224)
overplot(['START_WFVX', 'start_wfvx'], ['r-',  'b--'], 'Start Valve Damping Flow')

// Trivalve regulator plots
figs($+1) = figure("Figure_name", 'Trivalve_Pressure_1', "Position", [100,30,610,460]);
subplot(221)
overplot(['tri_ps', 'tri_pes'], ['r--', 'b--'], 'Tri Valve Pressures')
subplot(222)
overplot(['tri_pel', 'tri_ped', 'tri_pd'], ['m-', 'b--', 'g--'], '')
subplot(223)
overplot(['tri_pld', 'tri_plr'], ['c--', 'b-'], '')
subplot(224)
overplot(['tri_px'], ['k--'], '')

figs($+1) = figure("Figure_name", 'Trivalve_States', "Position", [100,50,610,460]);
subplot(221)
overplot(['TRI_X', 'tri_x'], ['r-', 'b--'], 'Trivalve Position')
subplot(222)
overplot(['TRI_V', 'tri_v'], ['r-', 'b--'], 'Trivalve Velocity')
subplot(223)
overplot(['TRI_UF', 'tri_uf'], ['r-', 'b--'], 'Trivalve Unbal Force')
subplot(224)
overplot(['TRI_MODE'], ['r-'], 'Trivalve ZCD Mode0')

figs($+1) = figure("Figure_name", 'Tri_Flow_1', "Position", [100,70,610,460]);
subplot(221)
overplot(['TRI_WFS', 'tri_wfs'], ['r-',  'b--'], 'Trivalve Supply Flow')
subplot(222)
overplot(['TRI_WFD', 'tri_wfd'], ['r-',  'b--'], 'Trivalve Discharge Flow')
subplot(223)
overplot(['TRI_WFX', 'tri_wfx'], ['r-',  'b--'], 'Trivalve Control Flow')
subplot(224)
overplot(['TRI_WFDE', 'tri_wfde'], ['r-',  'b--'], 'Trivalve Discharge End Flow')

figs($+1) = figure("Figure_name", 'Tri_Flow_2', "Position", [100,90,610,460]);
subplot(321)
overplot(['TRI_WFLE', 'tri_wfle'], ['r-',  'b--'], 'Trivalve L End Flow')
subplot(322)
overplot(['TRI_WFSE', 'tri_wfse'], ['r-',  'b--'], 'Trivalve S End Flow')
subplot(323)
overplot(['TRI_WFLD', 'tri_wfld'], ['r-',  'b--'], 'Trivalve LD Flow')
subplot(324)
overplot(['TRI_WFLR', 'tri_wflr'], ['r-',  'b--'], 'Trivalve LR Flow')
subplot(325)
overplot(['TRI_WFSX', 'tri_wfsx'], ['r-',  'b--'], 'Trivalve SX Flow')
subplot(326)
overplot(['TRI_WFXD', 'tri_wfxd'], ['r-',  'b--'], 'Trivalve XD Flow')

mprintf('Completed %s\n', sfilename())  
