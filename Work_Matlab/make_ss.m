function out_ss = make_ss(in_pss)
% make_pack
% make old fashioned pack_ss format
% 22-Oct-2012   DA Gutz     Created
[a,b,c,d]   = unpack_ss(in_pss);
out_ss.a = a;
out_ss.b = b;
out_ss.c = c;
out_ss.d = d;
