// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by tbx_build_pal_loader: Please, do not edit this file

function loaderpal()
  xpal = xcosPal("Xcos toolbox skeleton");
  images_path = get_absolute_file_path("loader_pal.sce")+"/../images/";
  interfacefunctions =["TBX_SUM_c","TBX_SUM_sci","TBX_SUM_modelica","TBX_MUT_STYLE","TBX_NOOP"]
  for i=1:size(interfacefunctions,"*")
    h5_instances  = ls(images_path + "h5/"  + interfacefunctions(i) + ".sod");
    if h5_instances==[] then
      error(msprintf(_("%s: block %s has not been built.\n"),"loader_pal.sce",interfacefunctions(i)))
    end
    pal_icons     = ls(images_path + "gif/" + interfacefunctions(i) + "." + ["png" "jpg" "gif"]);
    if pal_icons==[] then
      error(msprintf(_("%s: block %s has no palette icon.\n"),"loader_pal.sce",interfacefunctions(i)))
    end
    graph_icons   = ls(images_path + "svg/" + interfacefunctions(i) + "." + ["svg" "png" "jpg" "gif"]);
    if graph_icons==[] then
      error(msprintf(_("%s: block %s has no editor icon.\n"),"loader_pal.sce",interfacefunctions(i)))
    end
    xpal = xcosPalAddBlock(xpal, interfacefunctions(i), pal_icons(1) , graph_icons(1));
  end
  xcosPalAdd(xpal);
endfunction
loaderpal(),clear loaderpal
