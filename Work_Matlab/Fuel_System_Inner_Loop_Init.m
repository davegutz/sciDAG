%% Fuel_System_Inner_Loop_Init
%
%  Fuel System Inner Loop Control Initialization
%  Manxue Lu 01/17/2013
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PPH & Stroke Conversion
FMV.PPH  = [0 232 292 354 381 454 526 605 691 781 882 988 1102 1223 1350 ...
            1485 1626 1773 1926 2088 2257 2432 2614 2801 2996 3200 3419 3653 ...
            3980 4194 4501 4833 5184 5567 5971 6407 6862 7343 7858 8398 8968 ...
            9563 10210 10877 11560 12286 13057 13858 14737 15640 16507 17288 17871];

ABTFMV.PPH  = [0 185 289 385 439 609 830 1089 1381 1711 2074 2483 2918 3403 ...
            3916 4465 5050 5668 6327 7022 7751 8514 9319 10156 11019 11939 12888 13869 ...            
            14880 15955 17061 18220 19468 20790 22198 23671 25175 26731 28353 30013 31705 ...
            33433 35141 37000 38783 40654 42635 44638 46858 49087 51357 53672 55725];
            
            
ABPFMV.PPH  = [0 164 188 229 243 278 314 351 388 426 464 503 541 581 619 658 ...
               697 736 775 814 853 893 932 972 1011 1051 1090 1131 ...
               1171 1212 1252 1295 1336 1379 1419 1463 1506 1550 1591 1636 1679 ...
               1725 1768 1813 1858 1904 1949 1995 2042 2088 2137 2184 2224];
                                       
FMV.STRK = [-0.02 0 0.008 0.016 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 ...
            0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 ...
            0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 ...
            0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5];
        
% Single Loop COntroller Setting
Tctrl  = 0.01;
Tminor = 0.01;


% Variable Structure - Core FMV
	ILC_WFM.tldFF1 = 0.088;
	ILC_WFM.TlgFF1 = 0.12;
	ILC_WFM.tldFF2 = 0;
	ILC_WFM.TlgFF2 = 0;       
	ILC_WFM.tldFB = 0.02;
	ILC_WFM.TlgFB = 0.008;      
	ILC_WFM.Kint = 0;
	ILC_WFM.IntLimMax = 0;
	ILC_WFM.IntLimMin = 0;
    ILC_WFM.PosRefRtMax = (1e+10);
	ILC_WFM.PosRefRtMin = -(1e+10);
	ILC_WFM.TlgPosRefRt = 0;
    ILC_WFM.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_WFM.PosRefRtThresMin = -(1e+10);         % %stroke/s      
	ILC_WFM.x_LGSchedV1 = [1 1000];
	ILC_WFM.x_LGSchedV2 = [1, 200];
	ILC_WFM.y_LGSched = [14.88 14.88; 14.88 14.88];
    ILC_WFM.LpGKicPerm = 0;
    ILC_WFM.KicGscalar = 1;
    ILC_WFM.x_TMNullShiftV1 = [1, 200];  % load
	ILC_WFM.y_TMNullShift = [0 0];
    ILC_WFM.LPGain_Adj = 1;

	ACT_WFM.TMNull = 20;
	ACT_WFM.TMCMax = 60;
	ACT_WFM.TMCMin = -60;
	ACT_WFM.TMC_FixedPos = 0;           % N25_ISOCH_TM_DEM
    
    WFM_FixedPosCmd = 0;            % FA_N25_ISOCH
    WFM_TMDiscntCmd = 0;            % WFM_TM (B)

% Variable Structure - ABT FMV
    ILC_WFABT.tldFF1 = 0.088;
	ILC_WFABT.TlgFF1 = 0.14;    
	ILC_WFABT.tldFF2 = 0;
	ILC_WFABT.TlgFF2 = 0;     
	ILC_WFABT.tldFB = 0.022;
	ILC_WFABT.TlgFB = 0.008;   
	ILC_WFABT.Kint = 0;
	ILC_WFABT.IntLimMax = 0;
	ILC_WFABT.IntLimMin = 0;
    ILC_WFABT.PosRefRtMax = (1e+10);
	ILC_WFABT.PosRefRtMin = -(1e+10);
	ILC_WFABT.TlgPosRefRt = 0;
    ILC_WFABT.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_WFABT.PosRefRtThresMin = -(1e+10);         % %stroke/s    
	ILC_WFABT.x_LGSchedV1 = [1 1000];
	ILC_WFABT.x_LGSchedV2 = [1, 200];
	ILC_WFABT.y_LGSched = [12.74 12.74; 12.74 12.74];
    ILC_WFABT.LpGKicPerm = 0;
    ILC_WFABT.KicGscalar = 1;
    ILC_WFABT.x_TMNullShiftV1 = [1, 200];  % load
	ILC_WFABT.y_TMNullShift = [0 0];
    ILC_WFABT.LPGain_Adj = 1;
    
	ACT_WFABT.TMNull = 15;
	ACT_WFABT.TMCMax = 75;
	ACT_WFABT.TMCMin = -45;
	ACT_WFABT.TMC_FixedPos = 0;           % na
    
    WFABT_FixedPosCmd = 0;            % na
    WFABT_TMDiscntCmd = 0;            % WFRT_TM (B)
            
% Variable Structure - ABP FMV
    ILC_WFABP.tldFF1 = 0.088;
	ILC_WFABP.TlgFF1 = 0.12;   
	ILC_WFABP.tldFF2 = 0;
	ILC_WFABP.TlgFF2 = 0;    
	ILC_WFABP.tldFB = 0.018;
	ILC_WFABP.TlgFB = 0.008;     
	ILC_WFABP.Kint = 0;
	ILC_WFABP.IntLimMax = 0;
	ILC_WFABP.IntLimMin = 0;
    ILC_WFABP.PosRefRtMax = (1e+10);
	ILC_WFABP.PosRefRtMin = -(1e+10);
	ILC_WFABP.TlgPosRefRt = 0;
    ILC_WFABP.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_WFABP.PosRefRtThresMin = -(1e+10);         % %stroke/s
	ILC_WFABP.x_LGSchedV1 = [1 1000];
	ILC_WFABP.x_LGSchedV2 = [1, 200];
	ILC_WFABP.y_LGSched = [19.16 19.16; 19.16 19.16];
    ILC_WFABP.LpGKicPerm = 0;
    ILC_WFABP.KicGscalar = 1;
    ILC_WFABP.x_TMNullShiftV1 = [1, 200];  % load
	ILC_WFABP.y_TMNullShift = [0 0];
    ILC_WFABP.LPGain_Adj = 1;
    
	ACT_WFABP.TMNull = 15;
	ACT_WFABP.TMCMax = 70;
	ACT_WFABP.TMCMin = -50;
	ACT_WFABP.TMC_FixedPos = 0;           % N25_ISOCH_TM_DEM
    
    WFABP_FixedPosCmd = 0;            % na
    WFABP_TMDiscntCmd = 0;            % WFRP_TM (B) 
    
% Variable Structure - VEN
    ILC_VEN.tldFF1 = 0.02;
	ILC_VEN.TlgFF1 = 0.008;   
% 	ILC_VEN.tldFF2 = 0;
% 	ILC_VEN.TlgFF2 = 0;     
% 	ILC_VEN.tldFB = 0;
% 	ILC_VEN.TlgFB = 0;    
	ILC_VEN.tldFF2 = 0.02;  % dag 9/16/2013
	ILC_VEN.TlgFF2 = 0.02;       % dag 9/16/2013
	ILC_VEN.tldFB = 0.02;  % dag 9/16/2013
	ILC_VEN.TlgFB = 0.02;      % dag 9/16/2013
	ILC_VEN.Kint = 0;
	ILC_VEN.IntLimMax = 0;
	ILC_VEN.IntLimMin = 0;
    ILC_VEN.PosRefRtMax = (1e+10);
	ILC_VEN.PosRefRtMin = -(1e+10);
	ILC_VEN.TlgPosRefRt = 0.03;
    ILC_VEN.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_VEN.PosRefRtThresMin = -(1e+10);         % %stroke/s
    %  Bad schedules  DAG 9/16/2013
    % 	ILC_VEN.x_LGSchedV1 = [24.4 70];
% 	ILC_VEN.x_LGSchedV2 = [1.5 8.5 9.2 14];         % load
% 	ILC_VEN.y_LGSched = [0 0 0 0; 0 0 1 1];         % Gain = 0 foe low load region? 
    ILC_VEN.x_LGSchedV1 = [ -10 10  20  30  40  50];
	ILC_VEN.x_LGSchedV2 = [ 0 10000 20000 30000];         % load
	ILC_VEN.y_LGSched   = [ 5.5 5.5 5.5 5.5 5.5 5.5;
                            5.5 5.5 3.5 3.5 3.5 3.5;
                            5.5 5.5 5.5 3.0 3.0 3.0;
                            5.5 5.5 5.5 5.5 2.5 2.5;]';
    ILC_VEN.LpGKicPerm = 0;
    ILC_VEN.KicGscalar = 1;
    %  Bad schedules  DAG 9/16/2013
%     ILC_VEN.x_TMNullShiftV1 = [9.72 14.696 33];     % load
% 	ILC_VEN.y_TMNullShift = [3 6 15];
    ILC_VEN.x_TMNullShiftV1 = [ -2000   0       10000   20000   30000   33500   35000   36000];
	ILC_VEN.y_TMNullShift   = [ 26.04   24.5    22.5    22.1    21      19      17      15];
    ILC_VEN.LPGain_Adj = 1;   
    
	ACT_VEN.TMNull = 0;
	ACT_VEN.TMCMax = 70;
	ACT_VEN.TMCMin = -25;
	ACT_VEN.TMC_FixedPos = -100;        % na
    
    VEN_FixedPosCmd = 0;            % AB_Lock (B)
    VEN_TMDiscntCmd = 0;            % !A8_TM (B)
    
% Variable Structure - FVG
    ILC_FVG.tldFF1 = 0.018;
	ILC_FVG.TlgFF1 = 0.0075;     
	ILC_FVG.tldFF2 = 0;
	ILC_FVG.TlgFF2 = 0;     
	ILC_FVG.tldFB = 0;
	ILC_FVG.TlgFB = 0;     
	ILC_FVG.Kint = 0;
	ILC_FVG.IntLimMax = 0;
	ILC_FVG.IntLimMin = 0;
	ILC_FVG.PosRefRtMax = 200;
	ILC_FVG.PosRefRtMin = -200;
	ILC_FVG.TlgPosRefRt = 0.025;
	ILC_FVG.PosRefRtThresMax = 45;          % %stroke/s
	ILC_FVG.PosRefRtThresMin = -45;         % %stroke/s
	ILC_FVG.x_LGSchedV1 = [1 1000];
	ILC_FVG.x_LGSchedV2 = [1, 200];         % load
	ILC_FVG.y_LGSched = [-4.59 -4.59; -4.59 -4.59]; % mA/%stroke
    ILC_FVG.LpGKicPerm = 0;
    ILC_FVG.KicGscalar = 1.45;
    ILC_FVG.x_TMNullShiftV1 = [1, 200];     % load
	ILC_FVG.y_TMNullShift = [0 0];          % mA
    ILC_FVG.LPGain_Adj = 1;   
    
	ACT_FVG.TMNull = 15;
	ACT_FVG.TMCMax = 75;
	ACT_FVG.TMCMin = -45;
	ACT_FVG.TMC_FixedPos = 0;           % na
    
    FVG_FixedPosCmd = 0;            % na
    FVG_TMDiscntCmd = 0;            % FVG_TM (B)    
    
% Variable Structure - CVG
    ILC_CVG.tldFF1 = 0.018;
	ILC_CVG.TlgFF1 = 0.0075;  
	ILC_CVG.tldFF2 = 0;
	ILC_CVG.TlgFF2 = 0;   
	ILC_CVG.tldFB = 0;
	ILC_CVG.TlgFB = 0;  
	ILC_CVG.Kint = 0;
	ILC_CVG.IntLimMax = 0;
	ILC_CVG.IntLimMin = 0;
	ILC_CVG.PosRefRtMax = 150;
	ILC_CVG.PosRefRtMin = -150;
	ILC_CVG.TlgPosRefRt = 0.025;
	ILC_CVG.PosRefRtThresMax = 30;          % %stroke/s
	ILC_CVG.PosRefRtThresMin = -30;         % %stroke/s
	ILC_CVG.x_LGSchedV1 = [1 1000];
	ILC_CVG.x_LGSchedV2 = [1, 200];         % load
	ILC_CVG.y_LGSched = [-3.388 -3.388; -3.388 -3.388];  % mA/%stroke
    ILC_CVG.LpGKicPerm = 0;
    ILC_CVG.KicGscalar = 1.6;
    ILC_CVG.x_TMNullShiftV1 = [1, 200];     % load
	ILC_CVG.y_TMNullShift = [0 0];
    ILC_CVG.LPGain_Adj = 1;   
    

	ACT_CVG.TMNull = 20;
	ACT_CVG.TMCMax = 80;
	ACT_CVG.TMCMin = -40;
	ACT_CVG.TMC_FixedPos = 0;       % na
    
    CVG_FixedPosCmd = 0;            % na
    CVG_TMDiscntCmd = 0;            % CVG_TM (B)        

