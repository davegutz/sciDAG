%% F414_Fuel_GEO_Renom
% Load GEO
% 13-Sep-2017   DA Gutz     Created


clear GEO
GEO.mv.xmin     = 0.;
try [GEO, GEOD, D]     = F414_Geometry(GEO, MOD, FP, Z, D);
catch ERR,
    [GEO, GEOD, D]     = F414_Geometry(GEO, MOD, FP, Z);
end
