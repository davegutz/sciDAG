function BoInfo = BusObjects()
% BUSOBJECTS returns a Bo array containing bus object information 
% 
% The order of bus element attributes is as follows:
%   ElementName, Dimensions, DataType, SampleTime, Complexity, SamplingMode 
BoInfo = { ...
    { ...
     'FuelPropertyBus', ...
'', ... 
'Bus to support fuel properties', { ...
    {'sg',    1, 'double', -1, 'real', 'Sample'}; ...
    {'beta',  1, 'double', -1, 'real', 'Sample'}; ...
    {'kvis',  1, 'double', -1, 'real', 'Sample'}; ...
    {'dwdc',  1, 'double', -1, 'real', 'Sample'}; ...
    {'avis',  1, 'double', -1, 'real', 'Sample'}; ...
    } ...
    } ...
    { ...
     'PumpCurveBus', ...
'', ... 
'Bus to support pump curves', { ...
    {'cd',  1, 'double', -1, 'real', 'Sample'}; ...
    {'cf',  1, 'double', -1, 'real', 'Sample'}; ...
    {'cn',  1, 'double', -1, 'real', 'Sample'}; ...
    {'cs',  1, 'double', -1, 'real', 'Sample'}; ...
    {'ct',  1, 'double', -1, 'real', 'Sample'}; ...
    } ...
    } ...
    { ...
     'triValveWin', ...
'', ... 
'Bus to support triValve geometry', { ...
    {'CLEAR',  1, 'double', -1, 'real', 'Sample'}; ...
    {'DBIAS',  1, 'double', -1, 'real', 'Sample'}; ...
    {'DORIFD',  1, 'double', -1, 'real', 'Sample'}; ...
    {'DORIFS',  1, 'double', -1, 'real', 'Sample'}; ...
    {'HOLES',  1, 'double', -1, 'real', 'Sample'}; ...
    {'SBIAS',  1, 'double', -1, 'real', 'Sample'}; ...
    {'UNDERLAP',  1, 'double', -1, 'real', 'Sample'}; ...
    {'WD',  1, 'double', -1, 'real', 'Sample'}; ...
    {'WS',  1, 'double', -1, 'real', 'Sample'}; ...
    } ...
    } ...
    }';
% Create bus objects in the MATLAB base workspace
Simulink.Bus.cellToObject(BoInfo)

