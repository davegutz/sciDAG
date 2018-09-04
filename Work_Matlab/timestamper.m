function [ts] = timestamper()
% stamp the time in the output stream
% DA Gutz   14-Sep-10   10_MODEL_122:  streamlined scripts fr
%
% Inputs
% none


c = clock;
cm10 = floor(c(5)/10); cm1 = c(5) - 10*cm10; cs10 = floor(c(6)/10); cs1 = c(6) - 10*cs10;
ts = sprintf('Date: %d/%d/%d   Time: %d:%d%d:%d%2.1f\n', c(1), c(2), c(3), c(4), cm10, cm1, cs10, cs1);
