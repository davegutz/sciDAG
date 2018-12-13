// Copyright (C) 2007  Interdepartmental Research Center "E. Piaggio", University of Pisa
//
// This file is part of RTSS, the Robotics Toolbox for Scilab/Scicos.
//
// RTSS is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// RTSS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with RTSS; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA



function rt_drivebot(r, b)
// File name:       rt_drivebot.sci
//
// Function:        rt_drivebot
//
// Description:     drive a graphical robot
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/drivebot.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    obj = findobj("Tag", r.name);
    if ~isempty(obj) then
        parenth = get(obj, "Parent");
        error("rt_drivebot g.u.i. (" + sci2exp(parenth) + ") already drives the """ + r.name + """ robot.");
    end

    [%nargout, %nargin] = argn(0);

    bgcol = [135 206 250]/255;
    h_xyzatext = [];
    h_slider = [];
    h_edit = [];
    n = r.n;
    minVal = -%pi;
    maxVal = %pi;
    scale = 50/%pi*ones(n, 1);
    escale = ones(n, 1);
    rplot_id = [];
    width = 300;
    height = 40;
    // figure props.
    width_fig = (width+5)*0.8+(width+5)*0.2+50; height_fig = height*(n+2);
    // text prop. (qi: )
    width_textqi = width*0.1; height_textqi = height*0.4;
    // sliders props.
    width_sli = width*0.7; height_sli = height*0.4;
    // edit props.
    width_ed = (width+5)*0.25; height_ed = height*0.4+4;
    // xyzatext props.
    width_xyza = width*0.25; height_xyza = height/2;

    qlim = r.qlim;
    if isempty(qlim),
        qlim = [minVal*ones(n, 1) maxVal*ones(n, 1)];
    end

    if (%nargin == 2) & (typeof(b) == "string") then
        if part(b, [1,2,3]) == "deg" then
            disp("** in degree mode **");
            L = r.links;
            for i = 1:r.n,
                if L(i).RP == "R" then
                    escale(i) = 180/%pi;
                end
            end
        end
        // else rad. mode
    end

    /////////////////////
    // figure creation //
    /////////////////////
    fig = figure(   "Units", "pixels",..
                    "Position", [0, 0, width_fig, height_fig],..
                    "BackgroundColor", bgcol);
    set(fig, "figure_name", "rt_drivebot g.u.i. (" + sci2exp(fig) + ")");

    /////////////////////////////////////////////////////////////////
    // first we check to see if there are any graphical robots of  //
    // this name, if so we use them, otherwise create a robot plot.//
    /////////////////////////////////////////////////////////////////
    rh = rt_findtag(r.name);
    if ~isempty(rh) then
        ud = rh(1).user_data;
        r = ud(2);
        if %nargin < 2 then
            q = r.q.';
        else
            q = b;
            rt_plot(r, q);
        end
        rplot_id = r.handles.robot.parent.parent.figure_id;
    else
        cfhdb = scf();
        rplot_id = cfhdb.figure_id;
        cfhdb.pixmap = "on";
        cfhdb.children.tight_limits = "on";
        cfhdb.children.rotation_angles = [80, -46];
        if %nargin < 2 then
            q = zeros(1, n);
        else
            q = b;
        end
        rt_plot(r, q);
        show_pixmap();
    end

    ///////////////////////////////////////////////////
    // now make the title, the sliders and the edits //
    ///////////////////////////////////////////////////
    h_whichrobot = uicontrol(fig, "Style", "text",..
                                "Units", "pixels",..
                                "fontsize", 26,..
                                "Horizontalalignment", "left",..
                                "Position", [0, height*(n + 1), 0.93*width, height],..
                                "BackgroundColor", [1, 1, 1],..
                                "Tag", r.name,..                            // useful var when executing callbacks
                                "Userdata", [scale; escale; rplot_id],..    // another useful var
                                "String", r.name);                          // last useful var

    for i = 1:n,
        uicontrol(fig,  "Style", "text",..
                        "Units", "pixels",..
                        "BackgroundColor", bgcol,..
                        "Position", [0, height*(n - i)+6, width_textqi, height_textqi],..
                        "String", "q"+sci2exp(i));

        h_slider(i) = uicontrol(fig,    "Style", "slider",..
                                        "Units", "pixels",..
                                        "Position", [width*0.1, height*(n - i)+6, width_sli, height_sli],..
                                        "Min", scale(i)*qlim(i,1),..
                                        "Max", scale(i)*qlim(i,2),..
                                        "Value", scale(i)*q(i),..
                                        "SliderStep", [1, 1],..
                                        "Tag", "hslider" + sci2exp(i) + "_" + sci2exp(fig));
        set(h_slider(i), "Callback", "rt_drivebotcb1(get(" + sci2exp(h_whichrobot) + ",''String''))");

        h_edit(i) = uicontrol(fig,  "Style", "edit",..
                                    "Units", "pixels",..
                                    "Position", [width*0.1+width*0.7+4, height*(n - i)+3, width_ed, height_ed],..
                                    "Horizontalalignment", "center",..
                                    "Tag", "hedit" + sci2exp(i) + "_" + sci2exp(fig),..
                                    "String", sci2exp(escale(i)*q(i)));

    end

    ////////////////////////////////////////
    // the push-button for edits updating //
    ////////////////////////////////////////
    h_pushbe = uicontrol(fig,  "Style", "pushbutton",..
                            "Units", "pixels",..
                            "fontsize", 16,..
                            "Position", [width_fig-30, 3, 30, height*(n-1)+height_sli+4],..
                            "BackgroundColor", [211 211 211]/255,..
                            "String", "Go!");
    set(h_pushbe, "Callback", "rt_drivebotcb2(get(" + sci2exp(h_whichrobot) + ",''String''))");

    t6 = rt_fkine(r, q);

    // X
    uicontrol(fig,  "Style", "text",..
                    "Units", "pixels",..
                    "Position", [0, height*(n + 0.5), 0.06*width, height/2],..
                    "BackgroundColor", [1, 1, 0],..
                    "fontsize", 10,..
                    "Horizontalalignment", "left",..
                    "String", "x:");

    h_xyzatext(1, 1) = uicontrol(fig,   "Style", "text",..
                                        "Units", "pixels",..
                                        "Position", [0.06*width, height*(n + 0.5), width_xyza, height_xyza],..
                                        "Tag", "hxyzatext" + sci2exp(11) + "_" + sci2exp(fig),..
                                        "String", part(sci2exp(t6(1,4)), [1:6]));

    // Y
    uicontrol(fig,  "Style", "text",..
                    "Units", "pixels",..
                    "Position", [0.31*width, height*(n + 0.5), 0.06*width, height/2],..
                    "BackgroundColor", [1, 1, 0],..
                    "FontSize", 10,..
                    "Horizontalalignment", "left",..
                    "String", "y:");

    h_xyzatext(2, 1) = uicontrol(fig,   "Style", "text",..
                                        "Units", "pixels",..
                                        "Position", [0.37*width, height*(n + 0.5), width_xyza, height_xyza],..
                                        "Tag", "hxyzatext" + sci2exp(21) + "_" + sci2exp(fig),..
                                        "String", part(sci2exp(t6(2,4)), [1:6]));

    // Z
    uicontrol(fig,  "Style", "text",..
                    "Units", "pixels",..
                    "BackgroundColor", bgcol,..
                    "Position", [0.62*width, height*(n + 0.5), 0.06*width, height/2],..
                    "BackgroundColor", [1, 1, 0],..
                    "FontSize", 10,..
                    "HorizontalAlignment", "left",..
                    "String", "z:");

    h_xyzatext(3, 1) = uicontrol(fig,   "Style", "text",..
                                        "Units", "pixels",..
                                        "Position", [0.68*width, height*(n + 0.5), width_xyza, height_xyza],..
                                        "Tag", "hxyzatext" + sci2exp(31) + "_" + sci2exp(fig),..
                                        "String", part(sci2exp(t6(3,4)), [1:6]));

    // AX
    uicontrol(fig,  "Style", "text",..
                    "Units", "pixels",..
                    "BackgroundColor", bgcol,..
                    "Position", [0, height*(n), 0.06*width, height/2],..
                    "BackgroundColor", [1, 1, 0],..
                    "FontSize", 10,..
                    "Horizontalalignment", "left",..
                    "String", "ax:");

    h_xyzatext(1, 2) = uicontrol(fig,   "Style", "text",..
                                        "Units", "pixels",..
                                        "Position", [0.06*width, height*(n), width_xyza, height_xyza],..
                                        "Tag", "hxyzatext" + sci2exp(12) + "_" + sci2exp(fig),..
                                        "String", part(sci2exp(t6(1,3)), [1:6]));

    // AY
    uicontrol(fig,  "Style", "text",..
                    "Units", "pixels",..
                    "BackgroundColor", bgcol,..
                    "Position", [0.31*width, height*(n), 0.06*width, height/2],..
                    "BackgroundColor", [1, 1, 0],..
                    "FontSize", 10,..
                    "Horizontalalignment", "left",..
                    "String", "ay:");

    h_xyzatext(2, 2) = uicontrol(fig,   "Style", "text",..
                                        "Units", "pixels",..
                                        "Position", [0.37*width, height*(n), width_xyza, height_xyza],..
                                        "Tag", "hxyzatext" + sci2exp(22) + "_" + sci2exp(fig),..
                                        "String", part(sci2exp(t6(2,3)), [1:6]));

    // AZ
    uicontrol(fig,  "Style", "text",..
                    "Units", "pixels",..
                    "BackgroundColor", bgcol,..
                    "Position", [0.62*width, height*(n), 0.06*width, height/2],..
                    "BackgroundColor", [1, 1, 0],..
                    "FontSize", 10,..
                    "Horizontalalignment", "left",..
                    "String", "az:");

    h_xyzatext(3, 2) = uicontrol(fig,   "Style", "text",..
                                        "Units", "pixels",..
                                        "Position", [0.68*width, height*(n), width_xyza, height_xyza],..
                                        "Tag", "hxyzatext" + sci2exp(32) + "_" + sci2exp(fig),..
                                        "String", part(sci2exp(t6(3,3)), [1:6]));

    h_pushbq = uicontrol(fig,   "Style", "pushbutton",..
                                "Units", "pixels",..
                                "fontsize", 16,..
                                "Position", [(width_fig + 0.93*width)/2 - 0.1*width, height*n, 0.2*width, 2*height],..
                                "BackgroundColor", [1, 0, 0],..
                                "String", "Quit");
    set(h_pushbq, "Callback", "rt_drivebotcb3(get(" + sci2exp(h_whichrobot) + ",''String''))");

endfunction
