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

// Filenames
this = 'allServo-PSO';
input_file = './' + this + '_input.xls';
save_file = 'saves/' + this + '_run.csv';

// System parameters
G = struct( 'tehsv1', 0.007,..              // Plant driver lag, s
'tehsv2', 0.01,..               // Plant hydraulic lag, s
'gain', 1);                     // Plant gain, %/s/mA
C = struct( 'dT', 0.01,..                   // Update time, s
'tld1', 0.013, 'tlg1', 0.009,.. // Forward path lead/lag #1
'tld2', 0.013, 'tlg2', 0.009,.. // Forward path lead/lag #2
'tldh', 0.015, 'tlgh', 0.008,.. // Feedback path lead/lag
'gain', 32.6);                  // Control gain, mA/%
MU = struct('gm', 9, 'pm', 60, 'pwr', 30,..
'tr', 0.05, 'Mp', 0.15, 'Mu', 0.15, 'ts', 0.2, 'sum', 0,..
'invgain', 1/30);
W = struct('tr', 0, 'Mp', 0, 'ts', 0, 'invgain', 0);
R = struct('gm', 6, 'pm', 45, 'pwr', 40,..
'rise', 0.95, 'settle', 0.02,..
'invgain', 1/30,..
'tr', 0.07, 'Mp', 0.10, 'Mu', 0.05, 'ts', 0.2,..
'obj_function', 'allServo_PSO_Obj');
WC = struct('tr', 1, 'Mp', 1, 'Mu', 1, 'ts', 0.2, 'sum', 0. , 'invgain', 2);
PSO    = struct('wmax',     0.9,..      // initial weight parameter
'wmin',     0.4,..      // final weight parameter)
'itmax',    5,..        // maximum iteration number
'c1',       0.7,..      // knowledge factors for personnal best
'c2',       1.47,..     // knowledge factors for global best
'n_raptor', 50,..       // problem dimensions: number of particles
'D',        7,..        // problem in R^2
'launchp',  0.9,..      // launch probability, default = 0.9 (?)
'speedf',   2*ones(1,7),..// X.speed factor, default = 2*D
..// Bounds for hunting around C
'boundsmax',[50; 0.250; 0.025; 0.250; 0.025; 0.250; 0.250],..
'boundsmin',[25; 0.000; 0.008; 0.000; 0.008; 0.000; 0.125]);
P  = struct('case_title',   '',..       // Case title for plots etc
'case_date_str','',..       // Date stamp
'sys_name',     '',..       // System name
'f_min_s',      %nan,..     // scalar on min of frequency range
'f_max_s',      %nan,..     // scalar on max of frequency range
'save_file_name', '',..     // Saved binary information file name
'f_min',        %nan,..     // Used frequency lower limit, Hz
'f_max',        %nan,..     // Used frequency upper limit, Hz
'sys_cl',       %nan,..     // lti closed looop
'sys_ol',       %nan,..     // lti open looop
'gm',           %nan,..     // Resulting gain margin, dB
'pm',           %nan,..     // Resulting phase margin, deg
'gwr',          %nan,..     // Resulting gain crossover, rad/s 
'pwr',          %nan,..     // Resulting phase crossover, rad/s 
'ts',           %nan,..     // Resulting settle time, s
'Mu',           %nan,..     // Resulting magnitude undershoot, %
'tu',           %nan,..     // Resulting time at undershoot, s
'Mp',           %nan,..     // Resulting magnitude overshoot, %
'tp',           %nan,..     // Resulting time at overshoot, s
'tr',           %nan,..     // Resulting rise time, s
'casestr_i',    '',..       // Resulting initial result
'casestr_f',    '');        // Resulting final result
mkdir('./saves');
[fdo, err] = mopen(save_file, 'wt');
if err<0 then
    mprintf('%s--->', save_file)
    error('is output file still open?')
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

// Performance function called by objective function
function [P, C, X] = myPerf(G, C, R, swarm, P, X)
    global verbose
    C.raw = swarm;
    if verbose>2 then
        mprintf('C.raw=%6.3f/%6.3f/%6.3f/%6.3f%6.3f/%6.3f%6.3f\n', C.raw);
    end
    C.gain = max(swarm(1), 3);
    C.tld1 = max(swarm(2), 0);
    C.tlg1 = max(swarm(3), 0.008);
    C.tld2 = max(swarm(4), 0);
    C.tlg2 = max(swarm(5), 0.008);
    C.tldh = max(swarm(6), 0);
    C.tlgh = max(swarm(7), 0.008);
    [X.sys_ol, X.sys_cl] = myServo(C.dT, G, C);
    [P.gm, gfr] = g_margin(X.sys_ol);
    [P.pm, pfr] = p_margin(X.sys_ol);
    P.gwr = gfr*2*%pi;
    P.pwr = pfr*2*%pi;
    X.y_step = csim('step', X.t_step, X.sys_cl);
    [P.tr, P.tp, P.Mp, P.tu, P.Mu, P.ts] = ..
        myStepPerf(X.y_step, X.t_step, R.rise, R.settle, C.dT);
endfunction

// Da Loop
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

    ierr = execstr(['obj_function = R.obj_function;'], 'errcatch');
    if ierr then
        obj_function = 'allServo_PSO_Obj';
    end
    obj_function_file = 'Objectives/' + obj_function + '.sci';
    exec(obj_function_file, -1);

    // File saving
    P.save_file_name = 'saves/' + this + '_' + P.sys_name + '_' + P.case_title + '.dat';

    // Frequency range
    X.f_min = 1/2/%pi*P.f_min_s;
    X.f_max = 1/C.dT*P.f_max_s;



    MU.sum = MU.tr + MU.Mp + MU.Mu + MU.ts + MU.invgain;
    R.sum = R.tr + R.Mp + R.Mu + R.ts + R.invgain;
    W.tr = R.sum/R.tr * MU.sum/MU.tr;
    W.Mp = R.sum/R.Mp * MU.sum/MU.Mp;
    W.Mu = R.sum/R.Mu * MU.sum/MU.Mu;
    W.ts = R.sum/R.ts * MU.sum/MU.ts;
    W.invgain = R.sum/R.invgain * MU.sum/MU.invgain;

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
    mprintf('%5.2f*(%5.4f/%5.4f)*(%5.4f/%5.4f)*(%5.4f/%5.4f):  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
    C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, P.gm, P.gwr, P.pm, P.pwr)
    mprintf('tr=%5.3f s Mp100=%6.3f  Mu100=%6.3f  ts=%5.3f s\n',..
    P.tr, P.Mp*100, P.Mu*100, P.ts);
    disp(P.casestr_i)
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
    PSO.verbosef = 1; // 1 to activate autosave and graphics by default

    // Particle Swarm algorithm
    PSO.verbosef = 1; // 1 to activate autosave and graphics by default
    if PSO.verbosef>0 then
        n_fig = n_fig+1;
        figure(n_fig);
        scf(n_fig);
    end
    if active then
        [P.fopt, P.xopt]=PSO_bsg_starcraft(evstr(obj_function), ..
            [PSO.boundsmin, PSO.boundsmax],..
            X.speed, PSO.itmax, PSO.n_raptor,..
            PSO.weights, PSO.c, PSO.launchp, PSO.speedf,..
            PSO.n_raptor, PSO.verbosef, PSO.x0);
        [dummy, P.case_date_str] = get_stamp(); 
    else
        P.case_date_str = '';
    end
    P.casestr_f = msprintf('Final %4.1f*(%5.4f/%5.4f)*(%5.4f/%5.4f)*(%5.4f/%5.4f): %4.1f/%4.0f',..
    C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, P.gm, P.pm);
    mprintf('xopt= %4.1f/%5.4f, fopt=%e\n', P.xopt, P.fopt);
    mprintf('%5.2f*(%5.4f/%5.4f)*(%5.4f/%5.4f)*(%5.4f/%5.4f):  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
    C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, P.gm, P.gwr, P.pm, P.pwr)
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
    
    scf(n_fig_step_compare);clf();
    y_step_compare($+1,:) = X.y_step;
    plot(t_step_compare, y_step_compare)
    title(this,"fontsize",3);
    xlabel("t, sec","fontsize",4);
    ylabel("$y$","fontsize",4);
    step_compare_legend($+1) = P.case_title;
    legend(step_compare_legend);

    n_fig = n_fig+1;
    n_fig_bode = n_fig;
    scf(n_fig_bode); clf();
    bode([sys_ol_i; X.sys_ol], X.f_min, X.f_max, [P.casestr_i, P.casestr_f], 'rad')

    scf(n_fig_bode_compare);
    bode(X.sys_ol, X.f_min, X.f_max, P.case_title, 'rad')

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

end

mclose(fdo);
rotate_file('saves/allServo-PSO_run.csv', 'saves/allServo-PSO_run.csv');
if getos()=='Windows' then
    winopen('saves/allServo-PSO_run.csv');
else
    editor('saves/allServo-PSO_run.csv');
end
