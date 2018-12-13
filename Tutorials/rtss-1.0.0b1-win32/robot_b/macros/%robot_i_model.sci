// Copyright (C) 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function [res] = %robot_i_model(field, rr, mm)
// File name:       %s_i_robot.sci
//
// Function:        r.field = v
//
// Description:     Save the robot data in a Scicos block.
//
// Annotations:     The robot data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke (see rt_robot.sci
//                  for details).
//
//                  This code is used in developing some Scicos blocks for the Robotics Palette.
//                  
//                  The Robotics Palette provides several Scicos blocks that operate on
//                  robot objects. In the Interfacing Function of any of these blocks, the
//                  robot model to be simulated is stored in the list of objects block
//                  parameters: model.opar. Although the robot object can be correctly
//                  stored as the entire MLIST, and then recovered in the Computational
//                  Function of the block itself, this way of proceeding is not completely
//                  satisfactory, because it makes the block incompatible with the tools for
//                  Code Generation that are currently available for Scicos (Code_Generation
//                  Toolbox of Scicos, Scicos RTAI and the Scilab/Scicos FLEX Code Generator),
//                  when these tools are used to generate standalone executables.
//
//                  The following components of a robot object are stored at top of model.opar:
//
//                      the legacy matrix
//                      =================
//                          DH/DYN, see help("rt_robot") for further details
//
//                      parameters that are discarded by the legacy matrix
//                      ==================================================
//                          mdh
//                          offset
//                          qlim
//
//                      robot's extension parameters
//                      ============================
//                          gravity
//                          base
//                          tool
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2009
//
// $LastChangedDate: 2009-04-24 17:49:57 +0200(ven, 24 apr 2009) $


    if typeof(field) ~= "string" then

        error("only .field supported");

    else

        // choose a legacy matrix
        select field,
            case "rtss_dyn" then
                dyndh = "dyn";
            case "rtss_dh" then
                dyndh = "dh";
            else
                error("unknown method");
        end
        // names of parameters to be saved in the block model (in reverse order)
        pars = [ "tool";..      // robot's extension parameters
                 "base";..
                 "gravity";..
                 "qlim";..      // parameters that are discarded by the legacy matrix
                 "offset";..
                 "mdh";..
                 dyndh..        // legacy matrix
               ]';
        // insert each parameter at top of model.opar
        for k = pars,
            mm.opar(0) = rr(k);
        end
        // return the modified block model to Scilab' workspace
        res = mm;

    end
    
endfunction
