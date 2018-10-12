## Baseline runs for the scilab work
## Run these in Octave in Linux (Ubuntu)

a=[1 2;3 4];b=[5 6]';c=[7 8; 9 10];d=[11 12]';sys=pack_ss(a,b,c,d)
##sys =
##
##     1     2   NaN     5
##     3     4   NaN     6
##   NaN   NaN   NaN   NaN
##     7     8   NaN    11
##     9    10   NaN    12


pkg load control; myLag=lag(0.1);mySys=adjoin(myLag, myLag);CM=[2 1];INPUTS=[1];OUTPUTS=[2];SYS=connect_ss(mySys, CM, INPUTS, OUTPUTS)
##SYS =
##
##   -10     0   NaN    10
##    10   -10   NaN     0
##   NaN   NaN   NaN   NaN
##     0     1   NaN     0

  
pkg load control; myLag=lag(0.1);mySys=adjoin(myLag, myLag, myLag, myLag);CM=[2 1;3 2;4 3];INPUTS=[1];OUTPUTS=[2];SYS=connect_ss(mySys, CM, INPUTS, OUTPUTS)
##SYS =
##
##   -10     0     0     0   NaN    10
##    10   -10     0     0   NaN     0
##     0    10   -10     0   NaN     0
##     0     0    10   -10   NaN     0
##   NaN   NaN   NaN   NaN   NaN   NaN
##     0     1     0     0   NaN     0


pkg load control; vga = lti_fake_vg_b(100, 10, 100, 1, 1, 1, 150000)
##vga =
##
## Columns 1 through 7:
##
##  -6349.10960          NaN    577.19178   5771.91782      0.00000   1154.38356      0.00000
##          NaN          NaN          NaN          NaN          NaN          NaN          NaN
##     -0.50000          NaN      0.50000      0.00000      0.00000      1.00000      0.00000
##      5.00000          NaN      0.00000     -5.00000      0.00000      0.00000      0.00000
##      0.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      0.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      1.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      0.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      1.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      0.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      0.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      0.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##      0.00000          NaN      0.00000      0.00000      0.00000      0.00000      0.00000
##
## Columns 8 and 9:
##
##      0.00000  -1154.38356
##          NaN          NaN
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000
##      0.00000      0.00000

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
##man_1_mv =
##
##       -0.35682  -138960.00000            NaN   138960.00000        0.00000
##    14429.79455        0.00000            NaN        0.00000   -14429.79455
##            NaN            NaN            NaN            NaN            NaN
##        1.00000        0.00000            NaN        0.00000        0.00000
##        0.00000        1.00000            NaN        0.00000        0.00000
        
        
pkg load control; man_1_vm = lti_man_1_vm(1, 0.1, 0.1, 0.8, 150000, 1)
##man_1_vm =
##
##        0.00000   -14429.79455            NaN    14429.79455        0.00000
##   138960.00000       -0.35682            NaN        0.00000  -138960.00000
##            NaN            NaN            NaN            NaN            NaN
##        1.00000        0.00000            NaN        0.00000        0.00000
##        0.00000        1.00000            NaN        0.00000        0.00000

        
        
 pkg load control; man_n_mm = lti_man_n_mm(24, 0.1, 2.4, 4, 0.8, 150000, 1)
##man_n_mm =
##
## Columns 1 through 6:
##
##      -1.71276  -28950.00000       0.00000       0.00000       0.00000       0.00000
##    2404.96576       0.00000   -2404.96576       0.00000       0.00000       0.00000
##       0.00000   28950.00000      -1.71276  -28950.00000       0.00000       0.00000
##       0.00000       0.00000    2404.96576       0.00000   -2404.96576       0.00000
##       0.00000       0.00000       0.00000   28950.00000      -1.71276  -28950.00000
##       0.00000       0.00000       0.00000       0.00000    2404.96576       0.00000
##       0.00000       0.00000       0.00000       0.00000       0.00000   28950.00000
##       0.00000       0.00000       0.00000       0.00000       0.00000       0.00000
##       0.00000       0.00000       0.00000       0.00000       0.00000       0.00000
##           NaN           NaN           NaN           NaN           NaN           NaN
##       1.00000       0.00000       0.00000       0.00000       0.00000       0.00000
##       0.00000       0.00000       0.00000       0.00000       0.00000       0.00000
##
## Columns 7 through 12:
##
##       0.00000       0.00000       0.00000           NaN   28950.00000       0.00000
##       0.00000       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       0.00000       0.00000           NaN       0.00000       0.00000
##   -2404.96576       0.00000       0.00000           NaN       0.00000       0.00000
##      -1.71276  -28950.00000       0.00000           NaN       0.00000       0.00000
##    2404.96576       0.00000   -2404.96576           NaN       0.00000       0.00000
##       0.00000   28950.00000       0.00000           NaN       0.00000  -28950.00000
##           NaN           NaN           NaN           NaN           NaN           NaN
##       0.00000       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       0.00000       1.00000           NaN       0.00000       0.00000

pkg load control; man_n_mv = lti_man_n_mv(24, 0.1, 2.4, 4, 0.8, 150000, 1)
##man_n_mv =
##
## Columns 1 through 6:
##
##      -2.14095  -23160.00000       0.00000       0.00000       0.00000       0.00000
##    2404.96576       0.00000   -2404.96576       0.00000       0.00000       0.00000
##       0.00000   23160.00000      -2.14095  -23160.00000       0.00000       0.00000
##       0.00000       0.00000    2404.96576       0.00000   -2404.96576       0.00000
##       0.00000       0.00000       0.00000   23160.00000      -2.14095  -23160.00000
##       0.00000       0.00000       0.00000       0.00000    2404.96576       0.00000
##       0.00000       0.00000       0.00000       0.00000       0.00000   23160.00000
##       0.00000       0.00000       0.00000       0.00000       0.00000       0.00000
##           NaN           NaN           NaN           NaN           NaN           NaN
##       1.00000       0.00000       0.00000       0.00000       0.00000       0.00000
##       0.00000       0.00000       0.00000       0.00000       0.00000       0.00000
##
## Columns 7 through 11:
##
##       0.00000       0.00000           NaN   23160.00000       0.00000
##       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       0.00000           NaN       0.00000       0.00000
##   -2404.96576       0.00000           NaN       0.00000       0.00000
##      -2.14095  -23160.00000           NaN       0.00000       0.00000
##    2404.96576       0.00000           NaN       0.00000   -2404.96576
##           NaN           NaN           NaN           NaN           NaN
##       0.00000       0.00000           NaN       0.00000       0.00000
##       0.00000       1.00000           NaN       0.00000       0.00000
pkg load control signal;
dummy = lti_dpsdw(1);
sys = adjoin(man_n_mv, dummy);
man_n_mv_siso=connect_ss(sys,[3 2],[1],[2]);[a,b,c,d]=unpack_ss(man_n_mv_siso); man_n_mv_lti = ss(a,b,c,d);
eig(a)
##ans  =
##  -1.0704745 + 14026.184i
##  -1.0704745 - 14026.184i
##  -1.0704745 + 11434.25i
##  -1.0704745 - 11434.25i
##  -1.0704745 + 2591.9339i
##  -1.0704745 - 2591.9339i
##  -1.0704745 + 7463.1767i
##  -1.0704745 - 7463.1767i
pkg load control signal;bode(man_n_mv_lti)
