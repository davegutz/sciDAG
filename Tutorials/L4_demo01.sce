// Demo code to show how to run xcos files
// Set parameters and play with them

// Load xcos
loadScicos();
loadXcosLibs();

// Open xcos file
current_directory = get_absolute_file_path('L4_demo01.sce');
importXcosDiagram(current_directory + "L4_sim_ol_second_b.zcos");

T = 100; // end time for simulation
w = 0.1; // frequency of injected sine wave
z = 0.1; // damping ratio

//Set the end time for the simulation
scs_m.props.tf = T;

//Main program loop
while w < 10
    w = 1.1 * w;
    scs_m.props.context = ["w = "+string(w) "z = "+string(z)]
    xcos_simulate(scs_m,4);
    clf();
    plot(U.time,U.values,Y.time,Y.values);
    mtlb_axis([0 T -5 5]);
    f = gcf(); f.visible = "on";
    xstring(50,0.7,["w = "+string(w);"Press SPACE to continue or Ctrl and Space to exit."]);
    t = get("hdl")
    t.alignment = 'center';
    t.clip_state = 'off';
    t.data = [13,6.05];
    t.font_size = 3;
    a = f.children;
    a.data_bounds=[0 -5;T 5]
    [a b c] = xclick();
    while(a~=32)
        [a b c] = xclick();
        if(a == 1032) then return; end
    end
end
