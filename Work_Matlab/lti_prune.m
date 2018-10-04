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

% Submodel extraction and reordering for LTI objects.
% This file is part of the Model Abstraction Layer.
% For internal use only.

% Author: Lukas Reichlin <lukas.reichlin@gmail.com>
% Created: September 2009
% Version: 0.2

function [lti, out_idx, in_idx] = lti_prune (lti, out_idx, in_idx)

//  if (ischar (out_idx) && ~strcmp (out_idx, ":"))  % sys("grp", :)
//    out_idx = {out_idx};
//  end
//  if (ischar (in_idx) && ~strcmp (in_idx, ":"))    % sys(:, "grp")
//    in_idx = {in_idx};
//  end
////
//  if (iscell (out_idx))                             % sys({"grp1", "grp2"}, :)
//    tmp = cellfun (@(x) str2idx (lti.outgroup, lti.outname, x, "out"), out_idx, "uniformoutput", false);
//    out_idx = vertcat (tmp{:});
//  end
//  if (iscell (in_idx))                              % sys(:, {"grp1", "grp2"})
//    tmp = cellfun (@(x) str2idx (lti.ingroup, lti.inname, x, "in"), in_idx, "uniformoutput", false);
//    in_idx = vertcat (tmp{:});
//  end
//
  if (nfields2 (lti.outgroup))
////    p = numel (lti.outname);                        % get size before pruning outnames!
//    [lti.outgroup, empty] = structfun (@(x) group_prune (x, out_idx, p), lti.outgroup, "uniformoutput", false);
////    [lti.outgroup, empty] = group_prune (x, out_idx, p), lti.outgroup, 'uniformoutput', %f);
////    empty = cell2mat (struct2cell (empty));
////    fields = fieldnames (lti.outgroup);
////    lti.outgroup = rmfield (lti.outgroup, fields(empty));
  end
  if (nfields2 (lti.ingroup))
////    m = numel (lti.inname); 
////    [lti.ingroup, empty] = group_prune (x, in_idx, m), lti.ingroup, 'uniformoutput', %f);
////    empty = cell2mat (struct2cell (empty));
////    fields = fieldnames (lti.ingroup);
////    lti.ingroup = rmfield (lti.ingroup, fields(empty));
  end
  
////  lti.outname = lti.outname(out_idx);
////  lti.inname = lti.inname(in_idx);
  
return
