function txt = tget_date()
%-----------------------------------------------------------------------------
%
% Syntax:   txt = tget_date
%
% Purpose:  Returns a text string of same format as get_date function.
%
% Inputs:   none
%
% Outputs:  txt - a string with the date and time
%
% Calls:    clock
%
% Author:   K.Koenig  10-19-89
% Modified: J.Beseler 07-15-91
%
%-----------------------------------------------------------------------------

     clock;  t = clock;

     year  = num2str(t(1)-1900);      hour = num2str(t(4));
     month = num2str(t(2));           mnt  = num2str(t(5)); 
     day   = num2str(t(3));         % sec  = num2str(round(t(6)));

     if length(mnt) < 2,
         mnt = ['0',mnt];
     end

     txt = [month,'-',day,'-',year ,' ',hour, ':',mnt];
