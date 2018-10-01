function var = default(varS, valS)
    // function var = default(varS, valS)
    // If varS does not exists initialize it to valS otherwise leave it alone.
    // Example:
    // clear myPar;   myPar = default('myPar', 22); disp(myPar); myPar = default('myPar', 23); disp(myPar);
    // expected result:
    // 22
    // 
    // 22
    //
    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // 15-Oct-2015   DA Gutz         Created
    // 
    ierr = execstr(['testVal =' + varS + ';'], 'errcatch');
    if ~ierr
        var = return(evstr(varS));
    else
        var = return(valS);
    end;
endfunction
