function [icp] = calc_pos_pump_a(GEOP, icp, FP)
% Pump flow calculation
% inputs:   N, pd, ps, disp
% outputs:  wf

% /* Check for cavitation */
if icp.ps < FP.tvp + FP.tvp_margin,
    fprintf('icp supply icpure below tvp+margin in calc for %s\n', mfilename);
    icp.ps = FP.tvp + FP.tvp_margin;
end

% /* Pressure terms */
icp.pl  = icp.pd - icp.ps;

%/* Flow terms */
icp.mtdqp     = FP.avis * .10471976 * icp.N / icp.pl;
icp.eff_vol   = 1. -...
    GEOP.curve.cs / icp.mtdqp -...
    GEOP.curve.ct * 1825 * ssqrt(icp.pl / FP.sg) / icp.N / (sgn(icp.disp) * max(abs(icp.disp), 1e-24))^ .3333333 -...
    GEOP.curve.cn;
icp.cis = icp.eff_vol * icp.disp * icp.N / 60.;
icp.gpm = icp.cis / 3.85;
icp.wf  = icp.cis * FP.dwdc;
return
