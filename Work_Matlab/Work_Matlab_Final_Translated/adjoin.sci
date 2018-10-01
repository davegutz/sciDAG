function [so] = adjoin(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15)
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
    // Sep 26, 2018 	DA Gutz		Created
    // 
    //**********************************************************************

    // Output variables initialisation (not found in input variables)
    so=[];

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    //**********************************************************************
    narginchk(%nargin,2,15);

    // 
    s_f = evstr("s"+string(%nargin));
    // if isstr(s_f)
    if type(s_f)==10 then
        if mtlb_logic(s_f,"==","v") then
            // Vertical stacking operation
            [ao,bo,co,eo] = unpack_ss(s1);  [a1,b1,tmp,tmp1] = unpack_ss(s1);
            [tmp,p1,tmp1] = size_ss(s1);
            for i = 2:%nargin-1
                si = mtlb_eval("s"+string(i));
                [ai,bi,ci,ei] = unpack_ss(si);
                [mi,pi,ni] = size_ss(si);
                [mo,tmp1] = size(eo);  [tmp,no] = size(ao);
                if mtlb_logic(pi,"<>",p1) then
                    error("Incompatible dimensions for adjoin operation");
                end;
                if mtlb_logic(no,"==",ni) then
                    // ! L.54: abs(mtlb_s(a1,ai)) may be replaced by:
                    // !    --> mtlb_s(a1,ai) if mtlb_s(a1,ai) is Real.
                    // ! L.54: abs(mtlb_any(abs(mtlb_s(a1,ai)))) may be replaced by:
                    // !    --> mtlb_any(abs(mtlb_s(a1,ai))) if mtlb_any(abs(mtlb_s(a1,ai))) is Real.
                    // ! L.54: abs(mtlb_s(b1,bi)) may be replaced by:
                    // !    --> mtlb_s(b1,bi) if mtlb_s(b1,bi) is Real.
                    // ! L.54: abs(mtlb_any(abs(mtlb_s(b1,bi)))) may be replaced by:
                    // !    --> mtlb_any(abs(mtlb_s(b1,bi))) if mtlb_any(abs(mtlb_s(b1,bi))) is Real.
                    %v05 = %f;  if ~mtlb_any(abs(mtlb_any(abs(mtlb_s(a1,ai))))) then %v05 = ~mtlb_any(abs(mtlb_any(abs(mtlb_s(b1,bi)))));end;
                    if %v05 then
                        co = [co;ci,zeros_ss(pi,mtlb_s(no,ni))];
                    else
                        ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
                        bo = [bo;bi];
                        co = [co,zeros_ss(mo,ni);zeros_ss(mi,no),ci];
                    end;
                else
                    ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
                    bo = [bo;bi];
                    co = [co,zeros_ss(mo,ni);zeros_ss(mi,no),ci];
                end;
                eo = [eo;ei];
            end;
        else
            if mtlb_logic(s_f,"==","h") then
                // Horizontal stacking operation
                [ao,bo,co,eo] = unpack_ss(s1);  [a1,tmp,c1,tmp1] = unpack_ss(s1);
                [m1,tmp,tmp1] = size_ss(s1);
                for i = 2:%nargin-1
                    si = mtlb_eval("s"+string(i));
                    [ai,bi,ci,ei] = unpack_ss(si);
                    [mi,pi,ni] = size_ss(si);
                    [tmp,po] = size(eo);  [tmp,no] = size(ao);
                    if mtlb_logic(mi,"<>",m1) then
                        error("Incompatible dimensions for adjoin operation");
                    end;
                    if mtlb_logic(no,"==",ni) then
                        // ! L.81: abs(mtlb_s(a1,ai)) may be replaced by:
                        // !    --> mtlb_s(a1,ai) if mtlb_s(a1,ai) is Real.
                        // ! L.81: abs(mtlb_any(abs(mtlb_s(a1,ai)))) may be replaced by:
                        // !    --> mtlb_any(abs(mtlb_s(a1,ai))) if mtlb_any(abs(mtlb_s(a1,ai))) is Real.
                        // ! L.81: abs(mtlb_s(c1,ci)) may be replaced by:
                        // !    --> mtlb_s(c1,ci) if mtlb_s(c1,ci) is Real.
                        // ! L.81: abs(mtlb_any(abs(mtlb_s(c1,ci)))) may be replaced by:
                        // !    --> mtlb_any(abs(mtlb_s(c1,ci))) if mtlb_any(abs(mtlb_s(c1,ci))) is Real.
                        %v16 = %f;  if ~mtlb_any(abs(mtlb_any(abs(mtlb_s(a1,ai))))) then %v16 = ~mtlb_any(abs(mtlb_any(abs(mtlb_s(c1,ci)))));end;
                        if %v16 then
                            bo = [bo,[bi;zeros_ss(mtlb_s(no,ni),mi)]];
                        else
                            ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
                            bo = [bo,zeros_ss(no,pi);zeros_ss(ni,po),bi];
                            co = [co,ci];
                        end;
                    else
                        ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
                        bo = [bo,zeros_ss(no,pi);zeros_ss(ni,po),bi];
                        co = [co,ci];
                    end;
                    eo = [eo,ei];
                end;
            else
                errmsg = "Unrecognized input argument: s"+string(%nargin)+" = "" "+s_f+" """;
                error(errmsg);
            end;
        end;
    else
        [ao,bo,co,eo] = unpack_ss(s1);  // Block-diagonal adjoin
        for i = 2:%nargin
            si = evstr("s"+string(i));
            [ai,bi,ci,ei] = unpack_ss(si);
            [mi,pi,ni] = size_ss(si);
            [mo,po] = size(eo);  [tmp,no] = size(ao);
            ao = [ao,zeros_ss(no,ni);zeros_ss(ni,no),ai];
            bo = [bo,zeros_ss(no,pi);zeros_ss(ni,po),bi];
            co = [co,zeros_ss(mo,ni);zeros_ss(mi,no),ci];
            eo = [eo,zeros_ss(mo,pi);zeros_ss(mi,po),ei];
        end;
    end;
    so = pack_ss(ao,bo,co,eo);
    // 
endfunction
