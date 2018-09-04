function FVAL = genCaseInitVEN_Subsystem(X)
%%function FVAL = genCaseInitVEN_Subsystem(X)
% 05-Apr-2012       DA Gutz     Created from genCaseServoActuator
% Revisions:
% 25-Mar-2013       DA Gutz     Added lti* functions to reduce errors


global FPi
global MODi
global GEOi
global FVAL


%%Inputs
x = X.*MODi.S; % Apply ScaleServoActuator
switch(MODi.level)
    case 0
        x(1)=max(x(1), GEOi.venstart.load.ehsv.xmin );  % limit xehsv.   BIG TIME ERROR TRAP
        x(2)=max(x(2), GEOi.venstart.reg.xmin );  % limit xreg.    BIG TIME ERROR TRAP
        x(3)=max(x(3), GEOi.venstart.bi.xmin   );  % limit xbi.   BIG TIME ERROR TRAP
        x(4)=max(x(4), 100.   );  % limit pd.   BIG TIME ERROR TRAP
        x(5)=max(x(5), 100.   );  % limit prod.   BIG TIME ERROR TRAP
        evalin('base', sprintf('ic.venstart.x1_xehsv=%f;',     x(1)));
        evalin('base', sprintf('ic.venstart.x2_xreg=%f;',      x(2)));
        evalin('base', sprintf('ic.venstart.x3_xbi=%f;',       x(3)));
        evalin('base', sprintf('ic.venstart.x4_pd=%f;',        x(4)));
        evalin('base', sprintf('ic.venstart.x5_prod=%f;',      x(5)));
    otherwise
        % Calculate only
end
% initialize from files
if ~MODi.loaded,
    MODi.loaded = 1;
end

%%Make systems and evaluate response
% keyboard

%%Responses
[ic, GEOi] = evalin('base', sprintf('F414_Fuel_System_Balance_VENstandalone(ic, GEOi, FPi, MODi)'));
assignin('base', 'ic', ic);

switch(MODi.level)
    case {0, 1}
        FVAL = [ic.venstart.e1_px ic.venstart.e2_all ic.venstart.e3_regf ic.venstart.e4_bif ic.venstart.e5_prod];
        FVAL = norm(FVAL);
%         FVAL = (sum(abs(FVAL)))^2;
    otherwise
        FVAL = [ic.venstart.e1_px ic.venstart.e2_all ic.venstart.e3_regf ic.venstart.e4_bif ic.venstart.e5_prod];
        FVAL = norm(FVAL);
 end
