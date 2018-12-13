// Phase lead example
// See section 11.2 in the notes
// Also has the phase lag compensator of section 11.3
G = syslin('c', 1 / (%s^2 + %s));
show_margins(G);
// PM > 50, but cross over frequency is 0.786. Too low
figure("BackgroundColor",[1,1,1])
show_margins(10*G)
// Cross over frequency > 3, but PM = 18

// We want 50-18 = 32 degrees phase advance, at w = 3
w_a = 3;
alpha = (1 - sin(32*%pi/180)) / (1 + sin(32*%pi/180));
w_L = w_a * sqrt(alpha);
C_lead = syslin('c',(%s + w_L)/(alpha*%s + w_L));

figure("BackgroundColor",[1,1,1])
bode(C_lead*G, "rad")
xstring(3,-14,["gain at" "$\omega$" " = 3 is -14dB"]);
xs = get("hdl");
xs.font_size = 4;

k = 10^(14/20);
C_lead = C_lead * k;

figure("BackgroundColor",[1,1,1])
show_margins(C_lead*G)

// Finally include the lag design for better steady state performance

C_lag = syslin('c',(%s + 0.05)/(%s + 0.005))
figure("BackgroundColor",[1,1,1])
show_margins(C_lag*C_lead*G)
