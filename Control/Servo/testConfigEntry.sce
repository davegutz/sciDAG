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
exec('p_struct.sci')
p_struct('sys', sys);
