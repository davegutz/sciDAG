function sys = lti_dla_kptow(wf, ps, pd, kvis)
% DLA_KPTOW.	Differential area/pressure to flow for a laminar leakage.
% Author:	D. A. Gutz
% Written:	22-Dec-92
% Revisions:

% Input:
% pd		Discharge pressure, psia.
% ps		Supply pressure, psia.
% kvis		Viscocity, centistokes.
% wf		Flow, pph.

% Differential IO.
% ps		Input # 1, supply pressure, psia.
% pd		Input # 2, discharge pressure, psia.
% k         Input # 3, area perturbation, pph-centistokes/psi.
% wf		Output # 1, flow, pph.

% Output:
% sys		Differential orifice model.

% Local:
% dwfdk	Partial flow to area.
% dwfdp	Partial flow to pressure, pph/psi.

% States:
% none.

% Functions called:
% none.

% Parameters.
% none.

% Partials.
dwfdk	= (ps - pd) / kvis;
dwfdp	= wf / (ps - pd);

% Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dwfdp 	-dwfdp		dwfdk];

% Form the system.
