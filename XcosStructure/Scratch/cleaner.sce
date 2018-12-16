// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by builder.sce : Please, do not edit this file
// cleaner.sce
// ------------------------------------------------------
curdir = pwd();
cleaner_path = get_file_path('cleaner.sce');
chdir(cleaner_path);
// ------------------------------------------------------
if fileinfo('LibScratchLoader.sce') <> [] then
  mdelete('LibScratchLoader.sce');
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
if fileinfo('libScratch.dll') <> [] then
  mdelete('libScratch.dll');
end
// ------------------------------------------------------
chdir(curdir);
// ------------------------------------------------------
