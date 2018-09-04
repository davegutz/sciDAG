%% F414_VEN_SubsystemSignalManagement
% Assign test vectors for VEN system.   Called from InitFcn_VEN_Subsystem
% 19-Sep-2017       DA Gutz     Created
% Revisions


% Final assignment of vectors
V.fxven     = [0 100; ic.venstart.fxven   ic.venstart.fxven]';
if Z.data.use.fxven
    try
        V.fxven = DS.V.fxven;
    catch ERR
        error('DS.V.fxven not available.  Either correct or set Z.data.use.fxven=0;');
    end
end
V.useFxven  = Z.data.use.fxven*Z.data.enable;
V.xn25     = [0 100; ic.xn25   ic.xn25]';
if ~Z.data.use.xn25
    try
        V.xn25 = DS.V.xn25;
    catch ERR
        error('DS.V.xn25 not available.  Either correct or set Z.data.use.xn25=0;');
    end
end
V.useXn25   = Z.data.use.xn25*Z.data.enable;
V.wf36     = [0 100; Z.wf36   Z.wf36]';
if Z.data.use.wf36
    try
        V.wf36 = DS.V.wf36;
    catch ERR
        error('DS.V.wf36 not available.  Either correct or set Z.data.use.wf36=0;');
    end
end
V.useWf36   = Z.data.use.wf36*Z.data.enable;
V.mAven     = [0 100; ic.venstart.mA   ic.venstart.mA]';
if Z.data.use.mAven
    try
        if Z.data.SOURCE
            V.mAven = DS.V.mA_ven;
        else
            V.mAven = DS.V.mAven;
        end
    catch ERR
        error('DS.V.mAven not available.  Either correct or set Z.data.use.mAven=0;');
    end
end
V.usemAven  = Z.data.use.mAven*Z.data.enable;
V.dmAven        = V.mAven;
V.dmAven(:,2)   = V.mAven(:,2) - V.mAven(1,2);
if Z.data.use.a8
    try
        V.xven = Z.V.xven;
    catch ERR
        error('Z.V.xven not available.  Either correct or set Z.data.use.a8=0;');
    end
end
V.useXven   = Z.data.use.a8*Z.data.enable;
V.pr     = [0 100; ic.pr   ic.pr]';
if Z.data.use.pr
    error('DS.V.pr not available.  Either correct or set Z.data.use.pr=0;');
end
V.usePr     = Z.data.use.pr*Z.data.enable;
V.ps     = [0 100; ic.ps   ic.ps]';
if Z.data.use.ps
    try
        if Z.data.rigVal2000
            V.ps = DS.V.boost_r;
        else
            V.ps = DS.V.ps;
        end
    catch ERR
        error('DS.V.ps not available.  Either correct or set Z.data.use.ps=0;');
    end
end
V.usePs     = Z.data.use.ps*Z.data.enable;

