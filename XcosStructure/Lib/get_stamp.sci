// Get time stamp of a file path; return 0 if non-existant; return current time if
// no input file_name.
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
function [time_stamp, time_str] = get_stamp(file_name)

    if argn(2)<1 then
        file_name = '';
    end

    // Output variables initialisation (not found in input variables)
    time_stamp=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // function timeStamp = geStStamp(fp)
    // Get time stamp of a file path; return 0 if non-existant
    if isempty(file_name) then
        dfp = '';
    else
        dfp = dir(file_name);
    end

    if isempty(file_name) then
        time_stamp_raw = getdate();
    elseif isempty(dfp)
        time_stamp_raw = [];
    else
        time_stamp_raw = getdate(dfp.date);
    end

    if isempty(time_stamp_raw) then
        time_stamp = 0;
        time_str = '';
    else
        Years = time_stamp_raw(1);
        Months = time_stamp_raw(2);
        Days = time_stamp_raw(6);
        Hours = time_stamp_raw(7);
        Minutes = time_stamp_raw(8);
        Seconds = time_stamp_raw(9);
        time_stamp = datenum(Years,Months,Days,Hours,Minutes,Seconds);
        time_str = msprintf('%4d%02d%02d_%02d%02d%02d', Years, Months, Days, Hours, Minutes, Seconds);
    end

endfunction
