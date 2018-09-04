function [zeta] = Mp2Zeta(Mp)
%   zeta	Mp	 MpdB
zeta2Mp = [0.001	500.00025	53.97940443
0.005	100.00125	40.00010857
0.01	50.00250019	33.9798344
0.02	25.0050015	27.9605377
0.03	16.67417173	24.4408854
0.04	12.51001202	21.94515454
0.05	10.01252349	20.01087096
0.06	8.348373955	18.43203789
0.07	7.160421719	17.09877202
0.08	6.270096515	15.94548452
0.09	5.578193172	14.929871
0.1	5.025189076	14.02304814
0.11	4.573206651	13.20441653
0.12	4.196994604	12.45876822
0.13	3.879071672	11.77455608
0.14	3.606951622	11.14280635
0.15	3.371478249	10.55640724
0.16	3.16578476	10.00962768
0.17	2.984620419	9.497782118
0.18	2.823901664	9.016991388
0.19	2.680404962	8.564008265
0.2	2.551551815	8.136087843
0.21	2.435255197	7.730889576
0.22	2.329807864	7.346402137
0.23	2.233799812	6.980885
0.24	2.146056363	6.632822478
0.25	2.065591118	6.300887149
0.26	1.991569763	5.983910479
0.27	1.923281923	5.680858993
0.28	1.860119048	5.390814799
0.29	1.801556873	5.112959539
0.3	1.747141395	4.846561069
0.31	1.696477552	4.590962346
0.32	1.649220043	4.345572081
0.33	1.605065806	4.109856852
0.34	1.563747831	3.883334407
0.35	1.525030036	3.665567948
0.36	1.488702996	3.456161248
0.37	1.454580369	3.254754439
0.38	1.422495888	3.061020395
0.39	1.392300822	2.874661594
0.4     1.363861814	2.6954074
0.41	1.337059042	2.523011709
0.42	1.311784651	2.357250899
0.43	1.287941396	2.197922044
0.44	1.265441486	2.044841366
0.45	1.24420558	1.897842894
0.46	1.224161917	1.756777297
0.47	1.205245571	1.621510885
0.48	1.187397793	1.491924749
0.49	1.170565452	1.367914041
0.5     1.154700538	1.249387366
0.51	1.139759746	1.136266292
0.52	1.1257041	1.028484961
0.53	1.112498644	0.925989807
0.54	1.100112168	0.828739365
0.55	1.088516982	0.736704177
0.56	1.077688727	0.649866798
0.57	1.067606218	0.568221893
0.58	1.058251328	0.491776442
0.59	1.049608894	0.420550043
0.6     1.041666667	0.354575339
0.61	1.034415282	0.293898556
0.62	1.02784827	0.238580185
0.63	1.021962101	0.188695813
0.64	1.016756262	0.144337119
0.65	1.012233377	0.105613068
0.66	1.008399371	0.072651325
0.67	1.00526369	0.045599922
0.68	1.002839569	0.024629232
0.69	1.001144381	0.009934287
0.7     1.00020006	0.001737525
0.707	1.000000046	3.96094E-07];
zeta = interp1(zeta2Mp(:,2), zeta2Mp(:,1), Mp, 'linear', 0);
