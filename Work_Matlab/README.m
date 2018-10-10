## Baseline runs for the scilab work
## Run these in Octave

a=[1 2;3 4];b=[5 6]';c=[7 8; 9 10];d=[11 12]';sys=pack_ss(a,b,c,d)
##sys =
##
##     1     2   NaN     5
##     3     4   NaN     6
##   NaN   NaN   NaN   NaN
##     7     8   NaN    11
##     9    10   NaN    12


pkg load control; myLag=lag(0.1);mySys=adjoin(myLag, myLag);CM=[2 1];INPUTS=[1];OUTPUTS=[2];SYS=connect_ss(mySys, CM, INPUTS, OUTPUTS)
##SYS.a =
##        x1   x2
##   x1  -10    0
##   x2   10  -10
##
##SYS.b =
##       u1
##   x1  10
##   x2   0
##
##SYS.c =
##       x1  x2
##   y1   0   1
##
##SYS.d =
##       u1
##   y1   0

pkg load control; myLag=lag(0.1);mySys=adjoin(myLag, myLag, myLag, myLag);CM=[2 1;3 2;4 3];INPUTS=[1];OUTPUTS=[2];SYS=connect_ss(mySys, CM, INPUTS, OUTPUTS)
##SYS.a =
##        x1   x2   x3   x4
##   x1  -10    0    0    0
##   x2   10  -10    0    0
##   x3    0   10  -10    0
##   x4    0    0   10  -10
##
##SYS.b =
##       u1
##   x1  10
##   x2   0
##   x3   0
##   x4   0
##
##SYS.c =
##       x1  x2  x3  x4
##   y1   0   1   0   0
##
##SYS.d =
##       u1
##   y1   0
##
##Continuous-time model.


pkg load control; vga = lti_fake_vg_b(100, 10, 100, 1, 1, 1, 150000)
##vga.a =
##          x1
##   x1  -6349
##
##vga.b =
##          u1     u2     u3     u4     u5     u6     u7
##   x1  577.2   5772      0   1154      0      0  -1154
##
##vga.c =
##          x1
##   y1   -0.5
##   y2      5
##   y3      0
##   y4      0
##   y5      1
##   y6      0
##   y7      1
##   y8      0
##   y9      0
##   y10     0
##   y11     0
##
##vga.d =
##         u1   u2   u3   u4   u5   u6   u7
##   y1   0.5    0    0    1    0    0    0
##   y2     0   -5    0    0    0    0    0
##   y3     0    0    0    0    0    0    0
##   y4     0    0    0    0    0    0    0
##   y5     0    0    0    0    0    0    0
##   y6     0    0    0    0    0    0    0
##   y7     0    0    0    0    0    0    0
##   y8     0    0    0    0    0    0    0
##   y9     0    0    0    0    0    0    0
##   y10    0    0    0    0    0    0    0
##   y11    0    0    0    0    0    0    0
##
##Continuous-time model.


pkg load control; lti_vol_1(1, 150000, 0.8)
##ans =
##
##      0.00000          NaN   1442.97945  -1442.97945
##          NaN          NaN          NaN          NaN
##      1.00000          NaN      0.00000      0.00000

pkg load control; ori = lti_dor_aptow(1, 1, 0, 1, 1)
##ori =
##
##       0.50000      -0.50000   19020.00000

pkg load control; man_1_mv = lti_man_1_mv(1, 0.1, 0.1, 0.8, 150000, 1)
##man_1_mv.a =
##              x1         x2
##   x1    -0.3568  -1.39e+05
##   x2  1.443e+04          0
##
##man_1_mv.b =
##               u1          u2
##   x1    1.39e+05           0
##   x2           0  -1.443e+04
##
##man_1_mv.c =
##       x1  x2
##   y1   1   0
##   y2   0   1
##
##man_1_mv.d =
##       u1  u2
##   y1   0   0
##   y2   0   0

pkg load control; man_1_vm = lti_man_1_vm(1, 0.1, 0.1, 0.8, 150000, 1)
##man_1_vm.a =
##               x1          x2
##   x1           0  -1.443e+04
##   x2    1.39e+05     -0.3568
##
##man_1_vm.b =
##              u1         u2
##   x1  1.443e+04          0
##   x2          0  -1.39e+05
##
##man_1_vm.c =
##       x1  x2
##   y1   1   0
##   y2   0   1
##
##man_1_vm.d =
##       u1  u2
##   y1   0   0
##   y2   0   0
##
##Continuous-time model.