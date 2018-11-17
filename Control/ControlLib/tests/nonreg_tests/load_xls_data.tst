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
// Nov 8, 2018 	DA Gutz		Created
// 
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
clear
funcprot(0);
getd('../ControlLib')
mclose('all');

// Load some sample data, assuming data columnar
// Read data
[V_col, C_col, Mnames_col, Mvals_col] = load_xls_data('tests/nonreg_tests/load_xls_data.xls', 'col', 'col sheet')
V_col.v
V_col.vt
[V_row, C_row, Mnames_row, Mvals_row] = load_xls_data('tests/nonreg_tests/load_xls_data.xls', 'row', 'row sheet')
V_row.v
V_row.vt
[fdo, err] = mopen('tests/nonreg_tests/load_xls_data.csv', 'wt');
print_struct(V_col, 'V_col', fdo, ',');
print_struct(V_row, 'V_row', fdo, ',');
mclose(fdo);
mgetl('tests/nonreg_tests/load_xls_data.csv')
[fdo, err] = mopen('tests/nonreg_tests/load_xls_col_data.csv', 'wt');
print_struct(V_col, 'V', fdo, ',');
mclose(fdo);
[fdo, err] = mopen('tests/nonreg_tests/load_xls_row_data.csv', 'wt');
print_struct(V_row, 'V', fdo, ',');
mclose(fdo);
[flag, errmsg] = assert_checkfilesequal ( 'tests/nonreg_tests/load_xls_col_data.csv' , 'tests/nonreg_tests/load_xls_row_data.csv' );
if ~flag then
    error(errmsg)
end
// Check a real world case
[V_servo, C_servo, Mnames_servo, Mvals_servo] = load_xls_data('tests/nonreg_tests/allServo-PSO_input.xls', 'col');
[fdo, err] = mopen('tests/nonreg_tests/load_xls_real_data.csv', 'wt');
print_struct(V_servo, 'V_servo', fdo, ',');
mclose(fdo);
mgetl('tests/nonreg_tests/load_xls_real_data.csv')
