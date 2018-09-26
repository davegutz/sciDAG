getd('../../ControlLib')

// Read from file
M = csvRead('configEntry.csv',[],[],'string');
[nrow, ncol] = size(M);
Mnames = csvRead('configEntry.csv',[],[],'string',[],[],[2 1 nrow 1]);
Mvals =  csvRead('configEntry.csv',[],[],'string',[],[],[2 2 nrow ncol]);
j = 2
for i=1:nrow-1
    execstr(Mnames(i)+'='+Mvals(i,j))
end

// Recursive extraction experiment
// exec('p_struct.sci', -1)
p_struct(sys, 'sys');
p_struct(sys, 'sys', 6, ';');

fd = mopen('temp.txt', 'wt');
p_struct(sys, 'sys', fd, ';');
mclose(fd);
if (isdef('editor') | (funptr('editor')<>0)) then
    editor('temp.txt');
end
