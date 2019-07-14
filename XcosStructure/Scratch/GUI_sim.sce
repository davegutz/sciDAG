// Copyright (C) 2019  - Dave Gutz
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
// Jun 20, 2019    DA Gutz     Created
//

function file_name = sfilename()
    [units, types, names]=file();
    if ~isempty(names)
        [%fullpath, bOK]=getlongpathname(names($-2))
        pathsplit = strsplit(%fullpath($), [filesep();'\']);
        file_name = pathsplit($);
    else  // from an sci file
        [a, b] = where();
        [n, m] = size(b);
        // disp(b)
        // whereami()
        if n>=4 then
            file_name = b($-4);
        else
            file_name = b($);
        end
    end
endfunction

function save_this()
    save('.GUI_sim.dat', 'G')
    mprintf('Saved memory\n');
endfunction


// Top level book-keeping
this = sfilename();
base = strsplit(this, '.');
base = base(1);
this_path = get_absolute_file_path(this);
out_path = this_path + '\out';
chdir(this_path);
loaded = %f;

// Run this script in place.  Needs
funcprot(0)
getd('../Lib')
// Global window parameters

// Window Parameters initialization
C = tlist(["Canvas",...
"margin_x", "margin_y",...      // Horizontal and vertical margins
"frame_w", "frame_h",...        // Frame height and width (calculated)
"default_font",...              // Default font
"y_row_choose_plot",...         // Choose plot row location
"y_row_zoom",...                // Zoom top row location
"y_row_plot",...                // Plot row location
"y_row_ctx",...                 // Context row location
"y_row_choose_run",..           // Choose run row location
"y_row_run",...                 // Run file row location
"y_row_load",...                // Data load row location
"y_row_mult",...                // Choose multiple run button location
"delta_y_zoom",...              // Zoom row spacing
"w_col1", "w_col2",...          // Column widths
"x_zoom_entry",...              // Column location (calculated)
"len_zoom_text",...             // length
"x_col1", "x_col2", "x_col3"],...// Column locations
19, 15,...  // margins
0, 0,...    // w, h
"arial",... // font
360,...     // choose plot
340,...     // zoom
260,...     // plot
200,...     // ctx
160,...     // choose run
120,...     // run
80,...      // load
40,...      // choose multiple run
25,...      // delta_y_zoom
170, 200,...// w_col
0,...       // x_zoom_entry
100,...     // len_zoom_text
0, 110, 200); // x_col

C.frame_w = C.w_col1 + C.w_col2 + 3*C.margin_x;
C.frame_h = C.y_row_choose_plot + 3*C.margin_y;
C.x_zoom_entry = C.x_col2 + C.margin_x;

G = tlist(["GUI", "context_file", "context_file_base",...
"run_file", "run_file_base", "runfile_list_file",...
"runfile_list_file_base", "batch", "csv_file",...
"plot_file", "plot_file_base",...
"zoom", "export_figs", "plot_summary", "loaded"],...
'', '',...
'', '', '',...
'', %f, '',...
'', '',...
[[],[]], %f, %t, %f);

global figs G C R RES Ctrl Sen Act Cmp020SM Cmp025SM zoom_entry PerfUnInst

// Structure needed by this script.  All else managed by user and NPSS
mkdir('out');
mkdir('plots', 'raw');
mkdir('run', 'list');
xdel(winsid())
clear figs
r = ver();
version = strsplit(r(1,2), '.');
version = strtod(version(1));
if version<6 then
    stacksize('max')
end
clear r version

// Load configuration
try
    load .GUI_sim.dat
    mprintf('Loaded configuration\n');
catch
    mprintf('Did not load memory...setting defaults and initializing save file\n');
//    G.context_file_base = 'F414-400_v550_RetFix_Unified';
    G.context_file_base = '';
    G.context_file = G.context_file_base + '.ctx';
//    G.run_file_base = 'Ret2_1906_Closing_Opening_PLA_VHM';
    G.run_file_base = '';
    G.run_file = G.run_file_base + '.run';
    G.runfile_list_file = [G.run_file];
    G.runfile_list_file_base = [G.run_file_base];
    G.csv_file = 'out\' + G.run_file_base + '.csv';
    G.run_file_base = G.run_file_base;
    save_this();
end
G.loaded = %f;

function About_NPSS_Gui()
    msg = msprintf(gettext("NPSS Gui is developed by Dave Gutz"));
    messagebox(msg, gettext("About"), "info", "modal");
endfunction

function choose_context()
    global G
    // Use ui to get value of context file
    new_ctx = uigetfile(["*.ctx"], this_path, 'Choose Context')
    if isempty(new_ctx) then
        mprintf('Aborted choose_context.  No changes made\n');
        return;
    end
    G.context_file = new_ctx;
    base_filename = strsplit(G.context_file, '\');
    base_filename = base_filename($);
    G.context_file_base = strsplit(base_filename, '.');
    G.context_file_base = G.context_file_base($-1);
    disp_context_file_base();
    save_this();
endfunction

function choose_plot()
    global G
    // Use ui to get value of single plot file
    new_plot = uigetfile(["*.plt"], this_path, 'Choose Plot')
    if isempty(new_plot) then
        mprintf('Aborted choose_plot.  No changes made\n');
        return;
    end
    G.plot_file = new_plot;
    G.plot_file_base = extract_base(G.plot_file);
    disp_plot_file_base();
    save_this();
endfunction

function choose_run()
    global G
    // Use ui to get value of single run file
    new_run = uigetfile(["*.run"], this_path+'/run', 'Choose Run')
    if isempty(new_run) then
        mprintf('Aborted choose_run.  No changes made\n');
        return;
    end
    G.run_file = new_run;
    G.run_file_base = extract_base(G.run_file);
    disp_run_file_base();
    G.csv_file = 'out\' + G.run_file_base + '.csv';
    G.loaded = %f;
    display_load_data();
    save_this();
endfunction

function choose_runlist()
    global G
    // Use ui to get value of multiple run files list
    new_rflf = uigetfile(["*.txt"], this_path+'/run/list', 'Choose Run List', %f)
    if isempty(new_rflf) then
        mprintf('Aborted choose_runlist.  No changes made\n');
        return;
    end
    G.runfile_list_file = new_rflf;
    G.runfile_list_file_base = extract_base(G.runfile_list_file);
    display_mruns();
    save_this();
endfunction

function clear_zoom()
    global G zoom_entry
    mprintf('Clearing Zoom\n');
    G.zoom = [];
    zoom_entry(1).String="";
    zoom_entry(2).String="";
endfunction

function close_figs()
    global figs
    wid = winsid();
    if wid(1)==100001 then
        xdel(wid(2:$))
    else
        xdel(winsid())
    end
    figs=[];
endfunction

function create_runlist()
    global G
    // Use ui to get value of multiple run file
    raw_list = uigetfile(["*.run"], this_path+'/run', 'Choose Runs', %t)
    if isempty(raw_list) then
        mprintf('Aborted choose_run.  No changes made\n');
        return;
    end
    G.runfile_list_file = uigetfile(["*.txt"], this_path+'/run/list', 'Where save', %f)
    ext = extract_extension(G.runfile_list_file);
    if ~exists('ext') | ext~='txt' then
        G.runfile_list_file = G.runfile_list_file + '.txt';
    end
    G.runfile_list_file_base = extract_base(G.runfile_list_file);
    fd = mopen(G.runfile_list_file, 'wt');
    for i=1:size(raw_list, 2)
        mfprintf(fd, "%s\n", raw_list(i))
    end
    mclose(fd)
    display_mruns();
    save_this();
endfunction

function disp_context_file_base ()
    global G
    uicontrol("parent",gui_npss, "style","text", ...
    "string",G.context_file_base, "position",[C.x_col3+C.margin_x C.y_row_ctx+C.margin_y 300 20], ...
    "horizontalalignment","left", "fontsize",14, ...
    "background",[1 1 1]);
endfunction

function disp_plot_file_base ()
    global G
    uicontrol("parent",gui_npss, "style","text", ...
    "string", G.plot_file_base, "position", [C.x_col3+C.margin_x C.y_row_choose_plot+C.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function disp_run_file_base ()
    global G
    uicontrol("parent",gui_npss, "style","text", ...
    "string", G.run_file_base, "position", [C.x_col3+C.margin_x C.y_row_choose_run+C.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function display_all_plot()
    global figs G R Ctrl Sen Act
    if isempty(Ctrl) | ~G.loaded then
        mprintf('Load Data first\n')
        return
    end
   if isempty(G.plot_file_base) then
        mprintf('Choose Plot file\n')
        messagebox('Choose Plot file', gettext("edit_plot_file"), "Error", "modal");
        return
    end
    // Plotting of model data
    delete(gca());
    G.plot_summary = %f;
    exec(G.plot_file, -1)
endfunction

function display_load_data ()
    global G C
    if G.loaded then
        loaded_file = G.run_file_base;
    else
        loaded_file = '';
    end
    uicontrol("parent",gui_npss, "style","text", ...
    "string", loaded_file, "position", [C.x_col3+C.margin_x C.y_row_load+C.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function display_mruns ()
    global G
    uicontrol("parent",gui_npss, "style","text", ...
    "string", G.runfile_list_file_base, "position", [C.x_col3+C.margin_x  C.y_row_mult+C.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function display_summary_plot()
    global figs G R Ctrl Sen Act
    if isempty(Ctrl) | ~G.loaded then
        mprintf('Load Data first\n')
        return
    end
   if isempty(G.plot_file_base) then
        mprintf('Choose Plot file\n')
        messagebox('Choose Plot file', gettext("edit_plot_file"), "Error", "modal");
        return
    end
    // Plotting of model data
    delete(gca());
    G.plot_summary = %t;
    exec(G.plot_file, -1)
endfunction

function edit_plot_file()
    global G
   if isempty(G.plot_file_base) then
        mprintf('Choose Plot first\n')
        messagebox('Choose Plot first', gettext("edit_plot_file"), "Error", "modal");
        return
    end
    mprintf('Editting %s...\n', G.plot_file_base);
    cmd = msprintf("editor %s.plt", G.plot_file_base)
    execstr(cmd)
endfunction

function edit_run()
    global G
    command = 'start notepad++ ' + G.run_file;
    mprintf('Editting %s...\n', G.run_file);
    winID = progressionbar('Running '+command);
    exit_code = dos(command);
    close(winID);
endfunction

function edit_runfile_list_file()
    global G
    command = 'start notepad++ ' + G.runfile_list_file;
    mprintf('Editting %s...\n', G.runfile_list_file);
    winID = progressionbar('Running '+command);
    exit_code = dos(command);
    close(winID);
endfunction

function export_plots()
    global G figs
    mprintf('Exporting plots to plots/%s*.pdf and plots/raw/%s*.png\n', G.run_file_base, G.run_file_base);
    winID = progressionbar('Exporting to plots ' + G.run_file_base + '...');
    try
        export_figs(figs, G.run_file_base)
        close(winID)
    catch
        messagebox('Failed to export_figs', gettext("export_plots"), "Error", "modal");
        close(winID)
    end
endfunction

function target = extract_base(source)
    source = strsplit(source, '\');
    source = source($);
    source_split = strsplit(source, '.');
    target = source_split(1);
    for i=2:size(source_split, 1)-1
        target = target + '.' + source_split(i);
    end
endfunction

function target = extract_extension(source)
    source = strsplit(source, '\');
    source = source($);
    source_split = strsplit(source, '.');
    target = source_split($);
endfunction

function load_data()
    global G
    global figs Ctrl Sen Act Cmp020SM Cmp025SM PerfUnInst
    mprintf('Loading %s...', G.csv_file);
    winID = progressionbar('Loading ' + G.csv_file + '...');
    try
        [D, N, time] = load_csv_data(G.csv_file, 1);
    catch
        mprintf('Output file %s does not exist\n', G.csv_file);
        close(winID);
        messagebox("Output file does not exist", gettext("File does not exist"), "info", "modal");
        return
    end
    exec('./Lib/load_decode_csv_data.sce', -1)
    Ctrl = order_all_fields(Ctrl);
    Act = order_all_fields(Act);
    Sen = order_all_fields(Sen);
    G.loaded = %t;
    display_load_data();
    close(winID);
    mprintf('Done\n')
endfunction

function NPSSrun()
    global figs G R Ctrl Sen Act batch
    out_file = 'out/'+ G.run_file_base + '.out';
    command = 'npssRun -c '+G.context_file+' ' + G.run_file +' > ' + out_file + ' 2>&1';
    command_disp = 'npssRun -c '+G.context_file_base+' ' + G.run_file_base;
    mprintf('Running %s...\n', command);
    winID = progressionbar(command_disp);
    dos(command);
    close(winID);
    out_file_info = fileinfo(out_file);
    if out_file_info(1)<1500 then
        editor(out_file)
        G.loaded = %f;
        display_load_data();
        messagebox("Failed to run NPSS.  If editor doesnt provide info try NPSSrun Interactive", gettext("NPSSrun"), "Error", "modal");
        return;
    end
    load_data();
    if batch then
        plot_all();
    else
        plot_summ();
    end
    export_plots();
endfunction

function plot_all()
    global figs G R Ctrl Sen Act
    if isempty(Ctrl) | ~G.loaded then
        mprintf('Load Data first\n')
        return
    end
    time0 = findobj("tag", "Zoom Start"); zoom0 = evstr(time0.string);
    time1 = findobj("tag", "Zoom End"); zoom1 = evstr(time1.string);
    if ~isnan(zoom0) & ~isnan(zoom1) then
        G.zoom = [zoom0 zoom1];
    else
        clear_zoom();
    end
    // Redraw window
    drawlater();
    my_plot_axes = gca();
    my_plot_axes.title.text = "Latest Model Result";
    newaxes();
    display_all_plot();
    drawnow();
endfunction

function plot_summ()
    global figs G R Ctrl Sen Act
    if isempty(Ctrl) | ~G.loaded then
        mprintf('Load Data first\n')
        msg = msprintf(gettext("Load data first"));
        messagebox(msg, gettext("Hey!"), "Error", "modal");
        return
    end
    time0 = findobj("tag", "Zoom Start"); zoom0 = evstr(time0.string);
    time1 = findobj("tag", "Zoom End"); zoom1 = evstr(time1.string);
    if ~isnan(zoom0) & ~isnan(zoom1) then
        G.zoom = [zoom0 zoom1];
    else
        clear_zoom();
    end
    display_summary_plot();
endfunction

function run_mult()
    global G
    batch = %t;
    try
        fd = mopen(G.runfile_list_file, 'r');
        G.run_file = mgetl(fd, 1);
        while exists('G.run_file') & ~isempty(G.run_file) do
            G.run_file_base = extract_base(G.run_file);
            NPSSrun();
            G.run_file = mgetl(fd);
        end
        mclose(fd);
        batch = %f;
    catch
        batch = %f;
    end
endfunction

function NPSSrun_interactive
    global G figs G R Ctrl Sen Act
    command = 'npssRun -win -i -c '+G.context_file+' ' + G.run_file;
    mprintf('Running %s...\n', command);
    dos(command);
    G.loaded = %f;
    display_load_data();
endfunction

function npss_WS
    global G
    command = 'npssWS -c '+G.context_file;
    mprintf('Running %s...\n', command);
    dos(command);
endfunction

// Main section
funcprot(0);
this = sfilename();
base = strsplit(this, '.');
base = base(1);
this_path = get_absolute_file_path(this);
out_path = this_path + '\out';
chdir(this_path);



gui_npss = scf(100001);// Create window with id=100001 and make it the current one

// Background and text
gui_npss.background = -2;
gui_npss.figure_position = [0 0];
gui_npss.figure_size = [C.frame_w+50 C.frame_h+150];
gui_npss.figure_name = gettext("NPSS Run");

// Change dimensions of the figure
//gui_npss.axes_size = [axes_w axes_h];

// Remove Scilab graphics menus & toolbar
delmenu(gui_npss.figure_id, gettext("&File"));
delmenu(gui_npss.figure_id, gettext("&Tools"));
delmenu(gui_npss.figure_id, gettext("&Edit"));
delmenu(gui_npss.figure_id, gettext("&?"));
toolbar(gui_npss.figure_id, "off");

// New menu
h1 = uimenu("parent", gui_npss, "label", gettext("File"));
h2 = uimenu("parent", gui_npss, "label", gettext("About"));

// Populate menu: file
uimenu("parent", h1, "label", gettext("Close"), "callback",...
    "gui_npss=get_figure_handle(100001);delete(gui_npss);",...
    "tag", "close_menu");

// Populate menu: about
uimenu("parent", h2, "label",gettext("About"), "callback","About_NPSS_Gui();");
// Sleep to guarantee a better display (avoiding to see a sequential display)
sleep(500);

// Frames creation [NPSS parameters]
my_frame = uicontrol("parent",gui_npss, "relief","groove", ...
    "style","frame", "units","pixels", ...
    "position",[ C.margin_x C.margin_y C.frame_w C.frame_h], ...
    "horizontalalignment","center", "background",[1 1 1], ...
    "tag","frame_control");

// Frame title
my_frame_title = uicontrol("parent", gui_npss, "style", "text",...
    "string","NPSS Run Control", "units", "pixels",...
    "position",[30+C.margin_x C.margin_y+C.frame_h-10 C.frame_w-60 20],...
    "fontname", C.default_font, "fontunits", "points", ...
    "fontsize", 16, "horizontalalignment", "center", ...
    "background", [1 1 1], "tag", "title_frame_control");

// Adding zoom
labels_zoom = ["Zoom Start", "Zoom End"];
values_zoom = G.zoom;
for k=1:size(labels_zoom, 2)
    uicontrol("parent",gui_npss, "style","text", ...
        "string", labels_zoom(k), "position",[C.x_col1+2*C.margin_x,C.y_row_zoom-(k-1)*C.delta_y_zoom,C.len_zoom_text,20], ...
        "horizontalalignment","left", "fontsize",14, ...
        "background",[1 1 1]);
    zoom_entry(k) = uicontrol("parent", gui_npss, "style", "edit",...
        "string", string(values_zoom(k)), "position", [C.x_zoom_entry,C.y_row_zoom-(k-1)*C.delta_y_zoom,50,20], ...
        "horizontalalignment","left", "fontsize",14,...
        "background",[.9 .9 .9], "tag", labels_zoom(k));
end
clear values_zoom labels_zoom

// Buttons
// NPSSrun_button
uicontrol(gui_npss, "style", "pushbutton", ...
    "Position", [C.x_col1+2*C.margin_x C.y_row_run+C.margin_y C.w_col1 24], "String", "NPSSrun", ...
    "BackgroundColor",[0 .9 0], "fontsize", 18, ...
    "Callback", "NPSSrun");
//npssrun_interactive
uicontrol(gui_npss, "style", "pushbutton", ...
    "Position", [C.x_col3+C.margin_x C.y_row_run+C.margin_y C.w_col2 24], "String", "NPSSrun Interactive", ...
    "BackgroundColor",[0.7 0.8 0.7], "fontsize", 12, ...
    "Callback", "NPSSrun_interactive");
// load_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col1+2*C.margin_x C.y_row_load+C.margin_y C.w_col1 24], "String","Load Data-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 18, ...
    "Callback", "load_data");
// summ_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col1+2*C.margin_x C.y_row_plot+C.margin_y C.w_col1*1/2 24], "String", "Summ", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 16, ...
    "Callback", "plot_summ");
// all_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col1+2*C.margin_x+C.w_col1/3+C.w_col1/4 C.y_row_plot+C.margin_y C.w_col1/3 24], "String", "All", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 16, ...
    "Callback", "plot_all");
// export_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col3+C.margin_x C.y_row_plot+C.margin_y C.w_col2 24], "String", "Export Plots", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 18, ...
    "Callback", "export_plots");
// context_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col1+2*C.margin_x C.y_row_ctx+C.margin_y C.w_col1 20], "String", "Choose Context-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_context");
// clear_zoom_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col3+C.margin_x, C.y_row_zoom,C.w_col2,20], "String", "Clear Zoom", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "clear_zoom");
// close_figs_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col3+C.margin_x, C.y_row_zoom-C.delta_y_zoom,C.w_col2,20], "String", "Close Figs", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "close_figs");
// choose_run_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col1+2*C.margin_x C.y_row_choose_run+C.margin_y C.w_col1 20], "String", "Choose Run-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_run");
// choose_mrun_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col1+2*C.margin_x C.y_row_mult+C.margin_y C.w_col1 20], "String", "Choose Mult File-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_runlist");
// mrun_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col1+2*C.margin_x C.y_row_mult+C.margin_y-25 C.w_col1 20], "String", "Run Multiples", ...
    "BackgroundColor",[.6 .7 .6], "fontsize", 14, ...
    "Callback", "run_mult");
// edit_run_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col3+C.margin_x C.y_row_choose_run+C.margin_y-15 50 12], "String", "Edit", ...
    "BackgroundColor",[.8 .7 .7], "fontsize", 10, ...
    "Callback", "edit_run");
// create_runlist_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col3+C.margin_x C.y_row_mult+C.margin_y-15 70 12], "String", "Create", ...
    "BackgroundColor",[.93 .93 .93], "fontsize", 10, ...
    "Callback", "create_runlist");
// npssws_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col3+C.margin_x C.y_row_ctx+C.margin_y-15 70 12], "String", "npssWS", ...
    "BackgroundColor",[.7 .7 .8], "fontsize", 10, ...
    "Callback", "npss_WS");
// edit_runfile_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col3+C.margin_x+75 C.y_row_mult+C.margin_y-15 50 12], "String", "Edit", ...
    "BackgroundColor",[.8 .7 .7], "fontsize", 10, ...
    "Callback", "edit_runfile_list_file");
// choose_plot_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position",[C.x_col1+2*C.margin_x C.y_row_choose_plot+C.margin_y C.w_col1 20], "String", "Choose Plot-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_plot");
// edit_plot_file_button
uicontrol(gui_npss, "style","pushbutton", ...
    "Position", [C.x_col3+C.margin_x C.y_row_choose_plot+C.margin_y-15 50 12], "String", "Edit", ...
    "BackgroundColor",[.8 .7 .7], "fontsize", 10, ...
    "Callback", "edit_plot_file");

// Initial displays
disp_context_file_base();
disp_run_file_base();
display_load_data();
display_mruns();
disp_plot_file_base();

