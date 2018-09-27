function [ns] = issys(x)

// Output variables initialisation (not found in input variables)
ns=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// 

// ISSYSDetermine whether argument is a system.
// 
// Syntax: NS = ISSYS(X)
// 
// Purpose:The function ISSYS returns the state dimension of a variable,
//which is nonzero if the argument is a packed matrix, and
//zero if a regular matrix.
// 
// Input:X- Variable who''s state dimension is to be computed.
// 
// Output:NS- A scalar containing the state dimension of X.  If
//X is a regular matrix variable, then NS = 0.
// 
// See Also:

// Algorithm:
// 
// Calls:
// 
// Called By:

//**********************************************************************
// 
// ! L.27: abs(isnan(x)) may be replaced by:
// !    --> isnan(x) if isnan(x) is Real.
// ! L.27: abs(mtlb_all(abs(isnan(x)))) may be replaced by:
// !    --> mtlb_all(abs(isnan(x))) if mtlb_all(abs(isnan(x))) is Real.
ns = mtlb_find(abs(mtlb_all(abs(isnan(x)))));
// 
if ~isempty(ns) then
  ns = mtlb_s(ns,1);
else
  ns = 0;
end;
endfunction
