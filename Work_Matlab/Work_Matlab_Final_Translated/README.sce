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
test_run(pwd(), 'lti_pos_pump')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16392_16\lti_pos_pump.dia')
test_run(pwd(), 'narginchk')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\narginchk.dia')
test_run(pwd(), 'pack_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\pack_ss.dia')
test_run(pwd(), 'size_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\size_ss.dia')
test_run(pwd(), 'ssqr')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16392_16\ssqr.dia')
test_run(pwd(), 'ssqrt')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_16392_16\ssqrt.dia')
test_run(pwd(), 'unpack_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\unpack_ss.dia')
test_run(pwd(), 'zeros_ss')
editor('C:\Users\Dave\AppData\Local\Temp\SCI_TMP_3552_19168\zeros_ss.dia')
