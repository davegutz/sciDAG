// Add this to a debug block (found on 'User-Defined Functions' palette)
if flag==1 & phase_simulation()==1 then
    unit=mopen('scicoslog.dat', 'a');
    if scicos_debug_count()==1 then mfprintf(unit,'SIMULATION DATE '+date()+'\n'),end
    if scicos_debug_count()-int(scicos_debug_count()/2)*2>0 then
        mfprintf(unit,'Block number: %3d at time %8.6f \n',curblock(),scicos_time())
        for i=1:size(block.inptr)
            IN=strcat(string(block.inptr(i)'),';')
            mfprintf(unit,' Input number '+string(i)+' is ['+IN+']\n')
        end
    else
        for i=1:size(block.outptr)
            OUT=strcat(string(block.outptr(i)'),';')
            mfprintf(unit,' Output number '+string(i)+' is ['+OUT+']\n')
        end
    end
    mclose(unit)
end
