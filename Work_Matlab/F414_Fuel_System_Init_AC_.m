function [ic, GEO] = F414_Fuel_System_Init_AC_(ic, ptank, ps3, wf36, GEO, FP)
%%function ic = F414_Fuel_System_Init_AC_(ic)
% 29-Apr-2012   DA Gutz     Created


% Inputs:   pamb, wfengine=wfac=wf36, xn25 et.al.
% Outputs:  pengine

% Outputs

% Name changes
acb     = GEO.acbst;
acmb    = GEO.acmbst;
amotor  = GEO.motor;
iacb    = ic.acbst;
iacmb   = ic.acmbst;

ic.ltank.wf     = wf36;
ic.lengine.wf   = wf36;
iltank  = ic.ltank;
ilengine = ic.lengine;
Qac_init   = wf36 / FP.dwdc;
iacb.q     = Qac_init;
S_init = 0.5;  %initial loop value
S_max  = 1;
S_min  = 0;
count  = 0;

% AC tank pressure
Pac    = ps3;    %(Add to upper level)
Pacm   = ptank;      %(Add to upper level)

% Top of loop
% fprintf('pass  Pac    Pacm    S_now S_max  S_min\n');
while (abs(Pac - Pacm)>1e-6 && S_init<1 && count<50)
    iacmb.q             = Qac_init * S_init;
    imotor.wf           = iacmb.q * FP.dwdc;
        
    % Calculate pressures
    Pac_init            =ptank;
    
    % Pump pressure
    fcx             = 5.851 * Qac_init / (3.85 * acb.w2 * acb.r2^2 * iacb.NRpm);
    hcx             = acb.a + (acb.b + (acb.c + acb.d * fcx) * fcx) * fcx;
    iacb.dP_Pump    = 1.022e-6 * hcx * FP.sg * (acb.r2^2 - acb.r1^2) * iacb.NRpm^2;
    iacb.Pd_Pump    = ptank + iacb.dP_Pump;
    fcx             = 5.851 * Qac_init / (3.85 * acmb.w2 * acmb.r2^2 * iacmb.NRpm);
    hcx             = acmb.a + (acmb.b + (acmb.c + acmb.d * fcx) * fcx) * fcx;
    iacmb.dP_Pump   = 1.022e-6 * hcx * FP.sg * (acmb.r2^2 - acmb.r1^2) * iacmb.NRpm^2;
    iacmb.Pd_Pump   = iacb.Pd_Pump + iacmb.dP_Pump;
    clear fcx hcx
    
    %%%Orifice:(Q, Area) --> dP
    imotor.dP       = sign(Qac_init) * amotor.dp*(imotor.wf/amotor.wf)^2;

    ilengine.p      = iacmb.Pd_Pump - imotor.dP;
    Pac             = iacb.Pd_Pump;
    Pacm            = ilengine.p;
    count           = count + 1;
    S_now           = S_init;
%     fprintf('%ld   %5.1f   %5.1f  %5.2f %5.2f  %5.2f\n', count, Pac, Pacm, S_now, S_max, S_min);
    if Pacm > Pac
        S_init  = (S_now + S_max)/2;
        S_min   = max(S_min, S_now);
    else
        S_init  = (S_now + S_min)/2;
        S_max   = min(S_max, S_now);
    end
    
end
% fprintf('pass  Pac    Pacm    S_now S_max  S_min\n');
iltank.p            = Pac_init;
iltank.wf           = iacb.q * FP.dwdc;
ic.pengine          = ilengine.p;
ic.wfbypass         = iacb.q * FP.dwdc * (1-S_init);
ic.wfacbst          = iacb.q * FP.dwdc;
ic.wfacmbst         = iacmb.q * FP.dwdc;
iacb.Ps_Pump        = Pac_init;
ic.ltank.p  = Pac_init;
ic.pacbsts          = Pac_init;
ic.pacbst           = iacb.Pd_Pump;
ic.pacmbst          = iacmb.Pd_Pump;
ic.ptank            = ptank;
GEO.acbst   = acb;
GEO.acmbst  = acmb;
GEO.motor   = amotor;
ic.acbst    = iacb;
ic.acmbst   = iacmb;
ic.motor    = imotor;
ic.ltank    = iltank;
ic.lengine  = ilengine;
ic.S_init   = S_init;

