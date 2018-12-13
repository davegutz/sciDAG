// Notch filter example of section 11.5

tf = syslin('c',1/(10*%s + 1) + 1/(%s^2 + %s + 100));
G = iodelay(tf,1/10);

C = syslin('c',(%s^2 + %s + 81)/(%s^2 + 18*%s + 81));
GC = iodelay(tf*C,1/10);

bode([G;GC],0.001,1000,"rad")
