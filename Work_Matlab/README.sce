// Translate work .m files into .sci
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
mfile2sci
// select adjoin.m
// select Work_Matlab\Work_Matlab_Initial_Translated
// log echoed to cli
// adjoin.sci will have !!L. issues in it.
// copy adjoin.sci to Work_Matlab\Work_Matlab_Final_Translated\.
// <mfile>_test.sce will perform a test on module


