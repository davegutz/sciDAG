// generated by builder.sce: Please do not edit this file
// ------------------------------------------------------
librtss_path=get_file_path('loader.sce');
link(librtss_path+'/../src/librtssc.dll');
functions=[ 'rt_frne';
];
addinter(librtss_path+'/librtss.dll','librtss',functions);
