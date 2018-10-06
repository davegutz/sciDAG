% Copyright (C) 2009-2016   Lukas F. Reichlin
%
% This file is part of LTI Syncope.
%
% LTI Syncope is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% LTI Syncope is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.
% Name-based or index-based interconnections between the inputs and outputs of 
% LTI models.
% 
% The properties 'inname' and 'outname'
% of each model should be set according to the desired input-output connections.
% For name-based interconnections, string or cell of strings containing the names
% of the inputs to be kept.  The names must be part of the properties 'ingroup' or
% 'inname'.  For index-based interconnections, vector containing the indices of the
% inputs to be kept.
% outputs
% For name-based interconnections, string or cell of strings containing the names
% of the outputs to be kept.  The names must be part of the properties 'outgroup' 
% or 'outname'.  For index-based interconnections, vector containing the indices of
% the outputs to be kept.
% cm
% Connection matrix (not name-based).  Each row of the matrix represents a summing
% junction.  The first column holds the indices of the inputs to be summed with
% outputs of the subsequent columns.  The output indices can be negative, if the output
% is to be substracted, or zero.  For example, the row
% [2 0 3 -4 0]
% or
% [2 -4 3]
% will sum input u(2) with outputs y(3) and y(4) as
% u(2) + y(3) - y(4).
%
% Resulting interconnected system with outputs and inputs.
%
% Author: Lukas Reichlin <lukas.reichlin@gmail.com>
% Created: October 2009
% October 2018  Dave Gutz   Port to scilab with pack_ss format of sys.
% Version: 0.4.1

function sys = connect_ss(varargin)

%  if (nargin < 2)
%    print_usage ();
%  endif
  
%  if (is_real_matrix (varargin{2}))     # connect (sys, cm, in_idx, out_idx)
  
    if (nargin ~= 4)
      print_usage ();
    endif
    
    sys = varargin{1};
    [a,b,c,d] = unpack_ss(sys);
    sys = ss(a,b,c,d);
    cm = varargin{2};
    in_idx = varargin{3};
    out_idx = varargin{4};
    
    [p, m] = size (sys);
    [cmrows, cmcols] = size (cm);

    M = zeros (m, p);
    in = cm(:, 1);
    out = cm(:, 2:cmcols);
    
    % check sizes and integer values
    if (~ isequal (cm, floor (cm)))
      error ('connect: matrix ''cm'' must contain integer values (index-based interconnection)');
    endif
    
    if ((min (in) <= 0) || (max (in) > m))
      error ('connect: ''cm'' input index in out of range (index-based interconnection)');
    endif
    
    if (max (abs (out(:))) > p)
      error ('connect: ''cm'' output index out of range (index-based interconnection)');
    endif
    
    if ((~ is_real_vector (in_idx)) || (~ isequal (in_idx, floor (in_idx))))
      error ('connect: ''inputs'' must be a vector of integer values (index-based interconnection)');
    endif
    
    if ((max (in_idx) > m) || (min (in_idx) <= 0))
      error ('connect: index in vector ''inputs'' out of range (index-based interconnection)');
    endif
    
    if ((~ is_real_vector (out_idx)) || (~ isequal (out_idx, floor (out_idx))))
      error ('connect: ''outputs'' must be a vector of integer values (index-based interconnection)');
    endif
    
    if ((max (out_idx) > p) || (min (out_idx) <= 0))
      error ('connect: index in vector ''outputs'' out of range (index-based interconnection)');
    endif
    
    for a = 1 : cmrows
      out_tmp = out(a, (out(a,:) ~= 0));
      if (~ isempty (out_tmp))
        M(in(a,1), abs (out_tmp)) = sign (out_tmp);
      endif
    endfor

    disp('before sys_connect')
    disp('a');disp(sys.a);disp('b');disp(sys.b);disp('c');disp(sys.c);disp('d');disp(sys.d);
    disp('out_idx'); disp(out_idx); disp('in_idx'); disp(in_idx);disp('M');disp(M);
    sys = sys_connect (sys, M);
    disp('before __sys_prune__')
    disp('a');disp(sys.a);disp('b');disp(sys.b);disp('c');disp(sys.c);disp('d');disp(sys.d);
    disp('out_idx'); disp(out_idx); disp('in_idx'); disp(in_idx);
    sys = __sys_prune__ (sys, out_idx, in_idx);
    disp('after')
    disp('a');disp(sys.a);disp('b');disp(sys.b);disp('c');disp(sys.c);disp('d');disp(sys.d);

%  else                                  # connect (sys1, sys2, ..., sysN, in_idx, out_idx)
%
%    lti_idx = cellfun (@isa, varargin, {"lti"});
%    sys = blkdiag (varargin{lti_idx});
%    io_idx = ~lti_idx;
%    
%    if (nnz (io_idx) == 2)
%      in_idx = varargin(io_idx){1};
%      out_idx = varargin(io_idx){2};      
%    else
%      in_idx = ":";
%      out_idx = ":";
%    endif
%
%    inname = sys.inname;
%    if (any (cellfun (@isempty, inname)))
%      error ('connect: all inputs must have names');
%    endif
%
%    outname = sys.outname;
%    if (any (cellfun (@isempty , outname)))
%      error ('connect: all outputs must have names');
%    endif
%    
%    ioname = intersect (inname, outname);
%    
%    tmp = cellfun (@(x) find (strcmp (inname, x)(:)), ioname, "uniformoutput", false);
%    inputs = vertcat (tmp{:});  # there could be more than one input with the same name
%    
%    [p, m] = size (sys);
%    M = zeros (m, p);
%    for k = 1 : length (inputs)
%      outputs = strcmp (outname, inname(inputs(k)));
%      M(inputs(k), :) = outputs;
%    endfor
%
%    sys = sys_connect (sys, M);
%
%    % sys_prune will error out if names in out_idx and in_idx are not unique
%    % the dark side handles cases with common in_idx names - so do we
%
%    inname_u = unique (inname);
%    if (numel (inname_u) ~= numel (inname))
%      tmp = cellfun (@(u) strcmp (u, inname), inname_u, "uniformoutput", false);
%      mat = double (horzcat (tmp{:}));
%      scl = ss (mat, "inname", inname_u, "outname", inname);
%      sys = sys * scl;
%      if (is_real_vector (in_idx))
%        warning ("connect: use names instead of indices for argument ''inputs''");
%      endif
%    endif
%
%    sys = sys_prune (sys, out_idx, in_idx);
%
%    if (isa (sys, "ss"))
%      sys = sminreal (sys);
%    endif
%
%  endif

endfunction
