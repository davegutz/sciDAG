function [a,b1,b2,c1,c2,d11,d12,d21,d22] = unpack_ss(sys,flag)
% UNPACK_SS	Unpacks a system into component matrices.
%
% Syntax: [A,B1,B2,C1,C2,D11,D12,D21,D22] = UNPACK_SS(SYS), or ...
%         [A,B,C,D] = UNPACK_SS(SYS) or ...
%         X = UNPACK_SS(SYS,FLAG)
%
% Purpose:	The first version 'unpacks' the nine constituent matrices
%		of a TITO state-space representation.
%               
%		The second version 'unpacks' the four constituent matrices 
%		of a SISO state-space representation.
%
%		The third version allows selection of only a single
%		element from the SISO state-space quartet or from the
%		TITO nantet.
%
% Input:	SYS - Input system, in packed matrix format.
%		FLAG - Optional character used to select only a single
%		       matrix or section for unpacking.  Hence FLAG 
%		       may be either 'a', 'b', 'c', 'd', 'b1', 'b2', 
%		       'c1', 'c2', 'd11', 'd12', 'd21', or 'd22', in
%		       which case the corresponding matrix is unpacked
%		       from SYS.
%
% Output:	A, B1, B2, C1, C2, D11, D12, D21, D22  or ...
%		A, B, C, D 
%			- Regular matrices unpacked from SYS.
%
% See Also:	PACK_SS


%**********************************************************************


%
% Check Arguments
% 
narginchk(nargin, 1, 2);
%
if nargin == 1 && nargout == 1,
  error('Must specify FLAG when unpacking a single matrix')
end
%
%**********************************************************************

% 
% Calculations
%
[ms,ns] = size(sys);
na = find(all(isnan(sys)));
%
% if there are no NaN's we have the static system case
%
if isempty(na),
  a = []; b1 = []; b2 = []; c1 = []; c2 = [];
  d = sys;
  ne = find(all(~isfinite(sys)));	
  if isempty(ne),
    d11 = sys;
    d12 = []; d21 = []; d22 = [];
  else
    me = find(all(~isfinite(sys')));
    d11 = sys(1:me-1,1:ne-1);
    d12 = sys(1:me-1,ne+1:ns);
    d21 = sys(me+1:ms,1:ne-1);
    d22 = sys(me+1:ms,ne+1:ns);
  end
%
% if there are NaN's we have either the static or dynamic case
%
else
  %
  % Unpack A, B, C, and E sections first
  %
  a = sys(1:na-1,1:na-1); b = sys(1:na-1,na+1:ns); 
  c = sys(na+1:ms,1:na-1); d = sys(na+1:ms,na+1:ns);
  % 
  % Now get B1, B2, C1, C2, D11, D12, D21, and D22
  %
  nb1 = find(~isfinite(b(1,:)));
  if isempty(nb1),
    b1 = b; b2 = []; d1 = d; d2 = [];
  else
    b1 = b(1:na-1,1:nb1-1); b2 = b(1:na-1,nb1+1:ns-na);
    d1 = d(:,1:nb1-1); d2 = d(:,nb1+1:ns-na);
  end
  mc1 = find(~isfinite(c(:,1)));
  if isempty(mc1),
    c1 = c; c2 = [];
    d11 = d1; d12 = d2; d21 = []; d22 = [];
  else
    c1 = c(1:mc1-1,1:na-1); c2 = c(mc1+1:ms-na,1:na-1);
    if isempty(d1),
      d11 = []; d21 = [];
    else
      d11 = d1(1:mc1-1,:); d21 = d1(mc1+1:ms-na,:);
    end
    if isempty(d2),
      d12 = []; d22 = [];
    else
    d12 = d2(1:mc1-1,:); d22 = d2(mc1+1:ms-na,:);
    end
  end
end
err = 0;
if nargout == 1,
  if length(flag) == 1,
    if flag == 'b',
      a = b;
    elseif flag == 'c',
      a = c;
    elseif flag == 'd',
      a = d;
    elseif flag == 'e',
      a = d;
    elseif flag ~= 'a',
      err = 1;
    end
  elseif length(flag) == 2,
    if flag == 'b1', %#ok<*STCMP>
      a = b1;
    elseif flag == 'b2',
      a = b2;
    elseif flag == 'c1',
      a = c1;
    elseif flag == 'c2',
      a = c2;
    else
      err = 1;
    end
  elseif length(flag) == 3,
    if flag == 'd11',
      a = d11;
    elseif flag == 'd12',
      a = d12;
    elseif flag == 'd21',
      a = d21;
    elseif flag == 'd22',
      a = d22;
    else
      err = 1;
    end
  end
  if err,
    error('Improper choice for FLAG')
  end
elseif nargout == 4,
  b1 = [b1 b2]; b2 = [c1;c2]; c1 = [d11 d12;d21 d22];
elseif nargout ~= 9,
  disp('Warning: Not the proper number of output arguments for UNPACK_SS');
end
