// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by builder.sce : Please, do not edit this file
// cleaner.sce
// ------------------------------------------------------
curdir = pwd();
cleaner_path = get_file_path('cleaner.sce');
chdir(cleaner_path);
// ------------------------------------------------------
if fileinfo('loader.sce') <> [] then
  mdelete('loader.sce');
end
// ------------------------------------------------------
if fileinfo('Makelib.mak') <> [] then
  if ~ exists("dynamic_linkwindowslib") then
    load("SCI/modules/dynamic_link/macros/windows/lib")
  end
  dlwConfigureEnv();
  unix_s('nmake /Y /nologo /f Makelib.mak clean');
  mdelete('Makelib.mak');
end
// ------------------------------------------------------
if isdir('Debug') then
  rmdir('Debug','s');
end
// ------------------------------------------------------
if isdir('Release') then
  rmdir('Release','s');
end
// ------------------------------------------------------
if fileinfo('libxcos_tbx_skel.dll') <> [] then
  mdelete('libxcos_tbx_skel.dll');
end
// ------------------------------------------------------
chdir(curdir);
// ------------------------------------------------------