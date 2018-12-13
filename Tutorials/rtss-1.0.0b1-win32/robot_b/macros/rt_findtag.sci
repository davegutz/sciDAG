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



function [handles] = rt_findtag(value)
// File name:       rt_findtag.sci
//
// Function:        rt_findtag
//
// Description:     locate graphics objects with specific Tag properties
//
// Annotations:     There was no chance of doing the following call:
//                      rh = findobj('Tag', string)
//                  because Scilab function findobj does not work with graphics
//                  entities (only with uicontrols).
//                  I wrote this code to solve this problem.
//                  Here I assumed "Tag" was the FIRST element in the user_data
//                  parameter for polyline entities. Therefore
//                      user_data(1) contains the name of robot
//                      user_data(2) contains the robot info
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    handles = [];

    grentlist = winsid();
    if ~isempty(grentlist) then
        for k=grentlist(1):grentlist($),
            cfh = scf(k);
            currax = cfh.children;
            if size(currax, "*") == 1 then
                nobj = size(currax.children,1);
                for i=1:nobj,
                    if  typeof(currax.children(i).user_data) == "list" &..
                        length(currax.children(i).user_data) > 0 &..
                        getfield(1,currax.children(i).user_data) == value then

                            handles = [handles;currax.children(i)];
                    end
                end
            end
        end
    end

endfunction
