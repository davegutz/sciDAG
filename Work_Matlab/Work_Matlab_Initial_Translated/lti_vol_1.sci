function [sys] = lti_vol_1(vol,%beta,spgr)

// Output variables initialisation (not found in input variables)
sys=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// VOL1.Building block for a volume having two flow inputs.
//  Author:D. A. Gutz
//  Written:16-Apr-92
//  Revisions:None.

//  Input:
//  betaFluid bulk modulus, psi.
//  spgrFluid specific gravity.
//  volVolume, cuin.
//  wfsInput # 1, supply flow, pph.
//  wfdInput # 2, discharge flow, pph.

//  Output:
//  sysPacked system of Input and Output
//  pOutput # 1, volume pressure, psia.

// 

//  Derivative
dp = ((%beta/129.93948)/vol)/spgr;// Derivative, psi/sec.
a = 0;
b = mtlb_s(dp,dp);
c = 1;
e = 0;

//  Form the system.
endfunction
