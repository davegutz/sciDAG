function [P, D, lastFig]= plot_Fuel(bdroot, titleName, E, lastFig, swHcopy)
% function [D, lastFig} = plot_FuelSystem(ifcname, venname, titlename, lastFig, swHcopy)
% plot full      fuel system
% 16-Jun-2016   DA Gutz     Created
% Plot cdf file reading
% Inputs:
% ifcname       Name ifc.dat
% venname       Name ven.dat
% titlename     Name .titl
% lastFig       last used figure number (starts with lastFig+1)[0]
% swHcopy       hardcopy command [0]
% Outputs:
% D             The data
% lastFig   The number of the latest figure
% Sample usage:  > [D, lastFig]= plot_FuelSystem('opLine06_INS6.ifc.dat', 'opLine06_INS6.ven.dat', 'opLine06_INS6.titl', 0, 0)
% plot 0 and make hardcopies of the plots for recorP.

