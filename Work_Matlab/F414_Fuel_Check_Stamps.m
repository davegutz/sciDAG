%% F414_Fuel_Check_Stamps
% Check time stamps for changes
% 13-Sep-2017   DA Gutz     Created


if MOD.fullUp
    fnMat = sprintf('saves/init_%s_%s.mat', Z.case, char(Z.strS));
else
    fnMat = sprintf('saves/initVEN_Subsystem_%s_%s.mat', Z.case, char(Z.strS));
end
dfnMat          = getStamp(fnMat);
fnGEO_File      = sprintf('INPUTS/F414_Geometry.m');
dfnGEO_File     = getStamp(fnGEO_File);
fnTune_File     = sprintf('INPUTS/TUNE/STEADY/%s.m', char(Z.strS));
dfnTune_File    = getStamp(fnTune_File);
fnC_File        = sprintf('INPUTS/TUNE/CONDITION/%s.m', char(Z.strC));
dfnC_File       = getStamp(fnC_File);
dfnThisFile     = getStamp(fnThisFile);
