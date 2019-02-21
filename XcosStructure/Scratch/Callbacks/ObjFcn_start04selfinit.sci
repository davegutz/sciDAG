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
// Feb 20, 2019    DA Gutz        Created
// 
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
// Feb 20, 2019    DA Gutz        Created
// 
// Function called by PSO to determine cost (obj_score) of potential
// design (particle in particles)
// function obj_score = allServo_PSO_Obj(particles)
function obj_score = ObjFcn_start04selfinit(particles)
    global W E X PSO
    global GEO INI FP
    global verbose
    global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
    [n_particles, m] = size(particles);
    obj_score = zeros(n_particles,1);
    for i = 1:n_particles
        particle = particles(i,:);

        vsv_x = max(min(particle(1), GEO.vsv.xmax), GEO.vsv.xmin);
        p1so = particle(2);
        p2 = particle(3);
        mvtv_x = max(min(particle(4), GEO.mvtv.xmax), GEO.mvtv.xmin);
        px = particle(5);
        hs_x = max(min(particle(6), GEO.hs.xmax), GEO.hs.xmin);
        mv_x = max(min(particle(7), GEO.mv.xmax), GEO.mv.xmin);

        bl_start_call = callblk_valve_a(bl_start, INI.ven_pd, 0, p1so,..
                        p1so, 0, INI.ven_ps, vsv_x);
        wf1v = -(bl_start_call.wfh+bl_start_call.wfvrs);              

        bl_mv_call = callblk_halfvalve_a(bl_mv, p1so, INI.pr, INI.pr, ..
                        INI.ven_ps, INI.pamb, p1so, p2, mv_x);
        wf1mv = bl_mv_call.wfs;
        wfmv = bl_mv_call.wfd;

        bl_mvtv_call = callblk_valve_a(bl_mvtv, p2, p3, 0,..
                        0, INI.prt, px, mvtv_x);
        wfvx = bl_mvtv_call.wfvx;
        wf3 = bl_mvtv_call.wfd;

        bl_hs_call = callblk_head_b(bl_hs, px, p1so, p2, hs_x);
        wf1s = bl_hs_call.wfh;
        wfx = bl_hs_call.wff;
        wf3s = bl_hs_call.wfl;
        wf2s = INI.wf3s;

        bl_a_tvb_call = callblk_cor_aptow(bl_a_tvb, GEO.a_tvb.ao,..
                         GEO.a_tvb.cd, INI.prt, px);
        wftvb = bl_a_tvb_call.wf;

        E.start = bl_start_call.uf;
        E.p1so = wf1v - INI.wf1bias - wf1mv - wf1s;
        E.p2 = wfmv + wf2s - bl_mvtv_call.wfs;
        E.mvtv = bl_mvtv_call.uf;
        E.px = wfx + wfvx - wftvb;
        E.hs = bl_hs_call.uf;
        E.p3 = wf3 - INI.wf36;
        
        X.Score.start = W.start*abs(E.start);
        X.Score.p1so = W.p1so*abs(E.p1so);
        X.Score.p2 = W.p2*abs(E.p2);
        X.Score.mvtv = W.mvtv*abs(E.mvtv);
        X.Score.px = W.px*abs(E.px);
        X.Score.hs = W.hs*abs(E.hs);
        X.Score.p3 = W.p3*abs(E.p3);
        
        // Hard limits
        if  particle(1)>GEO.vsv.xmax | particle(1)<GEO.vsv.xmin then
            X.Score.start = X.Score.start + 100;
        end
        if  particle(4)>GEO.mvtv.xmax | particle(4)<GEO.mvtv.xmin then
            X.Score.mvtv = X.Score.mvtv + 100;
        end
        if  particle(6)>GEO.hs.xmax | particle(6)<GEO.hs.xmin then
            X.Score.hs = X.Score.hs + 100;
        end
        if  particle(7)>GEO.mv.xmax | particle(7)<GEO.mv.xmin then
            X.Score.p3 = X.Score.p3 + 100;
        end

        obj_score(i) = X.Score.start + X.Score.p1so + X.Score.p2 + ..
                    X.Score.mvtv + X.Score.px + X.Score.hs + X.Score.p3;
        X.Score.total = obj_score(i);
        X.ScoreN.start = X.Score.start/X.Score.total;
        X.ScoreN.p1so = X.Score.p1so/X.Score.total;
        X.ScoreN.p2 = X.Score.p2/X.Score.total;
        X.ScoreN.mvtv = X.Score.mvtv/X.Score.total;
        X.ScoreN.px = X.Score.px/X.Score.total;
        X.ScoreN.hs = X.Score.hs/X.Score.total;
        X.ScoreN.p3 = X.Score.p3/X.Score.total;
        X.casestr = msprintf('Init    %5.4f, %5.2f, %5.2f, %5.4f, %5.2f, %5.2f, %5.4f,: %5.4f, %5.4f, %5.4f, %5.4f, %5.4f, %5.4f, %5.4f', particle(1), particle(2), particle(3), particle(4), particle(5), particle(6), particle(7), E.start, E.p1so, E.p2, E.mvtv, E.px, E.hs, E.p3);
        if verbose>2 then
            mprintf('ObjFcn_start04selfinit(%ld): score=%10.4f,  vsv_x=%6.3f p1so=%6.4f p2= %6.4f mvtv_x= %6.4f px=%6.4f hs_x=%6.4f mv_x= %6.4f\n', i, obj_score(i), particle);
        end
    end
endfunction
