function Q = wf2q(Wf, SG)
% Q = wf2q(Wf, SG)
% Flow conversion

% 29-Oct-2012   DA Gutz     Created


Q   = Wf / (SG * 0.0360943 * 3600);
% write_opLine_lti_F414_FuelSystemCSV
% Write CSV results files full F414 fuel system
% 7-Jan-2013   DA Gutz     Created



%%Write
if ~exist('./figures'), mkdir('figures'), end
if ~exist('./figures/suppliers'), mkdir('figures/suppliers'), end
filenameHON = sprintf('./figures/suppliers/%s_HON.csv', testCase);
filenameSUN = sprintf('./figures/suppliers/%s_SUN.csv', testCase);
filenameGE  = sprintf('./figures/suppliers/%s_GE.csv', testCase);
filenameALL = sprintf('./figures/%s_ALL.csv', testCase);
defineXref
headerFile

filename = filenameHON; xref = xrefHON;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVHON, M.messageCSVHON] = fopen(filename, 'w+');
    if -1==M.fidCSVHON, error(M.messageCSVHON), end
    fprintf(M.fidCSVHON, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVHON, '%s,', xref{i, 2});
    end
    fprintf(M.fidCSVHON, '\n');
end
fprintf(M.fidCSVHON, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVHON, '%13.6g,', eval(xref{i,1}));
end
fprintf(M.fidCSVHON, '\n');


filename = filenameSUN; xref = xrefSUN;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVSUN, M.messageCSVSUN] = fopen(filename, 'w+');
    if -1==M.fidCSVSUN, error(M.messageCSVSUN), end
    fprintf(M.fidCSVSUN, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVSUN, '%s,', xref{i, 2});
    end
    fprintf(M.fidCSVSUN, '\n');
end
fprintf(M.fidCSVSUN, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVSUN, '%13.6g,', eval(xref{i,1}));
end
fprintf(M.fidCSVSUN, '\n');

filename = filenameGE; xref = xrefGE;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVGE, M.messageCSVGE] = fopen(filename, 'w+');
    if -1==M.fidCSVGE, error(M.messageCSVGE), end
    fprintf(M.fidCSVGE, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVGE, '%s,', xref{i, 2});
    end
    fprintf(M.fidCSVGE, '\n');
end
fprintf(M.fidCSVGE, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVGE, '%13.6g,', eval(xref{i,1}));
end
fprintf(M.fidCSVGE, '\n');

filename = filenameALL; xref = xrefALL;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVALL, M.messageCSVALL] = fopen(filename, 'w+');
    if -1==M.fidCSVALL, error(M.messageCSVALL), end
    fprintf(M.fidCSVALL, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVALL, '%s,', xref{i, 2});
    end
%     fprintf(M.fidCSVALL, 'fgOLTV, fpOLTV, GmOLTV, PmOLTV, fgOLVEN, fpOLVEN, GmOLVEN, PmOLVEN, fnCLMFP, zetaCLMFP,');
    fprintf(M.fidCSVALL, 'fgOLTV, fpOLTV, GmOLTV, PmOLTV, fnCLMFP, zetaCLMFP,');
    fprintf(M.fidCSVALL, '\n');
end
fprintf(M.fidCSVALL, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVALL, '%13.6g,', eval(xref{i,1}));
end
if L.swComparePumps
%     fprintf(M.fidCSVALL, '%13.6g,', LRES(nCases).pump.fg, LRES(nCases).pump.fp, LRES(nCases).pump.Gm, LRES(nCases).pump.Pm);
else
%     fprintf(M.fidCSVALL, '%13.6g,', LRES(nCases).oltv.fg, LRES(nCases).oltv.fp, LRES(nCases).oltv.Gm, LRES(nCases).oltv.Pm, LRES(nCases).olven.fg, LRES(nCases).olven.fp, LRES(nCases).olven.Gm, LRES(nCases).olven.Pm, LRES(nCases).clmfp.fn, LRES(nCases).clmfp.zeta);
    fprintf(M.fidCSVALL, '%13.6g,', LRES(nCases).oltv.fg, LRES(nCases).oltv.fp, LRES(nCases).oltv.Gm, LRES(nCases).oltv.Pm, LRES(nCases).clmfp.fn, LRES(nCases).clmfp.zeta);
end
fprintf(M.fidCSVALL, '\n');
