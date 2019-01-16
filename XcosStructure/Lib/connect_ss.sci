// Copyright(C) 2009-2016   Lukas F. Reichlin
//
// This file is part of LTI Syncope.
//
// LTI Syncope is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
// LTI Syncope is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.
//
// 
// The properties 'inname' and 'outname'
// of each model should be set according to the desired input-output connections.
// For name-based interconnections, string or cell of strings containing the names
// of the inputs to be kept.  The names must be part of the properties 'ingroup' or
// 'inname'.  For index-based interconnections, vector containing the indices of the
// inputs to be kept.
// outputs
// For name-based interconnections, string or cell of strings containing the names
// of the outputs to be kept.  The names must be part of the properties 'outgroup' 
// or 'outname'.  For index-based interconnections, vector containing the indices of
// the outputs to be kept.
// cm
// Connection matrix(not name-based).  Each row of the matrix represents a summing
// junction.  The first column holds the indices of the inputs to be summed with
// outputs of the subsequent columns.  The output indices can be negative, if the output
// is to be substracted, or zero.  For example, the row
// [2 0 3 -4 0]
// or
// [2 -4 3]
// will sum input u(2) with outputs y(3) and y(4) as
// u(2) + y(3) - y(4).
//
// Resulting interconnected system with outputs and inputs.
//
// Author: Lukas Reichlin <lukas.reichlin@gmail.com>
// Created: September 2009
// October 2019  Dave Gutz  Add unpack_ss option.
// Version: 0.3.1
// Copyright(C) 2018 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
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
// Oct 4, 2018  DA Gutz Created
function [sys] = connect_ss(varargin)
    // Number of arguments in function call
    [%nargout, %nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    if %nargin ~= 4
        print_usage();
    end
    
    sys = varargin(1);
    [a, b, c, d] = unpack_ss(sys);
    sys = syslin('c', a, b, c, d);
    cm = varargin(2);
    in_idx = varargin(3);
    out_idx = varargin(4);
    
    [p, m] = size(sys);
    [cmrows, cmcols] = size(cm);

    M = zeros(m, p);
    in = cm(:, 1);
    out = cm(:, 2:cmcols);
    // check sizes and integer values
    if(~ isequal(cm, floor(cm)))
      error('connect: matrix ''cm'' must contain integer values(index-based interconnection)');
    end
    
    if((min(in) <= 0) | (max(in) > m))
      error('connect: ''cm'' input index in out of range(index-based interconnection)');
    end
    
    if(max(abs(out(:))) > p)
      error('connect: ''cm'' output index out of range(index-based interconnection)');
    end
    
    if((~is_real_vector(in_idx)) | (~isequal(in_idx, floor(in_idx))))
      error('connect: ''inputs'' must be a vector of integer values(index-based interconnection)');
    end
    
    if((max(in_idx) > m) | (min(in_idx) <= 0))
      error('connect: index in vector ''inputs'' out of range(index-based interconnection)');
    end
    
    if((~is_real_vector(out_idx)) | (~ isequal(out_idx, floor(out_idx))))
      error('connect: ''outputs'' must be a vector of integer values(index-based interconnection)');
    end
    
    if((max(out_idx) > p) | (min(out_idx) <= 0))
      error('connect: index in vector ''outputs'' out of range(index-based interconnection)');
    end
    
    // Perform
    for a = 1:cmrows
      out_tmp = out(a,(out(a,:)~= 0));
      if(~isempty(out_tmp))
        M(in(a,1), abs(out_tmp)) = sign(out_tmp);
      end
    end
    sys = sys_connect(sys, M);
    sys = sys_prune(sys, out_idx, in_idx);
    
endfunction
