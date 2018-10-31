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
// Aug 25, 2018 	DA Gutz		Created
// 

// Run all tests
test_run(pwd())

// Example of reading xls input data files
test_run(pwd(), 'read_xls_row_data')

// Example of writing csv input data files
test_run(pwd(), 'write_csv_row_data')

// Example of rotating csv file
test_run(pwd(), 'rotate_file')

// Example of sorting structures
test_run(pwd(), 'order_all_fields')

// Example of reading and writing structures to file
test_run(pwd(), 'print_struct')

// Example of pade lti
test_run(pwd(), 'pade')

// Example of step response performance
test_run(pwd(), 'myStepPerf')

// Example of string tokenizer
test_run(pwd(), 'tokeninze')
test_run(pwd(), 'untokeninze')
