// Copyright (C) 2008  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function [res] = %link_size(l, flag)
// File name:       %link_size.sci
//
// Function:        size(l), size(l, 1), size(l, 2), size(l, "*")
//
// Description:     size of link objects
//
// Annotations:     none
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            March 2008
//
// $LastChangedDate: 2008-03-26 16:07:35 +0100(mer, 26 mar 2008) $

    [%nargout, %nargin] = argn(0);

    select %nargin,

        case 1 then

            res = [1, 1];

        case 2 then

            if flag == 1 | flag == 2 | flag == "*" then
                res = 1;
            else
                error(44, 2);
            end

        else

            error(39);

    end

endfunction
