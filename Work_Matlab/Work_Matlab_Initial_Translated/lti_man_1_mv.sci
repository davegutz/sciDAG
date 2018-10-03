function [sys] = lti_man_1_mv(l,a,vol,spgr,%beta,c)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // function sys = man_1_mv(l, a, vol, spgr, beta, c);
    // MAN_1_MV.Build a one element line: momentum first, volume last.
    // Author:D. A. Gutz
    // Written:22-Jun-92
    // Revisions:19-Aug-92Simplify output arguments.
    //10-Dec-98Add damping, c.
    // Input:
    // lLine length, in.
    // aLine cross section, sqin.
    // volLine volume, cuin.
    // spgrFluid specific gravity.
    // betaFluid compressibility, psi.
    // cDamping, psi/in/sec, (OPTIONAL).
    // Differential I/O:
    // psInput # 1, supply pressure, psia.
    // wfdInput # 2, discharge flow, pph.
    // wfsOutput # 1, supply flow, pph.
    // pdOutput # 2, discharge pressure, psia.

    // Functions called:
    // vol_1Creates volume node.
    // mom_1Creates momenum slice.

    // Momentum slice.
    if %nargin==6 then
        m_1 = lti_mom_1(l,a,c);
    else
        m_1 = lti_mom_1(l,a);
    end;

    // Volume.
    // !! L.33: Unknown function lti_vol_1 not converted, original calling sequence used.
    v_1 = lti_vol_1(vol,%beta,spgr);

    // Put system into block diagonal form.
    temp = adjoin(make_pack(m_1),make_pack(v_1));

    // Inputs are ps and wfd.
    u = 14;

    // Outputs are wfs and pd.
    y = 12;

    // Connections.
    q = [22;31];

    // Form the system.
    [a,b,c,e] = unpack_ss(temp);
    // !! L.49: Matlab toolbox(es) function connect not converted, original calling sequence used
    [a,b,c,e] = connect(a,b,c,e,q,u,y);
endfunction
