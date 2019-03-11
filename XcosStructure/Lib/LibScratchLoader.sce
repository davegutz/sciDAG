// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by builder.sce : Please, do not edit this file
// ----------------------------------------------------------------------------
//
if ~win64() then
  warning(_("This module requires a Windows x64 platform."));
  return
end
//
Scratch_path = get_absolute_file_path('LibScratchLoader.sce');
//
// ulink previous function with same name
[bOK, ilib] = c_link('lim_int');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('friction');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('valve_a');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('trivalve_a1');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('hlfvalve_a');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('table1_a');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('head_b');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('actuator_a_b');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('binsearch');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('tab1');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('tab2');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('hole');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('cor_aptow');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('cor_awpstopd');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('cor_awpdtops');
if bOK then
  ulink(ilib);
end
//
[bOK, ilib] = c_link('ctab1');
if bOK then
  ulink(ilib);
end
//
link('C:/PROGRA~1/SCILAB~1.2\bin\scicos' + getdynlibext());
link(Scratch_path + 'libScratch' + getdynlibext(), ['lim_int','friction','valve_a','trivalve_a1','hlfvalve_a','table1_a','head_b','actuator_a_b','binsearch','tab1','tab2','hole','cor_aptow','cor_awpstopd','cor_awpdtops','ctab1'],'c');
// remove temp. variables on stack
clear Scratch_path;
clear bOK;
clear ilib;
// ----------------------------------------------------------------------------
