%% F414_Fuel_Set_Case
% Set Z.case parameter for plots and file names
% 13-Sep-2017   DA Gutz     Created


try strS = char(Z.strS);
catch ERR
    if ~exist('strS', 'var')
        defaulting  = 1;
    else
        defaulting = 0;
        strSSav = strS;
    end
    strS        = 'x';
end
if MOD.fullUp
    Z.case =  sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%02ld_%02ld',...
        round(Z.selectAC), round(Z.fxven), round(Z.dFXVENX), round(Z.xn25), round(Z.wf36), round(Z.pamb*10),...
        round(FP.sg*100), round(FP.kvis*10));
    savstrT = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX), round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(FP.sg*100), round(FP.kvis*10), strS);
    savstr = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX),  round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(FP.sg*100), round(FP.kvis*10), strS);
else
    Z.case =  sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%03ld_%03ld_%02ld_%02ld',...
        round(Z.selectAC), round(Z.fxven), round(Z.dFXVENX), round(Z.xn25), round(Z.wf36), round(Z.pamb*10),...
        round(Z.pr*10), round(Z.ps), round(FP.sg*100), round(FP.kvis*10));
    savstrT = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%03ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX), round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(ic.venstart.pr*10), round(ic.venstart.ps), round(FP.sg*100), round(FP.kvis*10), strS);
    savstr = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%03ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX),  round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(Z.pr*10), round(Z.ps), round(FP.sg*100), round(FP.kvis*10), strS);
end
if exist('defaulting', 'var')
    if defaulting
        clear strS;
    else
        if exist('strSSav', 'var')
            strS = strSSav;
            clear strSSav
        end
    end
end
