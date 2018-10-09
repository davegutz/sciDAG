function sys = lti_ip_wpstopd(a, b, c, f, r1, b1, r2, b2, rpm, wf, sg, tau)
% function sys = ip_wpstopd(a, b, c, f, r1, b1, r2, b2, rpm, wf, sg, tau)
% Impeller model, flow and supply pressure to discharge.
% Author:   D. A. Gutz
% Written:  20-Sep-2013
% Revisions: 
%  11-Apr-2014  DA Gutz    Add f coefficient
%
% Input:
% a     Pump head coefficients.
% b              "
% c              "
% f              "
% r1    Inner radius, in.
% b1    Inner disk width, in.
% r2    Outer radius, in.
% b2    Outer disk width, in.
% rpm   Speed.
% wf    Flow, pph.
% sg    Specific gravity.
% tau   Time constant, sec.
%
% Differential IO:
% wf  Input  # 1, flow, pph.
% ps  Input  # 2, supply pressure, psi.
% rpm Input  # 3, speed, rpm.
% pd  Output # 1, discharge pressure, psi.
%
% Output:
% sys   Packed system of Input and Output.
% pd-ps Pressure rise, psid
%
% Local:
% dfcdwf    Flow coefficient due to flow, 1/pph.
% dhcdfc    Head coefficient due to flow coefficient.
% dpdhc     Pressure due to head coefficient, psi.
% dfcdrpm   Flow coefficient due to speed, 1/rpm.
% dwdc      Conversion cis to pph.
% fc        Flow coefficient.
% q         Connection matrix.
% u         Input matrix.
% y         Output matrix.
%
% States:
% none.
%
% Functions called:
% None.

% Parameters.
dwdc = 129.93948 * sg;
fc = 5.851 * wf / (dwdc * 3.85 * b2 * r2^2 * rpm);
% hc = a + (b + (c + f*fc)*fc)*fc;
% dp = 1.022e-6 * hc * sg * (r2^2 - r1^2) * rpm^2;

% Partials.
dfcdwf = fc / wf;
dhcdfc = b + 2*c*fc + 3*f*fc^2;
dpdhc = 1.022e-6 * sg * (r2^2 - r1^2) * rpm^2;
dfcdrpm = -fc / rpm;

% Connections and system construction.
as = -1/tau;
bs = [dfcdwf*dhcdfc*dpdhc/tau  0  dfcdrpm*dhcdfc*dpdhc/tau];
cs = 1;
es = [0 1 0];
sys = pack_ss(as, bs, cs, es);
