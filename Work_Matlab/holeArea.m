function h = holeArea(x, d)
% Hole area
r       = d/2;
x       = max( (min(x, d-1e-16)), 1e-16);
frac    = 1 - x / r;
if frac>1e-16
    h    = atan( sqrt(1 - frac*frac) / frac);
else if(frac < -1e-16)
        h    = pi + atan( sqrt(1 - frac*frac) / frac);
    else
        h    = pi / 2;
    end
end
h    = r * r * h   -   (r - x) * sqrt(x * (2*r - x));
h = max(h, 1e-16);
return
