function [flag,na] = istito(sys)

// Output variables initialisation (not found in input variables)
flag=[];
na=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// 
// ISTITODetermine whether argument is a TITO system.
// 
// Syntax: FLAG = ISTITO(SYS) or
//         [FLAG,NA] = ISTITO(SYS)
// 
// Purpose:The function ISTITO determines whether the packed matrix
//is in SISO or TITO form.  It may also be asked to return
//the state dimension of the system.
// 
// Input:SYS  - a packed matrix system
// 
// Output:FLAG - one of two values:
//  0 - SYS is SISO
//  1 - SYS is TITO
//NA   - state dimension of SYS
// 
// See Also:

// Called By: STAR_SS



//**********************************************************************

// 
// Calculations
// 
// ! L.30: abs(~abs(sys)<%inf) may be replaced by:
// !    --> ~abs(sys)<%inf if ~abs(sys)<%inf is Real.
// ! L.30: abs(mtlb_all(abs(~abs(sys)<%inf))) may be replaced by:
// !    --> mtlb_all(abs(~abs(sys)<%inf)) if mtlb_all(abs(~abs(sys)<%inf)) is Real.
num = max(size(mtlb_find(abs(mtlb_all(abs(~abs(sys)<%inf))))));
if num==2 then
  // dynamic TITO case
  flag = 1;
  // ! L.34: abs(isnan(sys)) may be replaced by:
  // !    --> isnan(sys) if isnan(sys) is Real.
  // ! L.34: abs(mtlb_all(abs(isnan(sys)))) may be replaced by:
  // !    --> mtlb_all(abs(isnan(sys))) if mtlb_all(abs(isnan(sys))) is Real.
  na = mtlb_s(mtlb_find(abs(mtlb_all(abs(isnan(sys))))),1);
else
  if num==1 then
    // ! L.37: abs(isnan(sys)) may be replaced by:
    // !    --> isnan(sys) if isnan(sys) is Real.
    // ! L.37: abs(mtlb_all(abs(isnan(sys)))) may be replaced by:
    // !    --> mtlb_all(abs(isnan(sys))) if mtlb_all(abs(isnan(sys))) is Real.
  
    if isempty(mtlb_find(abs(mtlb_all(abs(isnan(sys)))))) then
      // static TITO case
      flag = 1;
      na = 0;
    else
      // dynamic SISO case
      flag = 0;
      // ! L.44: abs(isnan(sys)) may be replaced by:
      // !    --> isnan(sys) if isnan(sys) is Real.
      // ! L.44: abs(mtlb_all(abs(isnan(sys)))) may be replaced by:
      // !    --> mtlb_all(abs(isnan(sys))) if mtlb_all(abs(isnan(sys))) is Real.
      na = mtlb_s(mtlb_find(abs(mtlb_all(abs(isnan(sys))))),1);
    end;
  else
    // static SISO case
    flag = 0;
    na = 0;
  end;
end;
endfunction
