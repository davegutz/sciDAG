% Copyright (C) 2018 - Dave Gutz
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
% Sep 3, 2018 	DA Gutz		Created
% 
% Check for correct number of input arguments.
%
% Generate an error message if the number of arguments in the calling function
% is outside the range @var{minargs} and @var{maxargs}.  Otherwise, do
% nothing.
%
% Both @var{minargs} and @var{maxargs} must be scalar numeric values.  Zero,
% Inf, and negative values are all allowed, and @var{minargs} and
% @var{maxargs} may be equal.

function narginchk(narginx, minargs, maxargs)

if(nargin ~= 3)
    error('narginchk:  must have 3 arguments (nargin, minargs, maxargs)')
elseif (~ isnumeric (minargs) || ~ isscalar (minargs))
    error('narginchk: MINARGS must be a numeric scalar');
elseif (~ isnumeric (maxargs) || ~ isscalar (maxargs))
    error('narginchk: MAXARGS must be a numeric scalar');
elseif (minargs > maxargs)
    error('narginchk: MINARGS cannot be larger than MAXARGS');
end


if(narginx < minargs)
    error('narginchk: not enough input arguments');
elseif (narginx > maxargs)
    error('narginchk: too many input arguments');
end