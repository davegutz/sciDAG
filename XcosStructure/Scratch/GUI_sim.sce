// Copyright (CNV) 2019  - Dave Gutz
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

function save_this()
    save('.GUI_sim.dat', 'GUI')
    mprintf('Saved memory\n');
endfunction

// Top level book-keeping
funcprot(0)
getd('../Lib')
this = sfilename();
base = strsplit(this, '.');
base = base(1);
this_path = get_absolute_file_path(this);
out_path = this_path + '\out';
chdir(this_path);

// Global window parameters

// Window Parameters initialization
CNV = tlist(["Canvas",...
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

CNV.frame_w = CNV.w_col1 + CNV.w_col2 + 3*CNV.margin_x;
CNV.frame_h = CNV.y_row_choose_plot + 3*CNV.margin_y;
CNV.x_zoom_entry = CNV.x_col2 + CNV.margin_x;

GUI = tlist(["GUI", "context_file", "context_file_base",...
"run_file", "run_file_base", "runfile_list_file",...
"runfile_list_file_base", "batch", "csv_file",...
"plot_file", "plot_file_base",...
"zoom", "export_figs", "plot_summary", "loaded"],...
'', '',...
'', '', '',...
'', %f, '',...
'', '',...
[[],[]], %f, %t, %f);

global figs GUI CNV R RES Ctrl Sen Act Cmp020SM Cmp025SM zoom_entry PerfUnInst

// Structure needed by this script.  All else managed by user and SIM
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
    GUI.context_file_base = '';
    GUI.context_file = GUI.context_file_base + '.ctx';
    GUI.run_file_base = '';
    GUI.run_file = GUI.run_file_base + '.run';
    GUI.runfile_list_file = [GUI.run_file];
    GUI.runfile_list_file_base = [GUI.run_file_base];
    GUI.csv_file = 'out\' + GUI.run_file_base + '.csv';
    GUI.run_file_base = GUI.run_file_base;
    save_this();
end
GUI.loaded = %f;

function About_SIM_Gui()
    msg = msprintf(gettext("SIM Gui is developed by Dave Gutz"));
    messagebox(msg, gettext("About"), "info", "modal");
endfunction

function choose_context()
    global GUI
    // Use ui to get value of context file
    new_ctx = uigetfile(["*.ctx"], this_path, 'Choose Context')
    if isempty(new_ctx) then
        mprintf('Aborted choose_context.  No changes made\n');
        return;
    end
    GUI.context_file = new_ctx;
    base_filename = strsplit(GUI.context_file, '\');
    base_filename = base_filename($);
    GUI.context_file_base = strsplit(base_filename, '.');
    GUI.context_file_base = GUI.context_file_base($-1);
    disp_context_file_base();
    save_this();
endfunction

function choose_plot()
    global GUI
    // Use ui to get value of single plot file
    new_plot = uigetfile(["*.plt"], this_path, 'Choose Plot')
    if isempty(new_plot) then
        mprintf('Aborted choose_plot.  No changes made\n');
        return;
    end
    GUI.plot_file = new_plot;
    GUI.plot_file_base = extract_base(GUI.plot_file);
    disp_plot_file_base();
    save_this();
endfunction

function choose_run()
    global GUI
    // Use ui to get value of single run file
    new_run = uigetfile(["*.run"], this_path+'/run', 'Choose Run')
    if isempty(new_run) then
        mprintf('Aborted choose_run.  No changes made\n');
        return;
    end
    GUI.run_file = new_run;
    GUI.run_file_base = extract_base(GUI.run_file);
    disp_run_file_base();
    GUI.csv_file = 'out\' + GUI.run_file_base + '.csv';
    GUI.loaded = %f;
    display_load_data();
    save_this();
endfunction

function choose_runlist()
    global GUI
    // Use ui to get value of multiple run files list
    new_rflf = uigetfile(["*.txt"], this_path+'/run/list', 'Choose Run List', %f)
    if isempty(new_rflf) then
        mprintf('Aborted choose_runlist.  No changes made\n');
        return;
    end
    GUI.runfile_list_file = new_rflf;
    GUI.runfile_list_file_base = extract_base(GUI.runfile_list_file);
    display_mruns();
    save_this();
endfunction

function clear_zoom()
    global GUI zoom_entry
    mprintf('Clearing Zoom\n');
    GUI.zoom = [];
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
    global GUI
    // Use ui to get value of multiple run file
    raw_list = uigetfile(["*.run"], this_path+'/run', 'Choose Runs', %t)
    if isempty(raw_list) then
        mprintf('Aborted choose_run.  No changes made\n');
        return;
    end
    GUI.runfile_list_file = uigetfile(["*.txt"], this_path+'/run/list', 'Where save', %f)
    ext = extract_extension(GUI.runfile_list_file);
    if ~exists('ext') | ext~='txt' then
        GUI.runfile_list_file = GUI.runfile_list_file + '.txt';
    end
    GUI.runfile_list_file_base = extract_base(GUI.runfile_list_file);
    fd = mopen(GUI.runfile_list_file, 'wt');
    for i=1:size(raw_list, 2)
        mfprintf(fd, "%s\n", raw_list(i))
    end
    mclose(fd)
    display_mruns();
    save_this();
endfunction

function disp_context_file_base ()
    global GUI
    uicontrol("parent",gui_sim, "style","text", ...
    "string",GUI.context_file_base, "position",[CNV.x_col3+CNV.margin_x CNV.y_row_ctx+CNV.margin_y 300 20], ...
    "horizontalalignment","left", "fontsize",14, ...
    "background",[1 1 1]);
endfunction

function disp_plot_file_base ()
    global GUI
    uicontrol("parent",gui_sim, "style","text", ...
    "string", GUI.plot_file_base, "position", [CNV.x_col3+CNV.margin_x CNV.y_row_choose_plot+CNV.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function disp_run_file_base ()
    global GUI
    uicontrol("parent",gui_sim, "style","text", ...
    "string", GUI.run_file_base, "position", [CNV.x_col3+CNV.margin_x CNV.y_row_choose_run+CNV.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function display_all_plot()
    global figs GUI R Ctrl Sen Act
    if isempty(Ctrl) | ~GUI.loaded then
        mprintf('Load Data first\n')
        return
    end
   if isempty(GUI.plot_file_base) then
        mprintf('Choose Plot file\n')
        messagebox('Choose Plot file', gettext("edit_plot_file"), "Error", "modal");
        return
    end
    // Plotting of model data
    delete(gca());
    GUI.plot_summary = %f;
    exec(GUI.plot_file, -1)
endfunction

function display_load_data ()
    global GUI CNV
    if GUI.loaded then
        loaded_file = GUI.run_file_base;
    else
        loaded_file = '';
    end
    uicontrol("parent",gui_sim, "style","text", ...
    "string", loaded_file, "position", [CNV.x_col3+CNV.margin_x CNV.y_row_load+CNV.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function display_mruns ()
    global GUI
    uicontrol("parent",gui_sim, "style","text", ...
    "string", GUI.runfile_list_file_base, "position", [CNV.x_col3+CNV.margin_x  CNV.y_row_mult+CNV.margin_y 300 20], ...
    "horizontalalignment", "left", "fontsize", 14, ...
    "background", [1 1 1]);
endfunction

function display_summary_plot()
    global figs GUI R Ctrl Sen Act
    if isempty(Ctrl) | ~GUI.loaded then
        mprintf('Load Data first\n')
        return
    end
   if isempty(GUI.plot_file_base) then
        mprintf('Choose Plot file\n')
        messagebox('Choose Plot file', gettext("edit_plot_file"), "Error", "modal");
        return
    end
    // Plotting of model data
    delete(gca());
    GUI.plot_summary = %t;
    exec(GUI.plot_file, -1)
endfunction

function edit_plot_file()
    global GUI
   if isempty(GUI.plot_file_base) then
        mprintf('Choose Plot first\n')
        messagebox('Choose Plot first', gettext("edit_plot_file"), "Error", "modal");
        return
    end
    mprintf('Editting %s...\n', GUI.plot_file_base);
    cmd = msprintf("editor %s.plt", GUI.plot_file_base)
    execstr(cmd)
endfunction

function edit_run()
    global GUI
    command = 'start notepad++ ' + GUI.run_file;
    mprintf('Editting %s...\n', GUI.run_file);
    winID = progressionbar('Running '+command);
    exit_code = dos(command);
    close(winID);
endfunction

function edit_runfile_list_file()
    global GUI
    command = 'start notepad++ ' + GUI.runfile_list_file;
    mprintf('Editting %s...\n', GUI.runfile_list_file);
    winID = progressionbar('Running '+command);
    exit_code = dos(command);
    close(winID);
endfunction

function export_plots()
    global GUI figs
    mprintf('Exporting plots to plots/%s*.pdf and plots/raw/%s*.png\n', GUI.run_file_base, GUI.run_file_base);
    winID = progressionbar('Exporting to plots ' + GUI.run_file_base + '...');
    try
        export_figs(figs, GUI.run_file_base)
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
    global GUI
    global figs Ctrl Sen Act Cmp020SM Cmp025SM PerfUnInst
    mprintf('Loading %s...', GUI.csv_file);
    winID = progressionbar('Loading ' + GUI.csv_file + '...');
    try
        [D, N, time] = load_csv_data(GUI.csv_file, 1);
    catch
        mprintf('Output file %s does not exist\n', GUI.csv_file);
        close(winID);
        messagebox("Output file does not exist", gettext("File does not exist"), "info", "modal");
        return
    end
    exec('./Lib/load_decode_csv_data.sce', -1)
    Ctrl = order_all_fields(Ctrl);
    Act = order_all_fields(Act);
    Sen = order_all_fields(Sen);
    GUI.loaded = %t;
    display_load_data();
    close(winID);
    mprintf('Done\n')
endfunction

function SIMrun()
    global figs GUI R Ctrl Sen Act batch
    out_file = 'out/'+ GUI.run_file_base + '.out';
    command = 'npssRun -c '+GUI.context_file+' ' + GUI.run_file +' > ' + out_file + ' 2>&1';
    command_disp = 'npssRun -c '+GUI.context_file_base+' ' + GUI.run_file_base;
    mprintf('Running %s...\n', command);
    winID = progressionbar(command_disp);
    dos(command);
    close(winID);
    out_file_info = fileinfo(out_file);
    if out_file_info(1)<1500 then
        editor(out_file)
        GUI.loaded = %f;
        display_load_data();
        messagebox("Failed to run SIM.  If editor doesnt provide info try SIMrun Interactive", gettext("SIMrun"), "Error", "modal");
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
    global figs GUI R Ctrl Sen Act
    if isempty(Ctrl) | ~GUI.loaded then
        mprintf('Load Data first\n')
        return
    end
    time0 = findobj("tag", "Zoom Start"); zoom0 = evstr(time0.string);
    time1 = findobj("tag", "Zoom End"); zoom1 = evstr(time1.string);
    if ~isnan(zoom0) & ~isnan(zoom1) then
        GUI.zoom = [zoom0 zoom1];
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
    global figs GUI R Ctrl Sen Act
    if isempty(Ctrl) | ~GUI.loaded then
        mprintf('Load Data first\n')
        msg = msprintf(gettext("Load data first"));
        messagebox(msg, gettext("Hey!"), "Error", "modal");
        return
    end
    time0 = findobj("tag", "Zoom Start"); zoom0 = evstr(time0.string);
    time1 = findobj("tag", "Zoom End"); zoom1 = evstr(time1.string);
    if ~isnan(zoom0) & ~isnan(zoom1) then
        GUI.zoom = [zoom0 zoom1];
    else
        clear_zoom();
    end
    display_summary_plot();
endfunction

function run_mult()
    global GUI
    batch = %t;
    try
        fd = mopen(GUI.runfile_list_file, 'r');
        GUI.run_file = mgetl(fd, 1);
        while exists('GUI.run_file') & ~isempty(GUI.run_file) do
            GUI.run_file_base = extract_base(GUI.run_file);
            SIMrun();
            GUI.run_file = mgetl(fd);
        end
        mclose(fd);
        batch = %f;
    catch
        batch = %f;
    end
endfunction

function SIMrun_interactive
    global GUI figs GUI R Ctrl Sen Act
    command = 'npssRun -win -i -c '+GUI.context_file+' ' + GUI.run_file;
    mprintf('Running %s...\n', command);
    dos(command);
    GUI.loaded = %f;
    display_load_data();
endfunction

function npss_WS
    global GUI
    command = 'npssWS -c '+GUI.context_file;
    mprintf('Running %s...\n', command);
    dos(command);
endfunction

// Main section
gui_sim = scf(100001);// Create window with id=100001 and make it the current one

// Background and text
gui_sim.background = -2;
gui_sim.figure_position = [0 0];
gui_sim.figure_size = [CNV.frame_w+50 CNV.frame_h+150];
gui_sim.figure_name = gettext("SIM Run");

// Change dimensions of the figure
//gui_sim.axes_size = [axes_w axes_h];

// Remove Scilab graphics menus & toolbar
delmenu(gui_sim.figure_id, gettext("&File"));
delmenu(gui_sim.figure_id, gettext("&Tools"));
delmenu(gui_sim.figure_id, gettext("&Edit"));
delmenu(gui_sim.figure_id, gettext("&?"));
toolbar(gui_sim.figure_id, "off");

// New menu
h1 = uimenu("parent", gui_sim, "label", gettext("File"));
h2 = uimenu("parent", gui_sim, "label", gettext("About"));

// Populate menu: file
uimenu("parent", h1, "label", gettext("Close"), "callback",...
    "gui_sim=get_figure_handle(100001);delete(gui_sim);",...
    "tag", "close_menu");

// Populate menu: about
uimenu("parent", h2, "label",gettext("About"), "callback","About_SIM_Gui();");
// Sleep to guarantee a better display (avoiding to see a sequential display)
sleep(500);

// Frames creation [SIM parameters]
my_frame = uicontrol("parent",gui_sim, "relief","groove", ...
    "style","frame", "units","pixels", ...
    "position",[ CNV.margin_x CNV.margin_y CNV.frame_w CNV.frame_h], ...
    "horizontalalignment","center", "background",[1 1 1], ...
    "tag","frame_control");

// Frame title
my_frame_title = uicontrol("parent", gui_sim, "style", "text",...
    "string","SIM Run Control", "units", "pixels",...
    "position",[30+CNV.margin_x CNV.margin_y+CNV.frame_h-10 CNV.frame_w-60 20],...
    "fontname", CNV.default_font, "fontunits", "points", ...
    "fontsize", 16, "horizontalalignment", "center", ...
    "background", [1 1 1], "tag", "title_frame_control");

// Adding zoom
labels_zoom = ["Zoom Start", "Zoom End"];
values_zoom = GUI.zoom;
for k=1:size(labels_zoom, 2)
    uicontrol("parent",gui_sim, "style","text", ...
        "string", labels_zoom(k), "position",[CNV.x_col1+2*CNV.margin_x,CNV.y_row_zoom-(k-1)*CNV.delta_y_zoom,CNV.len_zoom_text,20], ...
        "horizontalalignment","left", "fontsize",14, ...
        "background",[1 1 1]);
    zoom_entry(k) = uicontrol("parent", gui_sim, "style", "edit",...
        "string", string(values_zoom(k)), "position", [CNV.x_zoom_entry,CNV.y_row_zoom-(k-1)*CNV.delta_y_zoom,50,20], ...
        "horizontalalignment","left", "fontsize",14,...
        "background",[.9 .9 .9], "tag", labels_zoom(k));
end
clear values_zoom labels_zoom

// Buttons
// SIMrun_button
uicontrol(gui_sim, "style", "pushbutton", ...
    "Position", [CNV.x_col1+2*CNV.margin_x CNV.y_row_run+CNV.margin_y CNV.w_col1 24], "String", "SIMrun", ...
    "BackgroundColor",[0 .9 0], "fontsize", 18, ...
    "Callback", "SIMrun");
//npssrun_interactive
uicontrol(gui_sim, "style", "pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x CNV.y_row_run+CNV.margin_y CNV.w_col2 24], "String", "SIMrun Interactive", ...
    "BackgroundColor",[0.7 0.8 0.7], "fontsize", 12, ...
    "Callback", "SIMrun_interactive");
// load_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col1+2*CNV.margin_x CNV.y_row_load+CNV.margin_y CNV.w_col1 24], "String","Load Data-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 18, ...
    "Callback", "load_data");
// summ_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col1+2*CNV.margin_x CNV.y_row_plot+CNV.margin_y CNV.w_col1*1/2 24], "String", "Summ", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 16, ...
    "Callback", "plot_summ");
// all_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col1+2*CNV.margin_x+CNV.w_col1/3+CNV.w_col1/4 CNV.y_row_plot+CNV.margin_y CNV.w_col1/3 24], "String", "All", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 16, ...
    "Callback", "plot_all");
// export_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col3+CNV.margin_x CNV.y_row_plot+CNV.margin_y CNV.w_col2 24], "String", "Export Plots", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 18, ...
    "Callback", "export_plots");
// context_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col1+2*CNV.margin_x CNV.y_row_ctx+CNV.margin_y CNV.w_col1 20], "String", "Choose Context-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_context");
// clear_zoom_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x, CNV.y_row_zoom,CNV.w_col2,20], "String", "Clear Zoom", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "clear_zoom");
// close_figs_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x, CNV.y_row_zoom-CNV.delta_y_zoom,CNV.w_col2,20], "String", "Close Figs", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "close_figs");
// choose_run_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col1+2*CNV.margin_x CNV.y_row_choose_run+CNV.margin_y CNV.w_col1 20], "String", "Choose Run-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_run");
// choose_mrun_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col1+2*CNV.margin_x CNV.y_row_mult+CNV.margin_y CNV.w_col1 20], "String", "Choose Mult File-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_runlist");
// mrun_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col1+2*CNV.margin_x CNV.y_row_mult+CNV.margin_y-25 CNV.w_col1 20], "String", "Run Multiples", ...
    "BackgroundColor",[.6 .7 .6], "fontsize", 14, ...
    "Callback", "run_mult");
// edit_run_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x CNV.y_row_choose_run+CNV.margin_y-15 50 12], "String", "Edit", ...
    "BackgroundColor",[.8 .7 .7], "fontsize", 10, ...
    "Callback", "edit_run");
// create_runlist_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x CNV.y_row_mult+CNV.margin_y-15 70 12], "String", "Create", ...
    "BackgroundColor",[.93 .93 .93], "fontsize", 10, ...
    "Callback", "create_runlist");
// npssws_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x CNV.y_row_ctx+CNV.margin_y-15 70 12], "String", "npssWS", ...
    "BackgroundColor",[.7 .7 .8], "fontsize", 10, ...
    "Callback", "npss_WS");
// edit_runfile_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x+75 CNV.y_row_mult+CNV.margin_y-15 50 12], "String", "Edit", ...
    "BackgroundColor",[.8 .7 .7], "fontsize", 10, ...
    "Callback", "edit_runfile_list_file");
// choose_plot_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position",[CNV.x_col1+2*CNV.margin_x CNV.y_row_choose_plot+CNV.margin_y CNV.w_col1 20], "String", "Choose Plot-->", ...
    "BackgroundColor",[.9 .9 .9], "fontsize", 14, ...
    "Callback", "choose_plot");
// edit_plot_file_button
uicontrol(gui_sim, "style","pushbutton", ...
    "Position", [CNV.x_col3+CNV.margin_x CNV.y_row_choose_plot+CNV.margin_y-15 50 12], "String", "Edit", ...
    "BackgroundColor",[.8 .7 .7], "fontsize", 10, ...
    "Callback", "edit_plot_file");

// Initial displays
disp_context_file_base();
disp_run_file_base();
display_load_data();
display_mruns();
disp_plot_file_base();

