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

if 1 then
try close(figs); end
figs=[];

figs($+1) = figure("Figure_name", 'Start_Pressure_1', "Position", [10,30,610,460]);
subplot(221)
overplot(['start_ps'], ['r--'], 'Start Valve Pressures')
subplot(222)
overplot(['start_ph', 'start_prs'], ['b-', 'r--'], '')
subplot(223)
overplot(['start_pxr'], ['g--'], '')

figs($+1) = figure("Figure_name", 'Start_States', "Position", [30,50,610,460]);
subplot(221)
overplot(['START_X', 'start_x'], ['r-', 'b--'], 'Start Valve Position')
subplot(222)
overplot(['START_V', 'start_v'], ['r-', 'b--'], 'Start Valve Velocity')
subplot(223)
overplot(['START_UF', 'start_uf'], ['r-', 'b--'], 'Start Valve Unbal Force')
subplot(224)
overplot(['START_MODE'], ['r-'], 'Start Valve ZCD Mode0')

figs($+1) = figure("Figure_name", 'Start_Flow_1', "Position", [50,70,610,460]);
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

figs($+1) = figure("Figure_name", 'Trivalve_States', "Position", [120,50,610,460]);
subplot(221)
overplot(['TRI_X', 'tri_x'], ['r-', 'b--'], 'Trivalve Position')
subplot(222)
overplot(['TRI_V', 'tri_v'], ['r-', 'b--'], 'Trivalve Velocity')
subplot(223)
overplot(['TRI_UF', 'tri_uf'], ['r-', 'b--'], 'Trivalve Unbal Force')
subplot(224)
overplot(['TRI_MODE'], ['r-'], 'Trivalve ZCD Mode0')

figs($+1) = figure("Figure_name", 'Tri_Flow_1', "Position", [140,70,610,460]);
subplot(221)
overplot(['TRI_WFS', 'tri_wfs'], ['r-',  'b--'], 'Trivalve Supply Flow')
subplot(222)
overplot(['TRI_WFD', 'tri_wfd'], ['r-',  'b--'], 'Trivalve Discharge Flow')
subplot(223)
overplot(['TRI_WFX', 'tri_wfx'], ['r-',  'b--'], 'Trivalve Control Flow')
subplot(224)
overplot(['TRI_WFDE', 'tri_wfde'], ['r-',  'b--'], 'Trivalve Discharge End Flow')

figs($+1) = figure("Figure_name", 'Tri_Flow_2', "Position", [160,90,610,460]);
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

// Metering valve halfvalve plots**********
figs($+1) = figure("Figure_name", 'Halfvalve_Pressure_1', "Position", [200,30,610,460]);
subplot(221)
overplot(['mv_ps', 'mv_px'], ['r--', 'b--'], 'Half Valve Pressures')
subplot(222)
overplot(['mv_pr', 'mv_pc', 'mv_pa'], ['m-', 'b--', 'g--'], '')
subplot(223)
overplot(['mv_pw', 'mv_pd'], ['c--', 'b-'], '')
subplot(224)
overplot(['mv_px'], ['k--'], '')

figs($+1) = figure("Figure_name", 'Halfvalve_States', "Position", [220,50,610,460]);
subplot(221)
overplot(['MV_X', 'mv_x'], ['r-', 'b--'], 'Halfvalve Position')
subplot(222)
overplot(['MV_V', 'mv_v'], ['r-', 'b--'], 'Halfvalve Velocity')
subplot(223)
overplot(['MV_UF', 'mv_uf'], ['r-', 'b--'], 'Halfvalve Unbal Force')
subplot(224)
overplot(['MV_MODE'], ['r-'], 'Halfvalve ZCD Mode0')

figs($+1) = figure("Figure_name", 'Half_Flow_1', "Position", [240,70,610,460]);
subplot(321)
overplot(['MV_WFS', 'mv_wfs'], ['r-',  'b--'], 'Halfvalve Supply Flow')
subplot(322)
overplot(['MV_WFD', 'mv_wfd'], ['r-',  'b--'], 'Halfvalve Discharge Flow')
subplot(323)
overplot(['MV_WFSR', 'mv_wfsr'], ['r-',  'b--'], 'Halfvalve Flow')
subplot(324)
overplot(['MV_WFWD', 'mv_wfwd'], ['r-',  'b--'], 'Halfvalve  Flow')
subplot(325)
overplot(['MV_WFW', 'mv_wfw'], ['r-',  'b--'], 'Halfvalve Flow')
subplot(326)
overplot(['MV_WFWX', 'mv_wfwx'], ['r-',  'b--'], 'Halfvalve Flow')

figs($+1) = figure("Figure_name", 'Half_Flow_2', "Position", [260,90,610,460]);
subplot(321)
overplot(['MV_WFXA', 'mv_wfxa'], ['r-',  'b--'], 'Halfvalve Flow')
subplot(322)
overplot(['MV_WFRC', 'mv_wfrc'], ['r-',  'b--'], 'Halfvalve Flow')
subplot(323)
overplot(['MV_WFX', 'mv_wfx'], ['r-',  'b--'], 'Halfvalve Flow')
subplot(324)
overplot(['MV_WFA', 'mv_wfa'], ['r-',  'b--'], 'Halfvalve Flow')
subplot(325)
overplot(['MV_WFC', 'mv_wfc'], ['r-',  'b--'], 'Halfvalve Flow')
subplot(326)
overplot(['MV_WFR', 'mv_wfr'], ['r-',  'b--'], 'Halfvalve Flow')

// Head sensor head plots**********
figs($+1) = figure("Figure_name", 'Head_Pressure_1', "Position", [300,30,610,460]);
subplot(121)
overplot(['hs_pf', 'hs_ph', 'hs_pl', 'hs_plx'], ['r--', 'b--', 'm-', 'g--'], 'Half Valve Pressures')
subplot(122)
overplot(['HS_PLX', 'hs_plx'], ['r-', 'g--'], 'Head Damped Pressure')

figs($+1) = figure("Figure_name", 'Head_States', "Position", [320,50,610,460]);
subplot(221)
overplot(['HS_X', 'hs_x'], ['r-', 'b--'], 'Head Position')
subplot(222)
overplot(['HS_V', 'hs_v'], ['r-', 'b--'], 'Head Velocity')
subplot(223)
overplot(['HS_UF', 'hs_uf'], ['r-', 'b--'], 'Head Unbal Force')
subplot(224)
overplot(['HS_MODE'], ['r-'], 'Head ZCD Mode0')

figs($+1) = figure("Figure_name", 'Head_Flow_1', "Position", [340,70,610,460]);
subplot(221)
overplot(['HS_WFF', 'hs_wff'], ['r-',  'b--'], 'Head Flapper Flow')
subplot(222)
overplot(['HS_WFL', 'hs_wfl'], ['r-',  'b--'], 'Head  Flow')
subplot(223)
overplot(['HS_WFH', 'hs_wfh'], ['r-',  'b--'], 'Head Flow')
end

if 0 then
figs($+1) = figure("Figure_name", 'Throttle_Pressure_1', "Position", [400,30,610,460]);
subplot(221)
overplot(['p2'], ['r--'], 'Throttle Valve Pressures')
subplot(222)
overplot(['p3'], ['b--'], 'Throttle Valve Pressures')
subplot(223)
overplot(['px'], ['g--'], 'Throttle Valve Pressures')
subplot(224)
overplot(['pprt'], ['c--'], 'Throttle Valve Pressures')

figs($+1) = figure("Figure_name", 'Throttle_States', "Position", [400,50,610,460]);
subplot(221)
overplot(['MVTV_X', 'mvtv_x'], ['r-', 'b--'], 'Throttle Valve Position')
subplot(222)
overplot(['MVTV_V', 'mvtv_v'], ['r-', 'b--'], 'Throttle Valve Velocity')
subplot(223)
overplot(['MVTV_UF', 'mvtv_uf'], ['r-', 'b--'], 'Throttle Valve Unbal Force')
subplot(224)
overplot(['MVTV_MODE'], ['r-'], 'Throttle Valve ZCD Mode0')

figs($+1) = figure("Figure_name", 'Throttle_Flow_1', "Position", [400,70,610,460]);
subplot(221)
overplot(['MVTV_WFS', 'mvtv_wfs'], ['r-',  'b--'], 'Throttle Valve Supply Flow')
subplot(222)
overplot(['MVTV_WFD', 'mvtv_wfd'], ['r-',  'b--'], 'Throttle Valve Discharge Flow')
subplot(223)
overplot(['MVTV_WFVR', 'mvtv_wfvr'], ['r-',  'b--'], 'Throttle Valve Reference Opposite Spring End')
subplot(224)
overplot(['MVTV_WFVX', 'mvtv_wfvx'], ['r-',  'b--'], 'Throttle Valve Damping Flow')
end




mprintf('Completed %s\n', sfilename())  
