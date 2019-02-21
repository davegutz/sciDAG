// Copyright (C) 2019 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Feb 21, 2019    DA Gutz        Created
// 
// Copyright (C) 2012 - Optimization Command & Control Systems - Sebastien Salmon
// Copyright (C) 2010 - 2012 - M3M - UTBM - Sebastien Salmon
// Copyright (C) 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CC-BY-NC-SA
// http://creativecommons.org/licenses/by-nc-sa/2.0/

function [fopt,xopt]=myPSO_bsg_starcraft(varargin)

    function argin = argindefault ( rhs , vararglist , ivar , default )
        // Returns the value of the input argument #ivar.
        // If this argument was not provided, or was equal to the 
        // empty matrix, returns the default value.
        if ( rhs < ivar ) then
            argin = default
        else
            if ( vararglist(ivar) <> [] ) then
                argin = vararglist(ivar)
                if type(argin)==1 & size(argin,"*")==1 & default~=[]
                    argin = ones(default)*argin
                end
            else
                argin = default
            end
        end
    endfunction

    function y = PSO_evalobj(x,costf)
        objective_type = typeof(costf)
        if (objective_type=="function") then
            y=costf(x)
        else
            objective_f=costf(1)
            y=objective_f(x,costf(2:$))
        end
        N = size(x,"r")
        if ( or(size(y)<>[N 1]) ) then
            msg = gettext("%s: Wrong size for the output of the costf function.\n")
            error(msprintf(msg, "PSO_bsg_starcraft"))
        end
    endfunction

    [lhs, rhs] = argn();
    apifun_checkrhs ( "PSO_bsg_starcraft" , rhs , 3 : 12 )
    apifun_checklhs ( "PSO_bsg_starcraft" , lhs , [0 1 2] )
    //
    // Get input arguments
    costf = varargin(1)
    bounds = varargin(2)
    speed = varargin(3)
    itmax =         argindefault ( rhs , varargin , 4 , 400 )
    N =             argindefault ( rhs , varargin , 5 , 20 )
    weights =       argindefault ( rhs , varargin , 6 , [0.9;0.4] )
    c =             argindefault ( rhs , varargin , 7 , [0.7;1.47] )

    // Compute the dimension from the bounds
    D = size(bounds,"r")

    launchp =       argindefault ( rhs , varargin , 8 , 0.9 )
    speedf =        argindefault ( rhs , varargin , 9 , 2*ones(1,D) )
    nraptor =       argindefault ( rhs , varargin , 10 , 20 )
    verbose =       argindefault ( rhs , varargin , 11 , 0 )
    sol_initiale =  argindefault ( rhs , varargin , 12 , [] )
    //
    // Check input arguments
    //
    // Check type
    apifun_checktype ( "PSO_bsg_starcraft" , costf ,   "costf" ,  1 , [ "function" "list" ] )
    apifun_checktype ( "PSO_bsg_starcraft" , bounds ,  "bounds" ,  2 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , speed ,   "speed" ,  3 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , itmax ,   "itmax" ,  4 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , N ,       "N" ,  5 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , weights , "weights" ,  6 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , c ,       "c" ,  7 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , launchp ,  "launchp" ,  8 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , speedf ,  "speedf" ,  9 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , nraptor , "nraptor" ,  10 , "constant" )
    apifun_checktype ( "PSO_bsg_starcraft" , verbose ,       "verbose" ,  11 , [ "constant" "function" "list" ] )
    apifun_checktype ( "PSO_inertial" , sol_initiale ,       "sol_initiale" ,  12 , "constant" )
    //

    //
    // Check size
    apifun_checkdims ( "PSO_bsg_starcraft" , bounds , "bounds" , 2 , [D 2] )
    apifun_checkdims ( "PSO_bsg_starcraft" , speed ,  "speed" , 3 , [D 2] )
    apifun_checkscalar ( "PSO_bsg_starcraft" , itmax ,  "itmax" , 4 )
    apifun_checkscalar ( "PSO_bsg_starcraft" , N ,  "N" , 5 )
    apifun_checkvector ( "PSO_bsg_starcraft" , weights ,  "weights" , 6 , 2 )
    apifun_checkvector ( "PSO_bsg_starcraft" , c ,  "c" , 7 , 2 )
    apifun_checkscalar ( "PSO_bsg_starcraft" , launchp ,  "launchp" , 8 )
    apifun_checkdims ( "PSO_bsg_starcraft" , speedf ,  "speedf" , 9 , [1 D])
    apifun_checkscalar ( "PSO_bsg_starcraft" , nraptor ,  "nraptor" , 10 )
    if ( typeof(verbose)=="constant") then
        apifun_checkscalar ( "PSO_bsg_starcraft" , verbose ,  "verbose" , 11 )
    end
    if ( length(sol_initiale) > 0 ) then
        apifun_checkdims ( "PSO_inertial" , sol_initiale , "sol_initiale" , 12 , [1 D] )
    end
    //
    // Check content
    apifun_checkgreq ( "PSO_bsg_starcraft" , itmax ,  "itmax" ,  4 , 1 )
    apifun_checkgreq ( "PSO_bsg_starcraft" , N ,  "N" ,  5 , 1 )
    apifun_checkgreq ( "PSO_bsg_starcraft" , c ,  "c" ,  7 , 1e-308 )
    apifun_checkgreq ( "PSO_bsg_starcraft" , launchp ,  "launchp" ,  8 , 1e-308 )
    apifun_checkgreq ( "PSO_bsg_starcraft" , speedf ,  "speedf" ,  9 , 1e-308 )
    apifun_checkgreq ( "PSO_bsg_starcraft" , nraptor ,  "nraptor" ,  10 , 1e-308 )
    if ( typeof(verbose)=="constant") then
        apifun_checkgreq ( "PSO_bsg_starcraft" , verbose ,  "verbose" ,  11 , 0 )
    end
    //
    verbose_type = typeof(verbose)
    if verbose_type == 'list' then 
        verbose_f = verbose(1)
    end

    // Extract internal parameters
    borne_inf=bounds(:,1)'
    borne_sup=bounds(:,2)'
    vitesse_min=speed(:,1)'
    vitesse_max=speed(:,2)'
    c1=c(1)
    c2=c(2)
    wmax=weights(1)
    wmin=weights(2)
    //---------------------------------------------------
    // Allocation of memory ans first computations
    //---------------------------------------------------
    // computation of the weigth vector
    for i = 1:itmax,
        W(i) = wmax - (wmax - wmin)/itmax * i;
    end
    // computation of location and speed of particles
    for i = 1:D,
        //borne_sup(i)= 1;
        //borne_inf(i)= 0;
        x(1:N, i) = borne_inf(i) + grand(N, 1,'def') * (borne_sup(i) - borne_inf(i));// location
        //vitesse_min(i)=-0.3;
        //vitesse_max(i)=0.3;
        v(1:N, i) = vitesse_min(i) + (vitesse_max(i) - vitesse_min(i)) * grand(N, 1,'def');// speed
    end

    // inserting initial solution
    if length(sol_initiale)>0 then
        x(1,:)=sol_initiale;
    end

    // actual iteration number
    j = 1;
    //---------------------------------------------------
    // First evaluation of the costf function
    //---------------------------------------------------
    F(1:N, 1, j) = PSO_evalobj(x(1:N, :, j),costf);// mono-costf result
    //---------------------------------------------------
    // Search for the minimum of the swarm
    //---------------------------------------------------
    [C,I] = min(F(:, 1, j));
    //---------------------------------------------------
    // The first minimun is the global minimum 'cause first
    // iteration
    //---------------------------------------------------
    gbest(1, :, j) = x(I, :, j);
    gbestc(1, :, j) = x(I, :, j);
    v_gbestc(1, :, j) = v(I, :, j);
    for p = 1:N,
        G(p, :, j) = gbest(1, :, j);// creating a matrix of xopt, used for speed computation
    end
    //---------------------------------------------------
    // The first minimun is the best result 'cause first
    // iteration
    //---------------------------------------------------
    Fbest(1, 1, j) = F(I, 1, j);// global best
    Fbestc(1, 1, j) = F(I, 1, j);
    Fb(1, 1, j) = F(I, 1, j);// iteration best, used for comparison with global best
    //---------------------------------------------------
    // Each particle is her personnal best 'cause first
    // first iteration
    //---------------------------------------------------
    for i = 1:N,
        pbest(i, :, j) = x(i, :, j);
    end
    Fpbest(:, :, j) = F(:, :, j);
    //---------------------------------------------------
    // Speed and location computation for next iteration
    //---------------------------------------------------

    T=[];
    for i=1:D
        t = grand(2*N, 1,'def')
        T=[T t];
    end
    v1 = T(1:N,:) .* (pbest(:, :, j) - x(:, :, j));
    v2 = T(N+1:2*N,:) .* (G(:, :, j) - x(:, :, j));
    v(:, :, j + 1) = W(j) * v(:, :, j) + c1 * v1 + c2 * v2;// speed
    x(:, :, j + 1) = x(:, :, j) + v(:, :, j + 1);// location
    //---------------------------------------------------
    // Entering to the optimization loop
    //---------------------------------------------------
    while (j<itmax)
        //---------------------------------------------------
        // BSG Starcraft ability of the swarm - 1/10 chance
        // to enable capacity
        //---------------------------------------------------
        if verbose_type == 'constant' then 
            if verbose >= 1 then 
                sx = strcat(string(gbest(1, :, j)), ' ')
                mprintf('Iter #%d, Fopt=%e, xopt=[%s]\n', j, Fbest(1, 1, j), sx)

                // including graphics in verbose mode

                if j==1 then
                    //---------------------------------------------------
                    // Setting up graphics axis
                    //---------------------------------------------------
                    scf(1)
                    gcf()
                    xtitle("Objective function value vs Iteration")
                    axe_prop=gca()
                    axe_prop.x_label.text="Iteration number"
                    axe_prop.y_label.text="Objective function value"
                else

                    //---------------------------------------------------
                    // Plotting the Fbest curve to monitor optimization
                    //--------------------------------------------------- 

                    for count=1:j
                        fopt_draw(count)=Fbest(1,1,count);
                    end

                    if modulo(j,25)==0 then// resetting graphics

                        clf(1)
                        scf(1)
                        gcf()
                        xtitle("Objective function value vs Iteration")
                        axe_prop=gca()
                        axe_prop.x_label.text="Iteration number"
                        axe_prop.y_label.text="Objective function value"

                    else
                        scf(1)


                    end
                    plot(fopt_draw)
                    drawnow()
                end
                //end of graphics in verbose mode

                // in verbose mode results are saved for each iterations
                //try
                //    sleep(100)
                //    save('PSO_bsg_starcraft_save',"x","F","gbest","Fbest")
                //end
            end
            stop = %f
        elseif verbose_type == 'function' then 
            stop = verbose(j,Fbest(1, 1, j), gbest(1, :, j))
        elseif verbose_type == 'list' then 
            stop = verbose_f(j, Fbest(1, 1, j), gbest(1, :, j), verbose(2:$))
        end
        if stop then 
            break
        end
        j = j+1
        aleat = grand(1,1,'def')
        if aleat >= launchp | j == 2 then 
            if verbose_type == 'constant' then 
                if verbose >= 1 then 
                    mprintf('\tEnabling Starcraft Protoss carrier at iteration\n')
                end
            end
            // getting the leader of the previous iteration
            // this is the carrier
            x_carrier = gbestc(:, :, j - 1);
            F_carrier = Fbestc(:, :, j - 1);
            v_carrier = v_gbestc(:, :, j - 1);
            // creating some raptors to explore the space
            // for a quite long range from the carrier
            // speedf=2; // 2x faster than carrier
            // nraptor=20; // sending 20 raptors
            v_raptor = speedf .* abs(v_carrier);
            t=2*grand(nraptor, D,'def')-1
            x_raptor = x_carrier.*.ones(nraptor,1) + v_raptor.*.ones(nraptor,1) .* t
            // evaluating positions of the raptor
            if verbose_type == 'constant' then 
                if verbose >= 1 then 
                    mprintf('\tSending Raptors\n')
                end
            end
            F_raptor(1:nraptor) = PSO_evalobj(x_raptor(1:nraptor, :),costf);
            // Comparing performance of raptors to carrier
            [C,I] = min(F_raptor);
            if F_raptor(I) < Fbest(:, :, j - 1) then 
                gain = -1 * (F_carrier - F_raptor(I));
                if verbose_type == 'constant' then 
                    if verbose >= 1 then 
                        mprintf('\tGain =%e\n', gain)
                        mprintf('\tEnabling FTL jump\n')
                    end
                end
                // jumping the swarm conserving geometry
                jump_vector = x_raptor(I, :) - x_carrier;
                for i = 1:N,
                    x(i, :, j) = x(i, :, j - 1) + jump_vector;
                end
            else 
                if verbose_type == 'constant' then 
                    if verbose >= 1 then 
                        mprintf('\tFTL jump not required\n')
                    end
                end
            end
            // evaluation of the jumped swarm
            F(1:N, 1, j) = PSO_evalobj(x(1:N, :, j),costf);
        else 
            //---------------------------------------------------
            // Evaluation of the costf function
            //---------------------------------------------------
            F(1:N, 1, j) = PSO_evalobj(x(1:N, :, j),costf);
        end// end for bsg starcraft ability
        //---------------------------------------------------
        // Search for the minimum of the swarm
        //---------------------------------------------------
        [C,I] = min(F(:, :, j));
        //---------------------------------------------------
        // Searching for global minimum
        //---------------------------------------------------
        gbest(1, :, j) = x(I, :, j);// hypothesis : this iteration is better than last one
        gbestc(1, :, j) = x(I, :, j);
        v_gbestc(1, :, j) = v(I, :, j);
        Fb(1, 1, j) = F(I, 1, j);// looking for the iteration best result
        Fbestc(1, 1, j) = F(I, 1, j);
        Fbest(1, :, j) = Fb(1, :, j);// fopt is the iteration best result
        if Fbest(1, 1, j) >= Fbest(1, 1, j - 1) then 
            // check if actual fopt is not better than the previous one
            gbest(1, :, j) = gbest(1, :, j - 1);// replacing with the good xopt
            Fbest(1, :, j) = Fbest(1, :, j - 1);// A new fopt has not be found this time
        end
        // creating a matrix of xopt, used for speed computation
        G(1:N, :, j) = gbest(1, :, j).*.ones(N,1)
        //---------------------------------------------------
        // Computation of the new personnal best
        //---------------------------------------------------
        ilow = find(F(1:N, 1, j) < Fpbest(1:N, :, j - 1))
        ihigh = find(F(1:N, 1, j) >= Fpbest(1:N, :, j - 1))
        pbest_old = pbest(1:N,1:D, j - 1);
        Fpbest_old = Fpbest(1:N,:, j - 1);
        if ( ilow <> [] ) then
            pbest(ilow,1:D, j) = x(ilow,1:D, j);
            Fpbest(ilow, :, j) = F(ilow, :, j);
        end
        if ( ihigh <> []) then
            pbest(ihigh,1:D, j) = pbest_old(ihigh,1:D);
            Fpbest(ihigh, :, j) = Fpbest_old(ihigh, :);
        end

        //---------------------------------------------------
        // Re-computation of fopt for reliability test
        //---------------------------------------------------
        Fbest(:, :, j) = PSO_evalobj(gbest(1, :, j),costf);
        //---------------------------------------------------
        // Speed and location computation for next iteration
        //---------------------------------------------------

        T=[];
        for i=1:D
            t = grand(2*N, 1,'def')
            T=[T t];
        end
        v1 = T(1:N,:) .* (pbest(:, :, j) - x(:, :, j));
        v2 = T(N+1:2*N,:) .* (G(:, :, j) - x(:, :, j));
        v(:, :, j + 1) = W(j) * v(:, :, j) + c1 * v1 + c2 * v2;// speed
        x(:, :, j + 1) = x(:, :, j) + v(:, :, j + 1);// location
    end
    fopt = Fbest(1,1,$)
    xopt = gbest(1,1:D,$)
endfunction

