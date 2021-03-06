// Copyright (C) 2019 - Dave Gutz
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
// Jsn 1, 2019      DA Gutz     Created
// 
global LINCOS_OVERRIDE figs LIN time_tic time_toc
global GEO INI FP mv_x mv_xa mv_xin Tf
mprintf('In %s\n', sfilename())  
try close(figs); end
LINCOS_OVERRIDE = 0;

GEO.ln_vs = lti_man_n_vm(GEO.ln_vs, FP.sg, FP.beta);
GEO.ln_p3s = lti_man_n_vm(GEO.ln_p3s, FP.sg, FP.beta);
GEO.main_line = lti_man_n_mm(GEO.main_line, FP.sg, FP.beta);

if ~INI.batch then
    if INI.initialized & INI.skip_init then
        btn = messagebox('Reinitialization needed?', 'Query Re-Init', 'question', ['yes', 'no'], 'modal');
        mprintf("Skipping init\n");
        if btn~=1 then
            mprintf('running...\n');
            time_tic = getdate();
            return;
        end
    end
else
    if INI.initialized then
        mprintf("Skipping init\n");
        time_tic = getdate();
        return;
    end
end

// Inputs
INI.wf36 = 107.08;
INI.ps3 = 15;

// Boundary conditions TODO:  need better logic
INI.wf1bias = 673.32808;
INI.ven_ps = 73.595;
INI.ven_pd = 1451.2;
INI.pamb = 14.696;
INI.pr = 198.59;

// Initialize
exec('./Callbacks/Solve_start04alone.sce', -1);
exec('./Callbacks/mvwin_b.sci', -1);
[xb, ab] = mvwin_b(40);
exec('./Callbacks/mvwin_a.sci', -1);
[xa, aa] = mvwin_a(40);
if isempty(mv_xa), mv_xa = mv_x.values(:,1); end
mv_aa = interp1(xa, aa, mv_xa, 'linear', aa(1));
mv_xb = interp1(ab, xb, mv_aa);
mv_x.values(:,1) = mv_xb;
x0 = mv_x.values(1,1);
xE = mv_x.values($,1);
mv_xin = struct('time', [0 0.00099 .00100 Tf]', 'values', [x0 x0 xE xE]');
//mv_x.values(:,1) = mv_xb*0+mv_xb(1);
INI.ln_vs = ini_man_n_vm(GEO.ln_vs, INI.p1so, INI.wf1v);
INI.ln_p3s = ini_man_n_vm(GEO.ln_p3s, INI.p3s, 0);
INI.main_line = ini_man_n_mm(GEO.main_line, INI.p3, INI.wf3);
mprintf('mv_x=%8.6f-%8.6f\n', mv_x.values(1,1), mv_x.values($,1));
INI.initialized = %t;
time_tic = getdate();

// placeholder for VEN Unit stuff
INI.xnven = vdpp_rpm.values(1,1);
INI.xn25 = xn25.values(1,1);
INI.disp = vdpp_disp.values(1,1);
INI.pdven = tri_ps.values(1,1);
INI.psven = tri_pd.values(1,1);
INI.pact.x = pact_x.values(1,1);
INI.reg.x = tri_x.values(1,1);
INI.pxven = tri_px.values(1,1);
INI.rrv.x = rrv_x.values(1,1);
INI.bias.x = bias_x.values(1,1);

// Cleanup
INI = order_all_fields(INI);

mprintf('Completed %s\n', sfilename())  
