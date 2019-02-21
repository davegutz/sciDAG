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
// Nov 24, 2018     DA Gutz     Created
// 
// allServo_PSO_run.sce
// Open script driver to run the Particle Swarm Optimizer on a generic actuator
// servo control loop design using an excel spreadsheet to setup the design
// cases and studies.   Open the execl spreadsheet by the same name:  
// allServo_PSO_input.xls and modify the parameters.   The structures used in 
// this script are initialized in the xls file.  But not all the values in the 
// xls file are essential for running.  Many are created by the script.   The 
// script saves the results in a csv file:   saves/allServo_PSO_output.csv.  
// The formats of the files are designed so that you may cut and paste from
// _output.csv to _inputs.xls and rerun as much as you want so many output
// parameters come to reside in the input file.
// The PSO algorithm as implemented does not stop on a convergence criteria, 
// rather the user watches it and modifies PSO.itmax to limit it.  The actual 
// final iterations is PSO.iters.   TODO:  make the PSO_radius function work.
// The cost weightings follows the scheme outlined in Sahib, M et. al. "A
// New Mltiobjective Performance Criterion Used in PID Tuning Optimization
// Algorithms,"  Journal of Advanced Research, April 3, 2015.  This paper
// describes how to manage the scaling (MU), costs (WC) to produce pareto optimal 
// solutions using a single-dimensioned derived cost number.  Cost is J in the
// paper; cost is Score.total in this script.  The denominator of eq 20
// is w_i = W(i) where mu_i = MU(i), sum(1/ mu_n) = MU.sum.
// The user first sets expected or observed MU values (approximate generic
// used for numerical scaling) then varies WC values to prioritize cost contributions
// of individual performance measurements and this script manages the sums
// in the "with" portion of eq 20.  If the user needs to add another scaling
// parameter it should be possible to do it without affecting other
// runs created before the new parameter is added by setting WC.new = 0
// int he input file for the old cases.
//
// Files:
// allServo_PSO_inputs.xls      Excel spreadsheet with input values 
//                              (and outputs) to control all phases of operation.
//                              Nomenclature is summarized below.   Use Microsoft
//                              Excel or Open Office (TODO: untested) to edit this file.
//                              If you have trouble with quoted parameters in Excel being
//                              read properly by this script and from being displayed
//                              properly in Excel, then enter ''mytext' into the
//                              cell instead of 'mytext'.   "mytext" will also work.
// saves/allServo_PSO_outputs.csv       Comma-separated-variable file of results.   All 
//                              the inputs are saved in here to to create a re-do
//                              loop mechanism for convenient design iteration.
// saves/allServo_PSO_*.dat             Scilab binary file save for each case named by
//                              the parameter P.case_title.   This is done so
//                              the lti systems may be used to create plots etc
//                              without rerunning the long optimization.   Use the 
//                              parameter replot_only=1 to invoke this.   The paratmeter
//                              active all needs to be set active=1.
// Objectives/allServo_PSO_lti.sci      Function that calculates the lti
//                              systems used to generate performance metrics.
// Objectives/allServo_PSO_Obj.sci      Function default for the cost function.   The
//                              exact objective function may be specified for
//                              each case in the input file.  If it does not 
//                              exist then this default is used. 
// Objectives/allServo_PSO_Outputfun.sci    Function called by PSO for verbose output.
//                              The verbosity level controlled by PSO.verbose.
// Objectives/allServo_PSO_Perf.sci     Function that calculates lti system response.
// 
// Inputs (all must appear in inputs.xls)
//  active          Calculate or reload and display in plots.
//  replot_only     Do not optimize; load solution stored in saves/?.dat
//  verbose         Level of verbosity used debugging.   See PSO.verbose.   
// Input system parameters
//  G.tehsv1        Plant driver lag, s  (0.007)
//  G.tehsv2        Plant hydraulic lag, s (0.010)
//  G.gain          Plant gain, %/s/mA  (1 - use C.gain as loopgain)
// Input control parameters
//  C.dT            Update time, s (0.010)
//  C.tld1/C.tlg1   Initial forward path lead/lag #1, s
//  C.tld2/C.tlg2   Initial forward path lead/lag #2, s
//  C.tldh/C.tlgh   Initial feedback path lead/lag, s
//  C.gain          Initial control gain, mA/% (30 loopgain)
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
// Cost weights
//  WC.tr', 1, 
//  WC.Mp', 1, 
//  WC.Mu', 1, '
//  WC.ts', 0.2, 
//  WC.sum', 0. , 
//  WC.invgain', 2);
//
// Outputs
// Calculated control parameters
//  C.tld1/C.tlg1   Final optimal forward path lead/lag #1, s
//  C.tld2/C.tlg2   Final optimal forward path lead/lag #2, s
//  C.tldh/C.tlgh   Final optimal feedback path lead/lag, s
//  C.gain          Final optimal control gain, mA/% (30 loopgain)
// Final weights that were calculated in PSO objective.   See MU for units.
//  W.tr
//  W.Mp
//  W.ts
//  W.invgain
// Particle Swarm Optimizer Settings
//  PSO.wmax        Initial weight parameter
//  PSO.wmin        Final weight parameter
//  PSO.itmax       Maximum iteration number
//  PSO.c1          Knowledge factors for personnal best
//  PSO.c2          Knowledge factors for global best
//  PSO.N           Number of particles
//  PSO.D           Problem dimension in R^2
//  PSO.launchp     Launch probability, default = 0.9 (?)
//  PSO.speedf      Speed factor, default = 2*D
//  PSO.boundsmax   Bounds for hunting around C
//  PSO.boundsmin   Bounds for hunting around C
//  PSO.verbose     Level of verbosity for debugging.
//  PSO.radius      Independent cluster convergence
//  PSO.n_radius    Confirmation counts for cluster convergence
//  PSO.n_stuck     Score repeat allowance.  Waits n_stuck before checking
//                  then waits another n_stuck
// Performance results
//  P.case_title    Case title for plots etc
//  P.case_date_str Date stamp
//  P.f_min_s       scalar on min of frequency range
//  P.f_max_s       scalar on max of frequency range
//  P.save_file_name    Saved binary information file name
//  P.f_min         Used frequency lower limit, Hz
//  P.f_max         Used frequency upper limit, Hz
//  P.sys_cl        lti closed looop
//  P.sys_ol        lti open looop
//  P.gm            Resulting gain margin, dB
//  P.pm            Resulting phase margin, deg
//  P.gwr           Resulting gain crossover, rad/s 
//  P.pwr           Resulting phase crossover, rad/s 
//  P.ts            Resulting settle time, s
//  P.Mu            Resulting magnitude undershoot, %
//  P.tu            Resulting time at undershoot, s
//  P.Mp            Resulting magnitude overshoot, %
//  P.tp            Resulting time at overshoot, s
//  P.tr            Resulting rise time, s
//  P.casestr_i     Resulting initial result
//  P.casestr_f     Resulting final result
// X    Structure used to manage local parameters not needed as output.
// W    Sstructure used to manage final cost weightings.

// Initiialization
clear
clearglobal
funcprot(0);
getd('../ControlLib')
n_fig = -1;
xdel(winsid())
mclose('all');

// Local preferences
PREF.show_pngs = %f;
PREF.show_csv = %f;

// Setup comparison plots
n_fig = n_fig + 1;
X.n_fig_step_compare = n_fig;
n_fig = n_fig + 1;
n_fig_bode_compare = n_fig;


// Global for debug
global verbose
// Globals for solver PSO.allServo_PSO_Obj
global G C W P X S
verbose = 0;
global PSO

// File management
this = 'allServo_PSO';
input_file = './' + this + '_input.xls';
save_file = 'saves/' + this + '_output.csv';
[dummy, date_str] = get_stamp(); 
pdf_file = 'saves/' + this + date_str;
png_step_file = 'saves/' + this + '_step_' + date_str;
png_bode_file = 'saves/' + this + '_bode_' + date_str;
perf_file = 'Objectives/' + this + '_perf.sci';
lti_file = 'Objectives/' + this + '_lti.sci';
outputfun_file = 'Objectives/' + this  + '_Outputfun.sci';
outputfun_str = this + '_Outputfun';
obj_function_default = this + '_Obj';
exec(perf_file, -1);
exec(lti_file, -1);
exec(outputfun_file, -1);

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
X.dt_plot = 0.01;
X.t_step = 0:X.dt_plot:2;

// The Loop
composite_lti_bode_compare = [];
X.legend_bode_compare = [];
for case_num=1:n_cases

    // Print banner
    mprintf('\n****************Case %d of %d:\n', case_num, n_cases);

    // Load parameters
    G = V(case_num).G;
    C = V(case_num).C;
    WC = V(case_num).WC;
    P = V(case_num).P;
    R = V(case_num).R;
    PSO = V(case_num).PSO;
    MU = V(case_num).MU;
    active = V(case_num).active;
    replot_only = V(case_num).replot_only;
    verbose = V(case_num).verbose;
    status = V(case_num).status;
    PSO.weights = [PSO.wmax; PSO.wmin];
    PSO.c = [PSO.c1; PSO.c2];
    X.D = PSO.D;
    if replot_only then
        W = V(case_num).W;
        evstr(outputfun_str + '(0, PSO.f1, [C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh])');
    end
   
    // Configure the objective function
    try
        P.obj_function = R.obj_function;
        obj_function_file = 'Objectives/' + P.obj_function + '.sci';
        exec(obj_function_file, -1);
    catch
        status = msprintf('R.obj_function defines a file %s that cannot be opened.  Default used.', R.obj_function);
        warning(status)
        P.obj_function = obj_function_default;
        obj_function_file = 'Objectives/' + P.obj_function + '.sci';
        exec(obj_function_file, -1);
    end

    // File saving
    P.save_file_name = 'saves/' + this + '_' + P.case_title + '.dat';

    // Frequency range for plots
    X.f_min = 1/2/%pi*P.f_min_s;
    X.f_max = 1/C.dT*P.f_max_s;

    if ~replot_only then
        WC.sum = WC.tr + WC.Mp + WC.Mu + WC.ts + WC.invgain;
        X.tr = WC.tr/WC.sum;
        X.Mp = WC.Mp/WC.sum;
        X.Mu = WC.Mu/WC.sum;
        X.ts = WC.ts/WC.sum;
        X.invgain = WC.invgain/WC.sum;

        MU.sum = 1/MU.tr + 1/MU.Mp + 1/MU.Mu + 1/MU.ts + 1/MU.invgain;
        W.tr = X.tr/(MU.tr*MU.sum);
        W.Mp = X.Mp/(MU.Mp*MU.sum);
        W.Mu = X.Mu/(MU.Mu*MU.sum);
        W.ts = X.ts/(MU.ts*MU.sum);
        W.invgain = X.invgain/(MU.invgain*MU.sum);

        PSO.f1 = evstr(P.obj_function + '([C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh]);');
        P.casestr_i = X.casestr;
        evstr(outputfun_str + '(0, PSO.f1, [C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh])');
        C.raw_i = C.raw;
        n_fig = n_fig+1;
        X.n_fig_step = n_fig;
        scf(X.n_fig_step); clf(); X.gcf_step = gcf();
        plot(X.t_step, X.y_step, 'k')
        replot([0, 0.8, 5*R.ts, 1+2*R.Mp]);
        xgrid(0);
        X.y_step_init = X.y_step;
        sys_ol_i = S.sys_ol;


        // PSO inputs
        PSO.x0 = [C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh];
        speed_max = 0.1*PSO.boundsmax;
        speed_min = 0.1*PSO.boundsmin;
        X.speed = [speed_min, speed_max];
        grand('setsd', 0); // must initialize random generator.  Want same result on repeated runs.

        // Particle Swarm algorithm
        if PSO.verbose>1 then
            n_fig = n_fig+1;
            figure(n_fig);
            scf(n_fig);
        end
        if active then
            PSO.iters = 0;
//            [P.fopt, P.xopt]=PSO_bsg_starcraft(evstr(P.obj_function), ..
//            [PSO.boundsmin, PSO.boundsmax],..
//            X.speed, PSO.itmax, PSO.N,..
//            PSO.weights, PSO.c, PSO.launchp, PSO.speedf,..
//            PSO.N, allServo_PSO_Outputfun, PSO.x0);
//radius = [32 .01 .01 .01 .01 .01 .01]/1; n_radius = 5;
            [P.fopt, P.xopt, iopt]=myPSO_bsg_starcraft_rad(evstr(P.obj_function),.. 
            [PSO.boundsmin, PSO.boundsmax],..
            X.speed, PSO.itmax, PSO.N,..
            PSO.weights, PSO.c, PSO.launchp, PSO.speedf,..
            PSO.N,.. 
            PSO.radius, PSO.n_radius,..
            allServo_PSO_Outputfun, PSO.x0,..
            PSO.n_stuck);
            PSO.iters = PSO.iters + 1;
            evstr(outputfun_str + '(PSO.iters, P.fopt, P.xopt)');

   
            [dummy, P.case_date_str] = get_stamp(); 
        else
            P.case_date_str = '';
        end
        P.casestr_f = X.casestr;

        // plots
        n_fig = n_fig+1;
        n_fig_bode = n_fig;
        scf(n_fig_bode); clf();
        bode([sys_ol_i; S.sys_ol], X.f_min, X.f_max, [P.casestr_i, P.casestr_f], 'rad')
        scf(X.n_fig_step);
        plot(X.t_step, X.y_step_init, 'k')
        plot(X.t_step, X.y_step, 'b')
        replot([0, 0.8, 5*R.ts, 1+2*R.Mp]);
        xgrid(0);
        title(P.case_title,"fontsize",3);
        xlabel("t, sec","fontsize",4);
        ylabel("$y$","fontsize",4);
        legend([P.casestr_i, P.casestr_f]);

    else
        load(P.save_file_name);
    end  // if ~replot_only

    scf(n_fig_bode_compare); clf(); X.gcf_bode_compare=gcf();
    composite_lti_bode_compare = [composite_lti_bode_compare; S.sys_ol];
    X.legend_bode_compare = [X.legend_bode_compare; P.case_title];
    myBodePlot(composite_lti_bode_compare, X.f_min, X.f_max, 'rad')
    legend(X.legend_bode_compare);

    scf(X.n_fig_step_compare); clf(); X.gcf_step_compare = gcf();
    X.y_step_all($+1,:) = csim('step', X.t_step, S.sys_cl);
    plot(X.t_step', X.y_step_all')
    replot([0, 0.8, 5*R.ts, 1+2*R.Mp]);
    xgrid(0);
    title(this,"fontsize",3);
    xlabel("t, sec","fontsize",4);
    ylabel("$y$","fontsize",4);
    X.step_compare_legend($+1) = P.case_title;
    legend(X.step_compare_legend);

    // Save results
    D.active = active;
    D.replot_only = replot_only;
    D.status = status;
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
    if ~replot_only then
        save(P.save_file_name, 'G', 'C', 'WC', 'P', 'R', 'PSO', 'MU', 'PSO', 'S');
    end 
    mprintf('------------------------------------------------------\n');
    X.gcf_bode_compare.visible="on";
    X.gcf_step_compare.visible="on";
end

// Plot summary graphics for import into other programs
xs2png(X.n_fig_step_compare, png_step_file);
xs2png(n_fig_bode_compare, png_bode_file);
if PREF.show_pngs then
    winopen(png_step_file+'.png')
    winopen(png_bode_file+'.png')
end

// Open csv results file
mclose(fdo);
rotate_file(save_file, save_file);
if PREF.show_csv then
    if getos()=='Windows' then
        [fdo, err] = mopen(save_file, 'a+');
        winopen(save_file);
        mclose(fdo);
    else
        editor(save_file);
    end
end
