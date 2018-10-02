function [sys] = lag(tau)

// Output variables initialisation (not found in input variables)
sys=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// LAG.Building block for simple first order lag.
//  Author:D. A. Gutz
//  Written:26-Jun-92
//  Revisions:19-Aug-92Simplify return arguments.
// 
//  Input:
//  tauTime constant, sec.

//  Differential IO:
//  xInput # 1.
//  yOutput # 1, lagged by tau.

//  Output:
//  sysPacked system of Input and Output.

//  Local:
//  qConnection matrix.
//  uInput matrix.
//  yOutput matrix.


//  States:
//  yOutput.

//  Functions called:
//  None.

//  Parameters.
//  None.

//  Partials.
//  None.

//  Connections and system construction.
a = -1/tau;
b = 1/tau;
c = 1;
e = 0;
endfunction
