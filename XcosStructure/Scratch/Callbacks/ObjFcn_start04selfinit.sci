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
    global W E X
    global GEO INI FP
    global verbose
    global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
    [n_particles, m] = size(particles);
    obj_score = zeros(n_particles,1);
    for i = 1:n_particles
        particle = particles(i,:);
        
        if verbose>2 then
            mprintf('ObjFcn_start04selfinit:  gain=%6.3f   tld1=%6.4f tlg1 = %6.4f tld2 = %6.4f tlg2 = %6.4f tldh = %6.4f tlgh = %6.4f\ n_particles', particle);
        end

        INI.vsv.x = max(min(particle(1), GEO.vsv.xmax), GEO.vsv.xmin);
        INI.p1so = particle(2);
        INI.p2 = particle(3);
        INI.mvtv.x = max(min(particle(4), GEO.mvtv.xmax), GEO.mvtv.xmin);
        INI.px = particle(5);
        INI.hs.x = max(min(particle(6), GEO.hs.xmax), GEO.hs.xmin);
        INI.mv.x = max(min(particle(7), GEO.mv.xmax), GEO.mv.xmin);

        bl_start_call = callblk_valve_a(bl_start, INI.ven_pd, 0, INI.p1so,..
                        INI.p1so, 0, INI.ven_ps, INI.vsv.x);
        INI.wf1v = -(bl_start_call.wfh+bl_start_call.wfvrs);              

        bl_mv_call = callblk_halfvalve_a(bl_mv, INI.p1so, INI.pr, INI.pr, ..
                        INI.ven_ps, INI.pamb, INI.p1so, INI.p2, INI.mv.x);
        INI.wf1mv = bl_mv_call.wfs;
        INI.wfmv = bl_mv_call.wfd;

        bl_mvtv_call = callblk_valve_a(bl_mvtv, INI.p2, INI.p3, 0,..
                        0, INI.prt, INI.px, INI.mvtv.x);
        INI.wfvx = bl_mvtv_call.wfvx;
        INI.wf3 = bl_mvtv_call.wfd;

        bl_hs_call = callblk_head_b(bl_hs, INI.px, INI.p1so, INI.p2, INI.hs.x);
        INI.wf1s = bl_hs_call.wfh;
        INI.wfx = bl_hs_call.wff;
        INI.wf3s = bl_hs_call.wfl;
        INI.wf2s = INI.wf3s;

        bl_a_tvb_call = callblk_cor_aptow(bl_a_tvb, GEO.a_tvb.ao,..
                         GEO.a_tvb.cd, INI.prt, INI.px);
        INI.wftvb = bl_a_tvb_call.wf;

        E.start = bl_start_call.uf;
        E.p1so = INI.wf1v - INI.wf1bias - INI.wf1mv - INI.wf1s;
        E.p2 = INI.wfmv + INI.wf2s - bl_mvtv_call.wfs;
        E.mvtv = bl_mvtv_call.uf;
        E.px = INI.wfx + INI.wfvx - INI.wftvb;
        E.hs = bl_hs_call.uf;
        E.p3 = INI.wf3 - INI.wf36;
        
        X.Score.start = W.start*E.start;
        X.Score.p1so = W.p1so*E.p1so;
        X.Score.p2 = W.p2*E.p2;
        X.Score.mvtv = W.mvtv*E.mvtv;
        X.Score.px = W.px*E.px;
        X.Score.hs = W.hs*E.hs;
        X.Score.p3 = W.p3*E.p3;
        
        // Hard limits
        if  particle(1)>GEO.vsv.xmax | particle(1)<GEO.vsv.xmin then
            X.Score.start = X.Score.start + 100;
        end
        if  particle(4)>GEO.mvtv.xmax | particle(4)<GEO.mvtv.xmin then
            X.Score.mvtv = X.Score.start + 100;
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
    end
endfunction
