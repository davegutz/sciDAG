function [so] = adjoin(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15)

// Output variables initialisation (not found in input variables)
so=[];

// Number of arguments in function call
[%nargout,%nargin] = argn(0)

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// ADJOINForm composite system interconnection.
// 
// Syntax: So = ADJOIN(S1, ... Sn), or So = ADJOIN(S1, ... Sn-1, FLAG)
// 
// Purpose:The ADJOIN function forms a composite system from
//the state-space realizations of distinct systems.
//The different forms possible include
// 
//[ S1   0  ]                [  S1  ]
//[    \    ],  [S1 --- Sn-1],  [   |  ]
//[  0   Sn ]                   [ Sn-1 ]
// 
//where the latter two are horizontally and vertically
//adjoined systems, obtained with FLAG = ''h'', or FLAG = ''v''
//respectively.
// 
// Input:S1 ,... Sn  - Input systems, in packed matrix form. Currently
//      n is limited to a maximum of 15.
//FLAG- Optional string, either ''h'' indicating the
//horizontal adjoin operation, or ''v'' for vertical.
// 
// Output:So- the composite system, in packed matrix form.
// 
// See Also:ADD_SS, MULT_SS, SUB_SS, INV_SS

// Algorithm:
// 
// Calls:UNPACK_SS, PACK_SS
// 
// Called By:

// SCCS information: %W% %G%


//**********************************************************************
// !! L.37: Unknown function narginchk not converted, original calling sequence used.
narginchk(2,15);
// 
// !! L.39: Matlab function int2str not yet converted, original calling sequence used.
s_f = mtlb_eval("s"+int2str(%nargin));
// if isstr(s_f)
if type(s_f)==10 then
  if mtlb_logic(mtlb_double(s_f),"==",asciimat("v")) then
    // Vertical stacking operation
    // !! L.44: Unknown function unpack_ss not converted, original calling sequence used.
    [ao,bo,co,eo] = unpack_ss(s1);  // !! L.44: Unknown function unpack_ss not converted, original calling sequence used.
    [a1,b1,tmp1,tmp2] = unpack_ss(s1);
    // !! L.45: Unknown function size_ss not converted, original calling sequence used.
    [tmp3,p1,tmp4] = size_ss(s1);
    for i = 2:%nargin-1
      // !! L.47: Matlab function int2str not yet converted, original calling sequence used.
      si = mtlb_eval("s"+int2str(i));
      // !! L.48: Unknown function unpack_ss not converted, original calling sequence used.
      [ai,bi,ci,ei] = unpack_ss(si);  // !! L.48: Unknown function size_ss not converted, original calling sequence used.
      [mi,pi,ni] = size_ss(si);
      [mo,tmp5] = size(mtlb_double(eo));  [tmp6,no] = size(mtlb_double(ao));
      if mtlb_logic(mtlb_double(%pi),"<>",mtlb_double(p1)) then
        error("Incompatible dimensions for adjoin operation");
      end;
      if mtlb_logic(no,"==",mtlb_double(ni)) then
        // ! L.54: abs(mtlb_s(mtlb_double(a1),mtlb_double(ai))) may be replaced by:
        // !    --> mtlb_s(mtlb_double(a1),mtlb_double(ai)) if mtlb_s(mtlb_double(a1),mtlb_double(ai)) is Real.
        // ! L.54: abs(mtlb_s(mtlb_double(b1),mtlb_double(bi))) may be replaced by:
        // !    --> mtlb_s(mtlb_double(b1),mtlb_double(bi)) if mtlb_s(mtlb_double(b1),mtlb_double(bi)) is Real.
        %v05 = %f;  if ~mtlb_any(bool2s(mtlb_any(abs(mtlb_s(mtlb_double(a1),mtlb_double(ai)))))) then %v05 = ~mtlb_any(bool2s(mtlb_any(abs(mtlb_s(mtlb_double(b1),mtlb_double(bi))))));end;
        if %v05 then
          // !! L.55: Unknown function zeros_ss not converted, original calling sequence used.
          co = [co;ci,zeros_ss(%pi,mtlb_s(no,mtlb_double(ni)))];
        else
          // !! L.57: Unknown function zeros_ss not converted, original calling sequence used.
          // !! L.57: Unknown function zeros_ss not converted, original calling sequence used.
          ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
          bo = [bo;bi];
          // !! L.59: Unknown function zeros_ss not converted, original calling sequence used.
          // !! L.59: Unknown function zeros_ss not converted, original calling sequence used.
          co = [co,zeros_ss(mo,ni);zeros_ss(mi,no),ci];
        end;
      else
        // !! L.62: Unknown function zeros_ss not converted, original calling sequence used.
        // !! L.62: Unknown function zeros_ss not converted, original calling sequence used.
        ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
        bo = [bo;bi];
        // !! L.64: Unknown function zeros_ss not converted, original calling sequence used.
        // !! L.64: Unknown function zeros_ss not converted, original calling sequence used.
        co = [co,zeros_ss(mo,ni);zeros_ss(mi,no),ci];
      end;
      eo = [eo;ei];
    end;
  else
    if mtlb_logic(mtlb_double(s_f),"==",asciimat("h")) then
      // Horizontal stacking operation
      // !! L.71: Unknown function unpack_ss not converted, original calling sequence used.
      [ao,bo,co,eo] = unpack_ss(s1);  // !! L.71: Unknown function unpack_ss not converted, original calling sequence used.
      [a1,tmp7,c1,tmp8] = unpack_ss(s1);
      // !! L.72: Unknown function size_ss not converted, original calling sequence used.
      [m1,tmp9,tmp10] = size_ss(s1);
      for i = 2:%nargin-1
        // !! L.74: Matlab function int2str not yet converted, original calling sequence used.
        si = mtlb_eval("s"+int2str(i));
        // !! L.75: Unknown function unpack_ss not converted, original calling sequence used.
        [ai,bi,ci,ei] = unpack_ss(si);  // !! L.75: Unknown function size_ss not converted, original calling sequence used.
        [mi,pi,ni] = size_ss(si);
        [tmp11,po] = size(mtlb_double(eo));  [tmp12,no] = size(mtlb_double(ao));
        if mtlb_logic(mtlb_double(mi),"<>",mtlb_double(m1)) then
          error("Incompatible dimensions for adjoin operation");
        end;
        if mtlb_logic(no,"==",mtlb_double(ni)) then
          // ! L.81: abs(mtlb_s(mtlb_double(a1),mtlb_double(ai))) may be replaced by:
          // !    --> mtlb_s(mtlb_double(a1),mtlb_double(ai)) if mtlb_s(mtlb_double(a1),mtlb_double(ai)) is Real.
          // ! L.81: abs(mtlb_s(mtlb_double(c1),mtlb_double(ci))) may be replaced by:
          // !    --> mtlb_s(mtlb_double(c1),mtlb_double(ci)) if mtlb_s(mtlb_double(c1),mtlb_double(ci)) is Real.
          %v16 = %f;  if ~mtlb_any(bool2s(mtlb_any(abs(mtlb_s(mtlb_double(a1),mtlb_double(ai)))))) then %v16 = ~mtlb_any(bool2s(mtlb_any(abs(mtlb_s(mtlb_double(c1),mtlb_double(ci))))));end;
          if %v16 then
            // !! L.82: Unknown function zeros_ss not converted, original calling sequence used.
            bo = [bo,[bi;zeros_ss(mtlb_s(no,mtlb_double(ni)),mi)]];
          else
            // !! L.84: Unknown function zeros_ss not converted, original calling sequence used.
            // !! L.84: Unknown function zeros_ss not converted, original calling sequence used.
            ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
            // !! L.85: Unknown function zeros_ss not converted, original calling sequence used.
            // !! L.85: Unknown function zeros_ss not converted, original calling sequence used.
            bo = [bo,zeros_ss(no,%pi);zeros_ss(ni,po),bi];
            co = [co,ci];
          end;
        else
          // !! L.89: Unknown function zeros_ss not converted, original calling sequence used.
          // !! L.89: Unknown function zeros_ss not converted, original calling sequence used.
          ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
          // !! L.90: Unknown function zeros_ss not converted, original calling sequence used.
          // !! L.90: Unknown function zeros_ss not converted, original calling sequence used.
          bo = [bo,zeros_ss(no,%pi);zeros_ss(ni,po),bi];
          co = [co,ci];
        end;
        eo = [eo,ei];
      end;
    else
      // !! L.96: Matlab function int2str not yet converted, original calling sequence used.
      errmsg = "Unrecognized input argument: s"+int2str(%nargin)+" = "" "+s_f+" """;
      error(errmsg);
    end;
  end;
else
  // !! L.101: Unknown function unpack_ss not converted, original calling sequence used.
  [ao,bo,co,eo] = unpack_ss(s1);
  // Block-diagonal adjoin
  for i = 2:%nargin
    // !! L.103: Matlab function int2str not yet converted, original calling sequence used.
    si = mtlb_eval("s"+int2str(i));
    // !! L.104: Unknown function unpack_ss not converted, original calling sequence used.
    [ai,bi,ci,ei] = unpack_ss(si);  // !! L.104: Unknown function size_ss not converted, original calling sequence used.
    [mi,pi,ni] = size_ss(si);
    [mo,po] = size(mtlb_double(eo));  [tmp13,no] = size(mtlb_double(ao));
    // !! L.106: Unknown function zeros_ss not converted, original calling sequence used.
    // !! L.106: Unknown function zeros_ss not converted, original calling sequence used.
    ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
    // !! L.107: Unknown function zeros_ss not converted, original calling sequence used.
    // !! L.107: Unknown function zeros_ss not converted, original calling sequence used.
    bo = [bo,zeros_ss(no,%pi);zeros_ss(ni,po),bi];
    // !! L.108: Unknown function zeros_ss not converted, original calling sequence used.
    // !! L.108: Unknown function zeros_ss not converted, original calling sequence used.
    co = [co,zeros_ss(mo,ni);zeros_ss(mi,no),ci];
    // !! L.109: Unknown function zeros_ss not converted, original calling sequence used.
    // !! L.109: Unknown function zeros_ss not converted, original calling sequence used.
    eo = [eo,zeros_ss(mo,%pi);zeros_ss(mi,po),ei];
  end;
end;
// !! L.112: Unknown function pack_ss not converted, original calling sequence used.
so = pack_ss(ao,bo,co,eo);
// 
endfunction
