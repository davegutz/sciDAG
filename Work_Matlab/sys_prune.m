function sys = sys_prune(sys, out_idx, in_idx)
    sys.a = sys.a(:, :);
    sys.b = sys.b(:, in_idx);
    sys.c = sys.c(out_idx, :);
    sys.d = sys.d(out_idx, in_idx);
return
