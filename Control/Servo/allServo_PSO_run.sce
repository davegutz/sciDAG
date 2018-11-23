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
// Oct 18, 2018 	DA Gutz		Created
// 
clear
funcprot(0);
getd('../ControlLib')
exec('myServo.sci', -1)
n_fig = -1;
xdel(winsid())
mclose('all');

// Setup comparison plots
n_fig = n_fig + 1;
n_fig_step_compare = n_fig;
n_fig = n_fig + 1;
n_fig_bode_compare = n_fig;


// Global for debug
global verbose
// Globals for solver PSO.allServo_PSO_Obj
global G C W P X
verbose = 0;
global PSO

// Filenames
this = 'allServo_PSO';
input_file = './' + this + '_input.xls';
save_file = 'saves/' + this + '_run.csv';
perf_file = 'Objectives/' + this + '_perf.sci';
lti_file = 'Objectives/' + this + '_lti.sci';
outputfun_file = 'Objectives/' + this  + '_Outputfun.sci';
outputfun_str = this + '_Outputfun';
obj_function_default = this + '_Obj';
exec(perf_file);
exec(lti_file);
exec(outputfun_file);

// Parameters.   Values in parenthesis are typical.
// These all MUST appear in input_file.
// Other items in allServo_PSO_input.xls may be results copied from save_file.
// System parameters
//  G.tehsv1    Plant driver lag, s  (0.007)
//  G.tehsv2    Plant hydraulic lag, s (0.010)
//  G.gain      Plant gain, %/s/mA  (1 - use C.gain as loopgain)
// Control parameters
//  C.dT            Update time, s (0.010)
//  C.tld1/C.tlg1   Forward path lead/lag #1, s
//  C.tld2/C.tlg2   Forward path lead/lag #2, s
//  C.tldh/C.tlgh   Feedback path lead/lag, s
//  C.gain          Control gain, mA/% (30 loopgain)
// Typical averages ('mu') guidelines for PSO
//  MU.gm           Gain margin, dB (9)
//  MU.pm           Phase margin, deg (55)
//  MU.pwr          Phase crossover, r/s (30)
//  MU.tr           Rise time, s (0.05)
//  MU.Mp           Maximum peak overshoot, fraction (0.05)
//  MU.Mu           Maximum undershoot after peak, fraction (0.05)
//  MU.ts           Settle time, s (0.2)
//  MU.sum          Sum used for weighting
//  MU.invgain      Inverse loopgain, r/s (1/30)
// Final weights that were calculated in PSO objective.   See MU for units.
//  W.tr
//  W.Mp
//  W.ts
//  W.invgain
// Requirements
//  R.gm
//  R.pm
//  R.pwr
//  R.rise          Threshold for unit step response rise, fraction (0.95)
//  R.settle        Threshold for unit step response settling, fraction (0.02)
//  R.invgain       Target loopgain, sec (1/30)
//  R.tr ', 0.07, 
//  R.Mp', 0.10, 
//  R.Mu', 0.05, 
//  R.ts', 0.2,..
//  R.obj_function', 'allServo_PSO_Obj');
// Cost weights
//  WC.tr', 1, 
//  WC.Mp', 1, 
//  WC.Mu', 1, '
//  WC.ts', 0.2, 
//  WC.sum', 0. , 
//  WC.invgain', 2);
//PSO    = struct('wmax',     0.9,..      // initial weight parameter
//  PSO.wmin',     0.4,..      // final weight parameter)
//  PSO.itmax',    5,..        // maximum iteration number
//  PSO.c1',       0.7,..      // knowledge factors for personnal best
//  PSO.c2',       1.47,..     // knowledge factors for global best
//  PSO.N',        50,..       // problem dimensions: number of particles
//  PSO.D',        7,..        // problem in R^2
//  PSO.launchp',  0.9,..      // launch probability, default = 0.9 (?)
//  PSO.speedf',   2*ones(1,7),..// X.speed factor, default = 2*D
//..// Bounds for hunting around C
//  PSO.boundsmax',[50; 0.250; 0.025; 0.250; 0.025; 0.250; 0.250],..
//  PSO.boundsmin',[25; 0.000; 0.008; 0.000; 0.008; 0.000; 0.125]);
// Performance results
//  P.case_title',   '',..       // Case title for plots etc
//  P.case_date_str','',..       // Date stamp
//  P.f_min_s',      %nan,..     // scalar on min of frequency range
//  P.f_max_s',      %nan,..     // scalar on max of frequency range
//  P.save_file_name', '',..     // Saved binary information file name
//  P.f_min',        %nan,..     // Used frequency lower limit, Hz
//  P.f_max',        %nan,..     // Used frequency upper limit, Hz
//  P.sys_cl',       %nan,..     // lti closed looop
//  P.sys_ol',       %nan,..     // lti open looop
//  P.gm',           %nan,..     // Resulting gain margin, dB
//  P.pm',           %nan,..     // Resulting phase margin, deg
//  P.gwr',          %nan,..     // Resulting gain crossover, rad/s 
//  P.pwr',          %nan,..     // Resulting phase crossover, rad/s 
//  P.ts',           %nan,..     // Resulting settle time, s
//  P.Mu',           %nan,..     // Resulting magnitude undershoot, %
//  P.tu',           %nan,..     // Resulting time at undershoot, s
//  P.Mp',           %nan,..     // Resulting magnitude overshoot, %
//  P.tp',           %nan,..     // Resulting time at overshoot, s
//  P.tr',           %nan,..     // Resulting rise time, s
//  P.casestr_i',    '',..       // Resulting initial result
//  P.casestr_f',    '');        // Resulting final result
mkdir('./saves');
[fdo, err] = mopen(save_file, 'wt');
if err<0 then
    msg = msprintf('%s---> is csv output file still open in excel/oo?', save_file)
    error(msg)
end
[V, Comments, Mnames, Mvals] = load_xls_data(input_file, 'col');
[n_cases, m_V] = size(V);
[n_comments, m_comments] = size(Comments);
for i_comment = 1:n_comments
    mfprintf(fdo, '%s\n', Comments(i_comment))
end
dt_plot = 0.01;
t_step_compare = 0:dt_plot:2;
X.t_step = t_step_compare;

// The Loop
composite_lti_bode_compare = [];
legend_bode_compare = [];
for case_num=1:n_cases

    G = V(case_num).G;
    C = V(case_num).C;
    WC = V(case_num).WC;
    P = V(case_num).P;
    R = V(case_num).R;
    PSO = V(case_num).PSO;
    MU = V(case_num).MU;
    verbose = V(case_num).verbose;
    active = V(case_num).active;
    PSO.weights = [PSO.wmax; PSO.wmin];
    PSO.c = [PSO.c1; PSO.c2];
    X.D = PSO.D;

    ierr = execstr(['obj_function = R.obj_function;'], 'errcatch');
    if ierr then
        obj_function = obj_function_default;
    end
    obj_function_file = 'Objectives/' + obj_function + '.sci';
    exec(obj_function_file, -1);

    // File saving
    P.save_file_name = 'saves/' + this + '_' + P.case_title + '.dat';

    // Frequency range
    X.f_min = 1/2/%pi*P.f_min_s;
    X.f_max = 1/C.dT*P.f_max_s;

    WC.sum = WC.tr + WC.Mp + WC.Mu + WC.ts + WC.invgain;
    WC.tr = WC.tr/WC.sum;
    WC.Mp = WC.Mp/WC.sum;
    WC.Mu = WC.Mu/WC.sum;
    WC.ts = WC.ts/WC.sum;
    WC.invgain = WC.invgain/WC.sum;

    MU.sum = 1/MU.tr + 1/MU.Mp + 1/MU.Mu + 1/MU.ts + 1/MU.invgain;
    W.tr = WC.tr/(MU.tr*MU.sum);
    W.Mp = WC.Mp/(MU.Mp*MU.sum);
    W.Mu = WC.Mu/(MU.Mu*MU.sum);
    W.ts = WC.ts/(MU.ts*MU.sum);
    W.invgain = WC.invgain/(MU.invgain*MU.sum);


    mprintf('\n\n****************Case %d of %d:\n', case_num, n_cases);
    f1 = evstr(obj_function + '([C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh]);');
    P.casestr_i = msprintf('Init    %5.2f*(%5.4f/%5.4f)*(%5.4f/%5.4f)*(%5.4f/%5.4f): %5.2f/%5.1f',..
    C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, P.gm, P.pm);
    evstr(outputfun_str + '(0, f1, [C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh])');
    C.raw_i = C.raw;
    mprintf('%5.2f*(%5.4f/%5.4f)*(%5.4f/%5.4f)*(%5.4f/%5.4f):  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
    C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, P.gm, P.gwr, P.pm, P.pwr)
    mprintf('tr=%5.3f s Mp100=%6.3f  Mu100=%6.3f  ts=%5.3f s\n',..
    P.tr, P.Mp*100, P.Mu*100, P.ts);
//    disp(P.casestr_i)
    n_fig = n_fig+1;
    n_fig_step = n_fig;
    scf(n_fig_step); clf(); 
    plot(X.t_step, X.y_step, 'k')
    xgrid(0);
    y_step_init = X.y_step;
    sys_ol_i = X.sys_ol;


    // PSO inputs
    PSO.x0 = [C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh];
    speed_max = 0.1*PSO.boundsmax;
    speed_min = 0.1*PSO.boundsmin;
    X.speed = [speed_min, speed_max];
    grand('setsd', 0); // must initialize random generator.  Want same result on repeated runs.

    // Particle Swarm algorithm
    if PSO.verbose>0 then
        n_fig = n_fig+1;
        figure(n_fig);
        scf(n_fig);
    end
    if active then
        PSO.iters = 0;
        [P.fopt, P.xopt]=PSO_bsg_starcraft(evstr(obj_function), ..
            [PSO.boundsmin, PSO.boundsmax],..
            X.speed, PSO.itmax, PSO.N,..
            PSO.weights, PSO.c, PSO.launchp, PSO.speedf,..
            PSO.N, allServo_PSO_Outputfun, PSO.x0);
        PSO.iters = PSO.iters + 1;
        evstr(outputfun_str + '(PSO.iters, P.fopt, P.xopt)');
        [dummy, P.case_date_str] = get_stamp(); 
    else
        P.case_date_str = '';
    end
    P.casestr_f = msprintf('Final %4.1f*(%5.4f/%5.4f)*(%5.4f/%5.4f)*(%5.4f/%5.4f): %4.1f/%4.0f',..
        C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, P.gm, P.pm);
    mprintf('%5.2f*(%5.4f/%5.4f)*(%5.4f/%5.4f)*(%5.4f/%5.4f):  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, P.gm, P.gwr, P.pm, P.pwr);
    mprintf('tr=%5.3f s Mp100=%6.3f  Mu100=%6.3f  ts=%5.3f s\n',..
        P.tr, P.Mp*100, P.Mu*100, P.ts);
    disp(P.casestr_f)
    mprintf('gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        P.gm, P.gwr, P.pm, P.pwr)


    // plots
    scf(n_fig_step);
    plot(X.t_step, X.y_step, 'b')
    title(P.case_title,"fontsize",3);
    xlabel("t, sec","fontsize",4);
    ylabel("$y$","fontsize",4);
    legend([P.casestr_i, P.casestr_f]);
    
    scf(n_fig_step_compare); clf();
    y_step_compare($+1,:) = X.y_step;
    plot(t_step_compare', y_step_compare')
    title(this,"fontsize",3);
    xlabel("t, sec","fontsize",4);
    ylabel("$y$","fontsize",4);
    step_compare_legend($+1) = P.case_title;
    legend(step_compare_legend);

    n_fig = n_fig+1;
    n_fig_bode = n_fig;
    scf(n_fig_bode); clf();
    bode([sys_ol_i; X.sys_ol], X.f_min, X.f_max, [P.casestr_i, P.casestr_f], 'rad')

    scf(n_fig_bode_compare); clf();
    composite_lti_bode_compare = [composite_lti_bode_compare; X.sys_ol];
    legend_bode_compare = [legend_bode_compare; P.case_title];
    bode(composite_lti_bode_compare, X.f_min, X.f_max, legend_bode_compare, 'rad')

    // Save results
    D.active = active;
    D.verbose = verbose;
    D.P = P;
    D.R = R;
    D.G = G;
    D.C = C;
    D.PSO = PSO;
    D.W = W;
    D.WC = WC;
    D.MU = MU;
    print_struct(D, '', fdo, ',', case_num>1);
    save(P.save_file_name, 'G', 'C', 'WC', 'P', 'R', 'PSO', 'MU', 'PSO');

    scf(n_fig_bode_compare);  f=gcf(); f.visible="on";
    scf(n_fig_step_compare);  f=gcf(); f.visible="on";
end

mclose(fdo);
rotate_file(save_file, save_file);
if getos()=='Windows' then
   [fdo, err] = mopen(save_file, 'a+');
    winopen(save_file);
    mclose(fdo);
else
    editor(save_file);
end
