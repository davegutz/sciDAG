function [] = narginchk(narginx,minargs,maxargs)

// Number of arguments in function call
[%nargout,%nargin] = argn(0)

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// Copyright (C) 2018 - Dave Gutz
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the """"Software""""), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED """"AS IS"""", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Sep 3, 2018 DA GutzCreated
// 
// Check for correct number of input arguments.
// 
// Generate an error message if the number of arguments in the calling function
// is outside the range @var(minargs).entries and @var(maxargs).entries.  Otherwise, do
// nothing.
// 
// Both @var(minargs).entries and @var(maxargs).entries must be scalar numeric values.  Zero,
// Inf, and negative values are all allowed, and @var(minargs).entries and
// @var(maxargs).entries may be equal.


if %nargin<>3 then
  error("narginchk:  must have 3 arguments (nargin, minargs, maxargs)")
else
  %v03 = %t;  if ~~or(type(minargs)==[1,5,8]) then %v03 = ~sum(length(minargs))==1;end;
  if %v03 then
    error("narginchk: MINARGS must be a numeric scalar");
  else
    %v14 = %t;  if ~~or(type(maxargs)==[1,5,8]) then %v14 = ~sum(length(maxargs))==1;end;
    if %v14 then
      error("narginchk: MAXARGS must be a numeric scalar");
    else
      if mtlb_logic(minargs,">",maxargs) then
        error("narginchk: MINARGS cannot be larger than MAXARGS");
      end;
    end;
  end;
end;


if mtlb_logic(narginx,"<",minargs) then
  error("narginchk: not enough input arguments");
else
  if mtlb_logic(narginx,">",maxargs) then
    error("narginchk: too many input arguments");
  end;
end;
endfunction
