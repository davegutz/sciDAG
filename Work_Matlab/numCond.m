function [Z, MOD] = numCond(Z, MOD, E)
% 11-Apr-2016       DA Gutz     Created
% Revisions

%
switch(MOD.condition)
    case {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
        Z.awfb  = E.sawfb(MOD.condition);
        Z.pcn25 = E.spcn25(MOD.condition);
        Z.xn25  = Z.pcn25*172.1;
        Z.wf36  = E.swf(MOD.condition);
        Z.pamb  = MOD.cpstd;
        sfxven  = E.sfxven(MOD.condition);
        if sfxven, Z.fxven = sfxven; end
        clear sfxven
        MOD.run = {sprintf('%05.0f%#, N25=%5.0frpm, Wf=%5.0fpph, %4.1fpsia', Z.fxven, Z.xn25, Z.wf36, Z.pamb)};
    otherwise
        error('Unknown conditon = %ld', MOD.condition);
