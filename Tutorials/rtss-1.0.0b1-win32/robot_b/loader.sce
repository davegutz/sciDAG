mode(-1);
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



// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            September 2009
//
// $LastChangedDate: 2009-09-13 14:06:10 +0200(dom, 13 set 2009) $
//
// DO NOT MODIFY BELOW
ierr = execstr("getversion(""scilab"")", "errcatch");
if ierr == 0 then
    disp("RTSS doesn''t work with Scilab >= 5. Please use ScicosLab.");
    abort;
end
if getversion() == "scilab-4.1.2" then
    disp("Prebuilt RTSS is built on top of ScicosLab. Please use ScicosLab instead of Scilab-4.1.2.");
    abort;
end
CurrentDirectory = pwd();
mainpathL = get_absolute_file_path("loader.sce");
chdir(mainpathL);
if isdir("sci_gateway") then
    chdir("sci_gateway");
    exec("loader.sce");
    chdir("..");
end
if isdir("macros") then
    chdir("macros");
    exec("loadmacros.sce");
    chdir("..");
end
if isdir("src") then
    chdir("src");
    exec("loader.sce");
    chdir("..");
end
if isdir("help") then
    chdir("help");
    exec("loadhelp.sce");
    chdir("..");
end
if isdir("scicos") then
    chdir("scicos");
    exec("loadpalette.sce");
    if ~MSDOS then
        exec("set_rtsscg-config.sce");
    end
    chdir("..");
end
if isdir("demos") then
    chdir("demos");
    exec("loaddemos.sce");
    chdir("..");
end
chdir(CurrentDirectory);
clear mainpathL get_absolute_file_path isdir get_file_path librt_path rtscsblocks_path functions CurrentDirectory rtssc_path librtss_path
