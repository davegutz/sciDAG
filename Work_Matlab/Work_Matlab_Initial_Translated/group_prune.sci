function [group,empty] = group_prune(group,idx,n)

// Output variables initialisation (not found in input variables)
empty=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// Copyright (C) 2009-2016   Lukas F. Reichlin
// 
// This file is part of LTI Syncope.
// 
// LTI Syncope is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// LTI Syncope is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.
// 
// Submodel extraction and reordering for LTI objects.
// Author: Lukas Reichlin <lukas.reichlin@gmail.com>
// Created: September 2009
// Version: 0.2

lg = max(size(group));
%v0$2 = 1:lg;group = sparse([group(:),%v0$2(:)],1,[n,lg]);
// ! L.26: mtlb(:) can be replaced by :() or : whether : is an M-file or not.
// ! L.26: mtlb(:) can be replaced by :() or : whether : is an M-file or not.
// !! L.26: Unknown function mtlb not converted, original calling sequence used.
group = group(idx,mtlb(mtlb(:)));
// ! L.27: abs(group) may be replaced by:
// !    --> group if group is Real.
[group,temp] = mtlb_find(abs(group));
empty = isempty(group);
// ! L.29: mtlb(resume) can be replaced by resume() or resume whether resume is an M-file or not.
mtlb(resume)
endfunction
