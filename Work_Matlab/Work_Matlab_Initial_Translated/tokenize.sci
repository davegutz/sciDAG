function [nTok,%tokens,cTokens] = tokenize(targ,delims)

// Output variables initialisation (not found in input variables)
nTok=[];
%tokens=[];
cTokens=[];

// Number of arguments in function call
[%nargout,%nargin] = argn(0)

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// function [nTok, tokens, ctokens] = tokenize(targ, delims)
// tokenize using optional delims (default is Matlab default:  ''help strtok'').  Return number, cell array result, and the ctokens
// stripped (the first ctokens elemement preceeds the first tokens element
// on reconstruction
tokens = makecell([0,0]);
nTok = 0;
ncTok = 0;
rem = targ;
cTokens = makecell([0,0]);
while %t
  oldRem = rem;
  oldLen = max(size(oldRem));
  col1 = mtlb_strfind(oldRem,rem);
  if %nargin==2 then
    // !! L.16: Matlab function strtok not yet converted, original calling sequence used.
    // L.16: (Warning name conflict: function name changed from strtok to %strtok).
    [str,rem] = %strtok(oldRem,delims);
  else
    // !! L.18: Matlab function strtok not yet converted, original calling sequence used.
    // L.18: (Warning name conflict: function name changed from strtok to %strtok).
    [str,rem] = %strtok(oldRem);
  end;
  cLen = max(size(rem))-1;
  col2 = mtlb_strfind(oldRem,rem);
  col3 = mtlb_strfind(oldRem,str);
  //     fprintf(''oldRem=%s| rem=%s| str=%s| col1=%ld| col2=%ld| cLen=%ld| col3=%ld|\n'', oldRem, rem, str, col1, col2, cLen, col3);
  if ncTok==0 then
    if mtlb_logic(col3,">",1) then
      // !! L.26: Unknown function mtlb_s not converted, original calling sequence used.
      // !! L.26: Unknown function mtlb_imp not converted, original calling sequence used.
      cTokens = makecell([1,1],mtlb_e(oldRem,mtlb_imp(1,mtlb_s(col3,1))));
    else
      if ~isempty(oldRem) then
        // !! L.29: Unknown function mtlb_s not converted, original calling sequence used.
        // !! L.29: Unknown function mtlb_imp not converted, original calling sequence used.
        cTokens = mtlb_e(oldRem,mtlb_imp(1,mtlb_s(col3,1)));
        if isempty(cTokens) then
          cTokens = makecell([1,1],"");
        end;
      else
        cTokens = makecell([1,1],"");
      end;
    end;
    ncTok = ncTok+1;
  else
    if ~isempty(oldRem) then
      ncTok = ncTok+1;
      if isempty(col3) then
        //cTokens(ncTok).entries = oldRem;
      else
        //cTokens(ncTok).entries = oldRem(1:col3-1);
      end;
    end;
  end;
  //     fprintf(''ncTok= %ld:'', ncTok);
  //     for k=1:length(cTokens(:)), fprintf(''(%ld)%s|'', k, cTokens(k).entries); end
  //     fprintf(''\n'');
  if isempty(str) then
    break;
  end;
  nTok = nTok+1;
  // !! L.55: Unknown function tokens not converted, original calling sequence used.
  // L.55: (Warning name conflict: function name changed from tokens to %tokens).
  %tokens(nTok).entries = str;
end;
// ! L.57: mtlb(resume) can be replaced by resume() or resume whether resume is an M-file or not.
mtlb(resume)
endfunction
