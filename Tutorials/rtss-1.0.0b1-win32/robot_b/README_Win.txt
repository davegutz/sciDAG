                RTSS - The Robotics Toolbox for Scilab/Scicos
                =============================================
                                version  1.0.0b1                                
                                ================

Matteo Morelli, September 2009.
$LastChangedDate: 2009-09-19 11:17:39 +0200(sab, 19 set 2009) $.

********************************************************************************

0 - COPYRIGHT NOTICE
====================

  RTSS, the Robotics Toolbox for Scilab/Scicos, is free software released under
  the terms of the GNU General Public License.

  See the included license: "license.txt" in English.

********************************************************************************

I - WHAT'S NEW IN RELEASE 1.0.0b1
=================================

  The 1.0.0 is the first major upgrade of RTSS. Many changes have occurred since
  the latest stable release, version 0.3.0. The following is a short summary of
  them. For further info on the topics below, please refer to the corresponding
  page at the RTSS Development Wiki: http://sourceforge.net/apps/mediawiki/rtss.
  For further details about a bug fix, please refer to the corresponding item at
  RTSS Bug Tracker: http://sourceforge.net/tracker/?group_id=206553&atid=998060.

    1 - Code Refactoring

      A new modular and extensible framework has been developed, which will
      facilitate current and future developments of RTSS.

      The internal representation of data in RTSS has been completely
      re-designed, mainly for fixing several issues resulting from its original
      implementation, but also in order to improve code extensibility,
      portability and maintainability. However, this might led to situations in
      which the Scilab code developed for RTSS-0.x has to be manually revisited,
      in order to ensure the compatibility with the new versions. Users are
      strongly advised to learn more about this topic, by reading the article
      titled "Backward compatibility issues between RTSS-1.x and RTSS-0.x" and
      the references therein, at the RTSS Development Wiki.

    2 - Scicos Code Generation Support

      RTSS is now fully compatible with a broad range of code generators
      available for Scicos, specifically:

        * Scicos RTAI Code Generator (GNU/Linux only);

        * Scilab/Scicos Code Generator for Xenomai (GNU/Linux only);

        * Code_Generation Toolbox of Scicos.

      However, currently, the code of the simulation functions of the blocks
      provided by the Robotics Palette is x86-architecture oriented. Further
      work has to be carried out in order to make RTSS compatible also with the
      Scilab/Scicos code generator for the FLEX Board, because of specific
      resources management constraints imposed by microcontroller-based systems
      like dsPIC.

    3 - More Scicos Blocks in the Robotics Palette

      Three new Scicos blocks have been added for that release:

        * Coriolis

          For a robot model specified as block parameter, the block computes the
          manipulator Coriolis/centripetal torque components, from joint state
          and velocity vectors. It can be viewed as the Scicos counterpart of
          the Scilab macro named rt_coriolis().

        * Gravload:

          For a robot model specified as block parameter, the block computes the
          manipulator gravity torque components, from a joint state vector. It
          can be viewed as the Scicos counterpart of the Scilab macro named
          rt_gravload().

        * Inertia: 

          For a robot model specified as block parameter, the block computes the
          manipulator joint-space inertia matrix, from a joint state vector.
          It can be viewed as the Scicos counterpart of the Scilab macro named
          rt_inertia().

    4 - Compatibility with ScicosLab-4.3

      The prebuilt distribution of RTSS is built on top of ScicosLab, therefore
      it requires ScicosLab to run.

      If, for some reason, you need to work with the old Scilab-4.1.2 distrib.,
      e.g. to use RTSS in conjunction with another package not yet fully
      compatible with ScicosLab, you should consider to install the source
      version of RTSS, which works with all the versions of Scilab based on the
      official Scilab BUILD4 distribution.

      Currently, RTSS is not yet compatible with Scilab-5.x. For further details
      on this subject, please refer to the article titled "Compatibility with
      Scilab-5.x" at RTSS Development Wiki.

    5 - Fixed Bug #1830632.

      RTSS now uses dedicated routines for memory management on Windows systems.
      Therefore, it works now also with Microsoft Windows Vista and _should_ not
      have problems running on Windows 7.

    6 - Fixed Bug #2779877.

      A bug in the FRNE routine (whose source code is now placed in file
      src/rtss_dynamics.c) has been fixed; the bug caused troubles when the
      description of the robot model to be simulated was based on the MDH
      convention _and_ the first joint of the robot model was a prismatic one.

********************************************************************************

II - INSTALL THE ROBOTICS TOOLBOX FOR SCILAB/SCICOS
===================================================

  The prebuilt distribution is for 32-bit systems only. The DLL files were
  compiled with Microsoft Visual C++ 2008 Express Edition.

  The only requirement for installing the prebuilt distribution of RTSS is to
  have ScicosLab installed.

  To install RTSS on your machine,just unpack the file rtss-1.0.0b1-win32.tar.gz
  in a directory of your own choice, provided that the path to this directory
  does not contain any spaces. You will get a folder called robot_b, but you can
  give the folder any name (of course, the name must not contain any spaces).

  From now on, the path to the robot_b directory will be referred to as
  <RTSSDIR>. As an example, in my Windows Vista PC, <RTSSDIR> is
  C:\Users\matt\robot_b\.

********************************************************************************

III - LOAD THE ROBOTICS TOOLBOX FOR SCILAB/SCICOS
=================================================

  Open the Scilab prompt and type the following command:

                           exec <RTSSDIR>\loader.sce;

  This will load the toolbox into Scilab. You must type this command in every
  Scilab session that you want to use the toolbox.

  Note that, as the final user, you may want RTSS to be loaded automatically. To
  do this just put the above command in your SCI\scilab.star startup file for
  automatic loading.

  An additional caveat: if somewhere in your scilab session you run the clear
  command, you will have to reload the toolbox. To avoid that, you can add the
  command predef('all') in your SCI\scilab.star file after your
  exec <RTSSDIR>\loader.sce command.

  As an example, below is the sequence you could do on your own machine for
  automatic loading:

    1 - open SCI\scilab.star file with your favorite text editor.

    2 - Add the following line at the end of SCI\scilab.star:

                           exec <RTSSDIR>\loader.sce;

    3 - Add the following line after your exec command:

                                 predef('all');

    4 - save the SCI\scilab.star file.

  That's it! Every time you enter scilab it already loads RTSS and even if you
  run the clear command you won't have to reload the toolbox anymore.

********************************************************************************
IV - REMARKS
============

  All the articles referenced below can be found at RTSS Development Wiki:
  http://sourceforge.net/apps/mediawiki/rtss.

  RTSS is inspired to version 7.1 of the MATLAB(R) Robotics Toolbox (MRT) by
  Peter Corke (2002). Since December 2008, a new release of MRT is available for
  download at http://www.petercorke.com/robot/, in which several functions have
  been redefined. However, RTSS won't track the changes introduced in the latest
  release of MRT. For a summary of the most significant differences between RTSS
  and MRT version 7.1, please refer to the article titled "Differences with
  Robotics Toolbox for MATLAB(R)".

  The internal representation of data in RTSS has been completely re-designed,
  and this might led to situations in which the Scilab code developed for
  RTSS-0.x has to be manually revisited, in order to ensure the compatibility
  with the new versions. Users are strongly advised to learn more about this
  topic, by reading the article titled "Backward compatibility issues between
  RTSS-1.x and RTSS-0.x", and the references therein.

  RTSS is now fully compatible with a broad range of code generators available
  for Scicos. In order to generate C code from Scicos diagrams containing RTSS
  blocks, code generators must be instructed which external (static) library to
  use. For further information on this subject, please refer to the article
  titled "How to - Code Generation".

********************************************************************************
V - DOCUMENTATION
=================

  Beware: all the documentation is currently under revision. The documentation
  provided along with this beta release might be incomplete or just out-of-date.
  Users are encouraged to report any inaccuracy in the RTSS Help forum:
  http://sourceforge.net/forum/forum.php?forum_id=739568

  Detailed HTML help documentation, written in English language, is provided for
  each Scilab function and Scicos block in the toolbox. Every help page is
  enriched with many examples which illustrate the usage of the corresponding
  Scilab function or Scicos block.

  RTSS comes with several demonstration scripts which show how the toolbox can
  be productively used in studying robotics. Demos on subjects like

    a - Homogeneous Transformations

    b - Cartesian and joint-space Trajectories

    c - Forward and Inverse Kinematics

    d - Differential Motions and Manipulator Jacobians

    e - Forward and Inverse Dynamics

    f - Graphical Animations of Robot Motions,

  can be run individually by choosing "Robotics" in the Scilab demo menu.

  Other demos are provided with RTSS.

    g.1 - Dynamic simulation of Puma 560 robot collapsing under gravity;

    g.2 - Computed torque control of a Puma 560 robot;

    g.3 - Open-loop inverse Jacobian algorithm for a three-DOF (RRR) planar arm;

    g.4 - Closed-loop inverse Jacobian algorithm for a three-DOF (RRR) planar
    arm;

    g.5 - Jacobian pseudo-inverse algorithm for a kinematically redundant RRR
    planar arm;

    g.6 - Jacobian pseudo-inverse algorithm for a kinematically redundant RRR
    planar arm, with mechanical joint limit constraints.

  They give the users an insight into the use of RTSS for constructing robot
  kinematic and dynamic models with Scicos, as explained in the companion paper
  titled rtss-scicos.pdf, located in the <RTSSDIR>\etc\ directory. Also, on this
  subject, users might find useful a collection of slides I presented at first
  HeDiSC Workshop On Open Source Software for Control Systems, which took place
  in Lugano (Switzerland) at SUPSI-DTI, at the end of June 2009. The original
  presentation, without multimedia content, is shipped inside this distribution,
  in the <RTSSDIR>\etc\ directory. The full presentation, with animations, is
  available at: http://rtss.sourceforge.net/docs/hedisc09-morelli.zip

  Lastly, users can run test scripts which permit to compare performances
  between the Scilab and C version of algorithm that computes inverse dynamics
  via recursive Newton-Euler formulation (RNE), for the following robot models:

    a - Puma 560

    b - Stanford Arm

  There is no detailed documentation about them available yet. At the moment,
  the only information provided comes from comments that the scripts display on
  screen.

  Test script for the Puma 560 can be executed by typing the following command
  at Scilab prompt:

                  exec <RTSSDIR>\unit-tests\rt_pumacheck.tst;

  Test script for the Stanford Robot Arm can be run with the following command,
  instead:

                  exec <RTSSDIR>\unit-tests\rt_stanfcheck.tst;

********************************************************************************
VI - TOOLBOX COMPOSITION
========================

  The root directory contains 10 sub-directories:

    1 - includes

      Headers (all .h files).

    2 - src

      Source code (all .c files), shared libraries and a loader script.

    3 - sci_gateway

      Interfaces programs (all .c files), shared libraries and a loader script.

    4 - macros

      Scilab macros (all .sci files), binary files (all .bin files), library
      variable (file lib), loadmacros script.

    5 - models

      Scilab scripts (all .sce files) which create models of well known robots.

    6 - scicos

      Robotics Palette sub-directories and the loadpalette script.

    7 - help

      English help sub-directory named eng which contains all the .html help
      files and the loadhelp script.

    8 - unit-tests

      Scilab scripts to test the toolbox (.tst files).

    9 - demos

      Different examples to illustrate the toolbox.

    10 - etc

      Explanation of the Scicos demos that are provided with the toolbox (.pdf
      files).

  and 3 files:

    1 - loader.sce

      The main loader script.

    2 - README_Win.txt

      This file. Notes about toolbox description and installation.

    3 - license.txt

      The text of the GNU General Public License Version 2, under which the
      toolbox is distributed.

********************************************************************************
VII - AKNOWLEDGEMENTS
=====================

  I, the author, wish to thanks Professor Peter I. Corke, who kindly allowed me
  to modify part of his work and redistribute it under the terms of the GNU
  General Public License.

  I want also to thanks my supervisor, Professor Antonio Bicchi, for his endless
  patience, support and guidance.

  Special thanks go to those who assisted me in the development of the Robotics
  Palette, notably Roberto Bucher, Paolo Gai and Simone Mannori, who spent long
  hours in discussions about code generation and provided valuable information,
  ideas and assistance during the testing. I am also indebted to Alan Layec and
  Ramine Nikoukhah whose observations and in-depth explainations of the Scicos
  formalism helped me to fix several bugs and clarify my knowledge of Scicos at
  a great number of points.

  Finally, I would like to thanks all the people in the Scilab Newsgroup, who
  generously helped me in all my efforts with helpful suggestions and comments,
  especially Allan Cornet, Enrico Segre, Serge Steer and Francois Vogel.

********************************************************************************
THAT'S ALL FOLKS
********************************************************************************
