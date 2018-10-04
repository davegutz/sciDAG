function [sys] = sys_prune(sys,out_idx,in_idx,st_idx)

// Number of arguments in function call
[%nargout,%nargin] = argn(0)

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

if %nargin<4 then
  st_idx = ":";
end;
//    sys.a = sys.a(st_idx, st_idx);
//    sys.b = sys.b(st_idx, in_idx);
//    sys.c = sys.c(out_idx, st_idx);
//    sys.d = sys.d(out_idx, in_idx);
//    sys.stname = sys.stname(st_idx);
// ! L.10: mtlb(resume) can be replaced by resume() or resume whether resume is an M-file or not.
mtlb(resume)
endfunction
