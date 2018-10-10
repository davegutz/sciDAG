function sys = lti_vol_1(vol, beta, spgr)
% function sys = lti_vol_1(vol, beta, spgr)
% Building block for a volume having two flow inputs.
% Author:   D. A. Gutz
% Written:  16-Apr-92
% Revisions:None.
%
% Input:
% beta  Fluid bulk modulus, psi.
% spgr  Fluid specific gravity.
% vol   Volume, cuin.
% wfs   Input # 1, supply flow, pph.
% wfd   Input # 2, discharge flow, pph.
%
% Output:
% sys   Packed system of Input and Output
%
% Differential I/O:
% wfs   Input # 1, supply flow, pph
% wfd   Input # 2, discharge flow, pph
% p     Output # 1, slice pressure, psid.

% Derivative
dp = beta / 129.93948 / vol / spgr;    % Derivative, psi/sec.
a = [0];
b = [dp -dp];
c = [1];
e = [0 0];

% Form the system.
sys = pack_ss(a, b, c, e);
