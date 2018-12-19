// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by builder.sce : Please, do not edit this file
// ----------------------------------------------------------------------------
//
if ~win64() then
  warning(_("This module requires a Windows x64 platform."));
  return
end
//
Scratch_path = get_absolute_file_path('frictionLoader.sce');
//
// ulink previous function with same name
[bOK, ilib] = c_link('friction');
if bOK then
  ulink(ilib);
end
//
link('C:\PROGRA~1\SCILAB~1.2\bin\scicos' + getdynlibext());
link(Scratch_path + 'libScratch' + getdynlibext(), ['friction'],'c');
// remove temp. variables on stack
clear Scratch_path;
clear bOK;
clear ilib;
// ----------------------------------------------------------------------------
