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
// Return true if all arguments are real-valued vectors and false
// otherwise.  [] is not a valid vector.  Avoid nasty stuff like 'true
//    = isreal ("a")'
//// Examples:
// is_real_vector(6)            ==> 1
// is_real_vector([])           ==> 0
// is_real_vector([1 2; 3 4])   ==> 0
// is_real_vector([1 2 3])      ==> 1
// is_real_vector([%i 2 3])      ==> 0
// is_real_vector("hello")      ==> 0
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
function y = is_real_vector(v)
  if (~(size(v,1)==1 | size(v,2)==1))
    y = %f;
  else
    y = %t;
    for i = 1:max(size(v))
      if (~(isnumeric(v(i)) && isscalar(v(i)) && isreal(v(i))))
        y = %f;
      end
    end
  end
endfunction
