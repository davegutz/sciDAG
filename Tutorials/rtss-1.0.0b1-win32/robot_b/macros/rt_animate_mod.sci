// Copyright (C) 1993-2002, by Peter I. Corke
// Copyright (C) 2007, 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function rt_animate_mod(robot, q)
// File name:       rt_animate_mod.sci
//
// Function:        rt_animate_mod
//
// Description:     move an existing graphical robot whose kinematic description is based
//                  on the Modified DH notation
//
// Annotations:     this code is a modified port to Scilab of animate's function code in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  Modifies are the following:
//                      1) sorted the standard-DH-based algorithm from the modified-DH-based
//                      2) added a set of istructions for correctly plotting robots whose tool
//                         frame is not coincident with frame attached to link n (see below)
//                      3) istruction Tn(:,:,j) = t; moved from begin to end of cicle for
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/plot.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-07-04 20:17:57 +0200(sab, 04 lug 2009) $

    cfh = gcf();

    h = robot.handles;

    // select figure with this robot as new current figure
    newcfid = h.robot.parent.parent.figure_id;
    point_of_view = h.robot.parent.rotation_angles;
    newcfh = scf(newcfid);
    drawlater();

    mag = h.mag;

    b = rt_transl(robot.base);
    x = b(1);
    y = b(2);
    z = b(3);

    xs = b(1);
    ys = b(2);
    zs = h.zmin;

    // compute the link transforms, and record the origin of each frame
    // for the animation.
    t = robot.base;
    Tn = t;
    for j=1:robot.n,
        t = t * robot.links(j)(q(j));
        x = [x; t(1,4)];
        y = [y; t(2,4)];
        z = [z; t(3,4)];
        xs = [xs; t(1,4)];
        ys = [ys; t(2,4)];
        zs = [zs; h.zmin];
        Tn(:,:,j) = t;
    end
    t = t *robot.tool;
    x = [x; t(1,4)];    // added for correctly plotting robots...
    y = [y; t(2,4)];    // whose tool frame is not coincident...
    z = [z; t(3,4)];    // with frame attached to link n...
    xs = [xs; t(1,4)];  // ...
    ys = [ys; t(2,4)];  // ...
    zs = [zs; h.zmin];  //.

    // draw the robot stick figure and the shadow
    h.robot.data = [x y z];
    if rt_isfield(h,"shadow") & ~isempty(h.shadow) then
        h.shadow.data = [xs ys zs];
    end

    // display the joints as cylinders with rotation axes
    if rt_isfield(h,"joint") & ~isempty(h.joint) then
        xyz_line = [0 0; 0 0; -2*mag 2*mag; 1 1];
        for j=1:robot.n,
            hjoint_j = h.joint(j);
            // get coordinate data from the cylinder
            xyz = hjoint_j.user_data;
            xyz = Tn(:,:,j) * xyz;
            ncols = size(xyz,2)/4;
            //reshape
            datax = matrix(xyz(1,:), 4, ncols);
            datay = matrix(xyz(2,:), 4, ncols);
            dataz = matrix(xyz(3,:), 4, ncols);

            h.joint(j).data = tlist(["3d" "x" "y" "z"],datax,datay,dataz);

            xyzl = Tn(:,:,j) * xyz_line;
            h.jointaxis(j).data = [xyzl(1,:)' xyzl(2,:)' xyzl(3,:)'];

        end
    end

    // display the wrist axes and labels
    if rt_isfield(h,"x") & ~isempty(h.x) then

        // compute the wrist axes, based on final link transformation
        // plus the tool transformation.
        xv = t*[mag;0;0;1];
        yv = t*[0;mag;0;1];
        zv = t*[0;0;mag;1];

        // update the line segments, wrist axis and links
        h.x.data = [t(1,4) t(2,4) t(3,4);xv(1) xv(2) xv(3)];
        h.y.data = [t(1,4) t(2,4) t(3,4);yv(1) yv(2) yv(3)];
        h.z.data = [t(1,4) t(2,4) t(3,4);zv(1) zv(2) zv(3)];
        h.xt.data = xv(1:3);
        h.yt.data = yv(1:3);
        h.zt.data = zv(1:3);
    end

    // maintain old point of view
    newcfh.children.rotation_angles = point_of_view;

    show_pixmap();
    drawnow();

    // re-select previous current figure as new current figure
    scf(cfh);

endfunction
