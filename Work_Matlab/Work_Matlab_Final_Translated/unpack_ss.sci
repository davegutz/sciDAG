// UNPACK_SS    Unpacks a system into component matrices.
// 
// Syntax: [A,B1,B2,C1,C2,D11,D12,D21,D22] = UNPACK_SS(SYS), or ...
//         [A,B,C,D] = UNPACK_SS(SYS) or ...
//         X = UNPACK_SS(SYS,FLAG)
// 
// Purpose:The first version ''unpacks'' the nine constituent matrices
// of a TITO state-space representation.
//               
// The second version ''unpacks'' the four constituent matrices 
// of a SISO state-space representation.
// 
// The third version allows selection of only a single
// element from the SISO state-space quartet or from the
// TITO nantet.
// 
// Input:
//  SYS - Input system, in packed matrix format.
//  FLAG - Optional character used to select only a single
//       matrix or section for unpacking.  Hence FLAG 
//       may be either ''a'', ''b'', ''c'', ''d'', ''b1'', ''b2'', 
//       ''c1'', ''c2'', ''d11'', ''d12'', ''d21'', or ''d22'', in
//       which case the corresponding matrix is unpacked
//       from SYS.
// 
//  Output:
//      A, B1, B2, C1, C2, D11, D12, D21, D22  or ...
//      A, B, C, D 
//- Regular matrices unpacked from SYS.
// 
// See Also:PACK_SS
//**********************************************************************
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
function [a,b1,b2,c1,c2,d11,d12,d21,d22] = unpack_ss(sys,flag)

    // Output variables initialisation (not found in input variables)
    a=[];
    b1=[];
    b2=[];
    c1=[];
    c2=[];
    d11=[];
    d12=[];
    d21=[];
    d22=[];

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);



    //**********************************************************************


    // 
    // Check Arguments
    // 
    exec('narginchk.sci', -1)
    narginchk(%nargin,1,2);
    // 
    %v02 = %f;if %nargin==1 then %v02 = %nargout==1;end;
    if %v02 then
        error("Must specify FLAG when unpacking a single matrix")
    end;
    // 
    //**********************************************************************

    // 
    // Calculations
    // 
    [ms,ns] = size(sys);
    na = mtlb_find(mtlb_all(isnan(sys)));
    // 
    // if there are no NaN''s we have the static system case
    // 
    if isempty(na) then
        a = [];  b1 = [];  b2 = [];  c1 = [];  c2 = [];
        d = sys;
        ne = mtlb_find(mtlb_all(~(abs(sys)<%inf)));
        if isempty(ne) then
            d11 = sys;
            d12 = [];  d21 = [];  d22 = [];
        else
            me = mtlb_find(mtlb_all(~(abs(mtlb_t(sys))<%inf)));
            d11 = sys(mtlb_imp(1,mtlb_s(me,1)),mtlb_imp(1,mtlb_s(ne,1)));
            d12 = sys(mtlb_imp(1,mtlb_s(me,1)),mtlb_imp(mtlb_a(ne,1),ns));
            d21 = sys(mtlb_imp(mtlb_a(me,1),ms),mtlb_imp(1,mtlb_s(ne,1)));
            d22 = sys(mtlb_imp(mtlb_a(me,1),ms),mtlb_imp(mtlb_a(ne,1),ns));
        end;
        // 
        // if there are NaN''s we have either the static or dynamic case
        // 
    else
        // 
        // Unpack A, B, C, and E sections first
        // 
        a = sys(mtlb_imp(1,mtlb_s(na,1)),mtlb_imp(1,mtlb_s(na,1)));
        b = sys(mtlb_imp(1,mtlb_s(na,1)),mtlb_imp(mtlb_a(na,1),ns));
        c = sys(mtlb_imp(mtlb_a(na,1),ms),mtlb_imp(1,mtlb_s(na,1)));
        d = sys(mtlb_imp(mtlb_a(na,1),ms),mtlb_imp(mtlb_a(na,1),ns));
        // 
        // Now get B1, B2, C1, C2, D11, D12, D21, and D22
        // 
        nb1 = mtlb_find(~(b(1,:)<%inf));
        if isempty(nb1) then
            b1 = b;  b2 = [];  d1 = d;  d2 = [];
        else
            b1 = b(mtlb_imp(1,mtlb_s(na,1)),mtlb_imp(1,mtlb_s(nb1,1))); 
            b2 = b(mtlb_imp(1,mtlb_s(na,1)),mtlb_imp(mtlb_a(nb1,1),mtlb_s(ns,na)));
            d1 = d(mtlb(mtlb(:)),mtlb_imp(1,mtlb_s(nb1,1)));
            d2 = d(mtlb(mtlb(:)),mtlb_imp(mtlb_a(nb1,1),mtlb_s(ns,na)));
        end;
        mc1 = mtlb_find(~(c(:,1)<%inf));
        if isempty(mc1) then
            c1 = c;  c2 = [];
            d11 = d1;  d12 = d2;  d21 = [];  d22 = [];
        else
            c1 = c(mtlb_imp(1,mtlb_s(mc1,1)),mtlb_imp(1,mtlb_s(na,1))); 
            c2 = c(mtlb_imp(mtlb_a(mc1,1),mtlb_s(ms,na)),mtlb_imp(1,mtlb_s(na,1)));
            if isempty(d1) then
                d11 = [];  d21 = [];
            else
                d11 = d1(mtlb_imp(1,mtlb_s(mc1,1)),mtlb(mtlb(:)));
                d21 = d1(mtlb_imp(mtlb_a(mc1,1),mtlb_s(ms,na)),mtlb(mtlb(:)));
            end;
            if isempty(d2) then
                d12 = [];  d22 = [];
            else
                d12 = d2(mtlb_imp(1,mtlb_s(mc1,1)),mtlb(mtlb(:)));
                d22 = d2(mtlb_imp(mtlb_a(mc1,1),mtlb_s(ms,na)),mtlb(mtlb(:)));
            end;
        end;
    end;
    err = 0;
    if %nargout==1 then
        if max(size(flag))==1 then
            if mtlb_logic(flag,"==","b") then
                a = b;
            else
                if mtlb_logic(flag,"==","c") then
                    a = c;
                else
                    if mtlb_logic(flag,"==","d") then
                        a = d;
                    else
                        if mtlb_logic(flag,"==","e") then
                            a = d;
                        else
                            if mtlb_logic(flag,"<>","a") then
                                err = 1;
                            end;
                        end;
                    end;
                end;
            end;
        else
            if max(size(flag))==2 then
                if mtlb_logic(flag,"==","b1") then
                    //#ok<*STCMP>
                    a = b1;
                else
                    if mtlb_logic(flag,"==","b2") then
                        a = b2;
                    else
                        if mtlb_logic(flag,"==","c1") then
                            a = c1;
                        else
                            if mtlb_logic(flag,"==","c2") then
                                a = c2;
                            else
                                err = 1;
                            end;
                        end;
                    end;
                end;
            else
                if max(size(flag))==3 then
                    if mtlb_logic(flag,"==","d11") then
                        a = d11;
                    else
                        if mtlb_logic(flag,"==","d12") then
                            a = d12;
                        else
                            if mtlb_logic(flag,"==","d21") then
                                a = d21;
                            else
                                if mtlb_logic(flag,"==","d22") then
                                    a = d22;
                                else
                                    err = 1;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        if err then
            error("Improper choice for FLAG")
        end;
    else
        if %nargout==4 then
            b1 = [b1,b2];  b2 = [c1;c2];  c1 = [d11,d12;d21,d22];
        else
            if %nargout<>9 then
                disp("Warning: Not the proper number of output arguments for UNPACK_SS");
            end;
        end;
    end;
endfunction
