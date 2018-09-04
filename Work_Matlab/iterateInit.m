function ice = iterateInit(xmax, xmin, eInit, str)
% function ice = iterateInit(xmax, xmin, eInit)
% Generic iteration initializer
% Inputs: 
%   xmax    Maximum value of x
%   min     Minimum value of x
%   eInit   Initial error
% Outputs:
%   ice     Initialized structure

ice.xmax    = xmax;
ice.xmin    = xmin;
ice.e       = eInit;
ice.ep      = eInit;
ice.xp      = ice.xmax;
ice.x       = ice.xmin;   % Do min and max first
ice.dx      = ice.x - ice.xp;
ice.de      = ice.e - ice.ep;
ice.count   = 0;
ice.str     = str;

return
