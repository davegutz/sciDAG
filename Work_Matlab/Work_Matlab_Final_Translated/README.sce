// Copyright (C) 2018 - Dave Gutz
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
// Oct 10, 2018 	DA Gutz		Created
// 
// Translated work .m files into .sci
// See help matlab to scilab conversion tips
// or m2sci
// or mfile2sci()
// Two steps:  
//    1) use builtin scilab translator
// 	  2) hand edit

//mfile2sci()  // gui
//	Conversion mode
//		Convert a single file
//	Input file
//		<mfile>
//	Output directory
//		C:\Users\Dave\Documents\GitHub\sciDAG\Work_Matlab\Work_Matlab_Initial_Translated
//	Options
//		Recursive conversion: No
//		Only double values used: No
//		Verbose mode: 3
//		Generate pretty printed code: No
		
// runnimg above will over-write your work.  I typically do this once then 
// copy <mfile>.sci into 'Work_Matlab\Work_Matlab_Final_Translated' and hand edit from there

// example:
mfile2sci('./adjoin.m', 'C:/Users/Dave/Documents/GitHub/sciDAG/Work_Matlab/Work_Matlab_Initial_Translated/')
// adjoin.sci will have !!L. issues in it.
// copy adjoin.sci to Work_Matlab\Work_Matlab_Final_Translated\.

// To use this library:
getd('../Work_Matlab_Final_Translated')

// To test all (result should be 'ans = T' for success):
test_run(pwd())

// To test individual functions
test_run(pwd(), 'adjoin')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\adjoin.dia')
test_run(pwd(), 'connect_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_10656_31074\connect_ss.dia')
test_run(pwd(), 'default')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\default.dia')
test_run(pwd(), 'get_stamp')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\get_stamp.dia')
test_run(pwd(), 'hole')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\hole.dia')
test_run(pwd(), 'ip_wtodp')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_12768_19134\ip_wtodp.dia')
test_run(pwd(), 'issys')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\isysy.dia')
test_run(pwd(), 'istito')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\istito.dia')
test_run(pwd(), 'la_kptow')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_12768_19134\la_kptow.dia')
test_run(pwd(), 'lag')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_12768_19134\lag.dia')
test_run(pwd(), 'lti_actuator_b')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_12768_19134\lti_actuator_b.dia')
test_run(pwd(), 'lti_dor_aptow')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_10656_31074\lti_dor_aptow.dia')
test_run(pwd(), 'lti_dor_awpdtops')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_dor_awpdtops.dia')
test_run(pwd(), 'lti_dor_awpstopd')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_dor_awpstopd.dia')
test_run(pwd(), 'lti_dpsdw')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_dpsdw.dia')
test_run(pwd(), 'lti_dwdp')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_dwdp.dia')
test_run(pwd(), 'lti_fake_vg_b')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_fake_vg_b.dia')
test_run(pwd(), 'lti_head_b')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_head_b.dia')
test_run(pwd(), 'lti_ip_wppdtops')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_ip_wpdtops.dia')
test_run(pwd(), 'lti_ip_wppstopd')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_ip_wpstopd.dia')
test_run(pwd(), 'lti_m_valve_a')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\lti_m_valve_a.dia')
test_run(pwd(), 'lti_man_1_mv')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16636_22599\lti_man_1_mv.dia')
test_run(pwd(), 'lti_man_1_vm')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16636_22599\lti_man_1_vm.dia')
test_run(pwd(), 'lti_mom_1')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16636_22599\lti_mom_1.dia')
test_run(pwd(), 'lti_man_n_mm')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_7696_3964\lti_man_n_mm.dia')
test_run(pwd(), 'lti_man_n_mv')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_7696_3964\lti_man_n_mv.dia')
test_run(pwd(), 'lti_man_n_vm')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_13404_6173\lti_man_n_vm.dia')
test_run(pwd(), 'lti_man_n_vv')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_13404_6173\lti_man_n_vv.dia')
test_run(pwd(), 'lti_pos_pump')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16392_16\lti_pos_pump.dia')
test_run(pwd(), 'lti_spring')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_13404_6173\lti_spring.dia')
test_run(pwd(), 'lti_vol_1')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16636_22599\lti_vol_1.dia')
test_run(pwd(), 'narginchk')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\narginchk.dia')
test_run(pwd(), 'or_aptow')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_10656_31074\or_aptow.dia')
test_run(pwd(), 'or_awtop')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_10656_31074\or_awtop.dia')
test_run(pwd(), 'or_wptoa')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_10656_31074\or_wptoa.dia')
test_run(pwd(), 'pack_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\pack_ss.dia')
test_run(pwd(), 'size_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\size_ss.dia')
test_run(pwd(), 'ssqr')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16392_16\ssqr.dia')
test_run(pwd(), 'ssqrt')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16392_16\ssqrt.dia')
test_run(pwd(), 'summer')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_6828_32050\summer.dia')
test_run(pwd(), 'sys_connect')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_10656_31074\sys_connect.dia')
test_run(pwd(), 'sys_prune')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_10656_31074\sys_prune.dia')
test_run(pwd(), 'unpack_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\unpack_ss.dia')
test_run(pwd(), 'zeros_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\zeros_ss.dia')
