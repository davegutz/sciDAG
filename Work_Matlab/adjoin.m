function so = adjoin(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15) %#ok<INUSD>
% ADJOIN	Form composite system interconnection.
%
% Syntax: So = ADJOIN(S1, ... Sn), or So = ADJOIN(S1, ... Sn-1, FLAG)
%
% Purpose:	The ADJOIN function forms a composite system from
%		the state-space realizations of distinct systems.
%		The different forms possible include
%
%			[ S1   0  ]  	              [  S1  ]
%			[    \    ],  [S1 --- Sn-1],  [   |  ]
%			[  0   Sn ]                   [ Sn-1 ]
%
%		where the latter two are horizontally and vertically
%		adjoined systems, obtained with FLAG = 'h', or FLAG = 'v'
%		respectively.
%
% Input:	S1 ,... Sn  - Input systems, in packed matrix form. Currently
%			      n is limited to a maximum of 15.
%		FLAG	- Optional string, either 'h' indicating the
%			horizontal adjoin operation, or 'v' for vertical.
%
% Output:	So	- the composite system, in packed matrix form.
%
% See Also:	ADD_SS, MULT_SS, SUB_SS, INV_SS

% Algorithm:
%
% Calls:	UNPACK_SS, PACK_SS
%
% Called By:

% SCCS information: %W% %G%


%**********************************************************************
narginchk(nargin, 2, 15);
%
s_f = eval(['s',int2str(nargin)]);
% if isstr(s_f)
if ischar(s_f)
    if s_f == 'v'			% Vertical stacking operation
        [ao,bo,co,eo] = unpack_ss(s1); [a1,b1,tmp,tmp1] = unpack_ss(s1);
        [tmp,p1,tmp1] = size_ss(s1);
        for i = 2:nargin-1
            si = eval(['s',int2str(i)]);
            [ai,bi,ci,ei] = unpack_ss(si); [mi,pi,ni] = size_ss(si);
            [mo,tmp1] = size(eo); [tmp,no] = size(ao);
            if pi ~= p1
                error('Incompatible dimensions for adjoin operation');
            end
            if no == ni
                if ( ~any(any(a1-ai)) && ~any(any(b1-bi)) )
                    co = [co; [ci zeros_ss(pi,no-ni)]];
                else
                    ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                    bo = [bo; bi];
                    co = [co zeros_ss(mo,ni); zeros_ss(mi,no) ci];
                end
            else
                ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                bo = [bo; bi];
                co = [co zeros_ss(mo,ni); zeros_ss(mi,no) ci];
            end
            eo = [eo; ei];
        end
    elseif s_f == 'h'			% Horizontal stacking operation
        [ao,bo,co,eo] = unpack_ss(s1); [a1,tmp,c1,tmp1] = unpack_ss(s1);
        [m1,tmp,tmp1] = size_ss(s1);
        for i = 2:nargin-1
            si = eval(['s',int2str(i)]);
            [ai,bi,ci,ei] = unpack_ss(si); [mi,pi,ni] = size_ss(si);
            [tmp,po] = size(eo); [tmp,no] = size(ao);
            if mi ~= m1
                error('Incompatible dimensions for adjoin operation');
            end
            if no == ni
                if ( ~any(any(a1-ai)) && ~any(any(c1-ci)) )
                    bo = [bo [bi; zeros_ss(no-ni,mi)]];
                else
                    ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                    bo = [bo zeros_ss(no,pi); zeros_ss(ni,po) bi];
                    co = [co ci];
                end
            else
                ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                bo = [bo zeros_ss(no,pi); zeros_ss(ni,po) bi];
                co = [co ci];
            end
            eo = [eo ei];
        end
    else
        errmsg = ['Unrecognized input argument: s',int2str(nargin), ...
            ' = " ', s_f, ' "'];
        error(errmsg);
    end
else
    [ao,bo,co,eo] = unpack_ss(s1);		% Block-diagonal adjoin
    for i = 2:nargin
        si = eval(['s',int2str(i)]);
        [ai,bi,ci,ei] = unpack_ss(si); [mi,pi,ni] = size_ss(si);
        [mo,po] = size(eo); [tmp,no] = size(ao);
        ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
        bo = [bo zeros_ss(no,pi); zeros_ss(ni,po) bi];
        co = [co zeros_ss(mo,ni); zeros_ss(mi,no) ci];
        eo = [eo zeros_ss(mo,pi); zeros_ss(mi,po) ei];
    end
end
so = pack_ss(ao,bo,co,eo);
%
