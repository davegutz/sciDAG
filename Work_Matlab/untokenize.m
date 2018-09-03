function default(varS, valS)
% 15-Oct-2015   DA Gutz         Created
%
try evalin('caller', sprintf('temp = %s;', varS));
catch ERR %#ok<NASGU>
    evalin('caller', sprintf('%s = %s;', varS, valS))
end
function timeStamp = getStamp(fp)
% function timeStamp = getStamp(fp)
% Get time stamp of a file path; return 0 if non-existant

dfp = dir(fp);
if isempty(dfp),
    timeStamp = 0;
else
    timeStamp = dfp.datenum;
end

function hardfigurecolor(fig, name, tag)
% HARDFIGURECOLOR.	Generate hardcopy output of a figure.
% function hardfigurecolor(fig, name, tag)
% Sample usage:	hardfigure(1, 'Open Loop')  % creates single eps file
% Author:	D. A. Gutz
% Written:	24-Feb-98	Create.	from hardfigures.m
% Revisions:    25-Aug-03       Add hardenable
%               24-Feb-04       Port to PC
% Input:
% fig		    Number of figure.
% name          Root name
% tag           Integer file tag

% Differential IO:
% none.

% Local:
% none.

% Functions called:
% lpp		ascii printer

% Parameters.
% none.

% Componenets.
% none.

if ~exist('./figures'), mkdir('figures'), end
set(0,'CurrentFigure', fig)
% figure(fig)
prnote = 'Information.  The information on this sheet is subject to the restrictions on the cover sheet or first page.';
tgdate = tget_date;
% p      = mtit(prnote,'fontsize',7,'color',[0 0 0],'xoff',-.06,'yoff',-1.12);
% Add prop info statement to 'South' (just inside figure)
% This will have to do until modify textLoc to modify 'buffer' argument
p       = textLoc([prnote ' ' tgdate],'South','fontsize',7);
orient portrait
if tag < 10,
    tagk=['print -depsc -tiff -r300 ./figures/' name '00' int2str(tag)];
    tagf=['hgsave (''./figures/' name '00' int2str(tag) ''')'];
    disp(sprintf('writing ./figures/%s00%s.eps and ./figures/%s00%s.fig...', name, int2str(tag), name, int2str(tag)))
elseif tag > 99,
    tagk=['print -depsc -tiff -r300 ./figures/' name '' int2str(tag)];
    tagf=['hgsave (''./figures/' name '' int2str(tag) ''')'];
    disp(sprintf('writing ./figures/%s%s.eps and ./figures/%s%s.fig...', name, int2str(tag), name, int2str(tag)))
else
    tagk=['print -depsc -tiff -r300 ./figures/' name '0' int2str(tag)];
    tagf=['hgsave (''./figures/' name '0' int2str(tag) ''')'];
    disp(sprintf('writing ./figures/%s0%s.eps and ./figures/%s0%s.fig...', name, int2str(tag), name, int2str(tag)))
end
% eval(tagk);
% eval(tagf);
orient landscape
disp(sprintf('appending ../figures/%s.ps', name))
tagp=['print -dpsc2 -fillpage -append ./figures/' name '.ps'];
eval(tagp);

% par = mtit(text[,tmp(s)])
% par = mtit(figh,text[,tmp(s)])
%		creates title of an invisible axis
%		surrounding all axes in the figure
%		identified by handle <gcf>/<figh>
%
% figh	:	a valid figure handle		[def: gcf]
% text	:	title string
% tmp(s):	title modifier pair(s)		[see: get(text)]
%	:	additional pairs in <mtit>
%  xoff	:	+/- displacement along X	[def: 0]
%  yoff	:	+/- displacement along Y	[def: 0]
%  zoff	:	+/- displacement along Z	[def: 0]
%
% par	:	parameter structure
%  .pos :	position of surrounding axis
%   .ah :	handle of invisible surrounding box
%   .th :	handle of title
%
% % example
%	subplot(2,3,[1 3]);		title('PLOT 1');
%	subplot(2,3,4); 		title('PLOT 2');
%	subplot(2,3,5); 		title('PLOT 3');
%	axes('units','inches',...
%	     'color',[0 1 .5],...
%	     'position',[.5 .5 2 2]);	title('PLOT 41');
%	axes('units','inches',...
%	     'color',[0 .5 1],...
%	     'position',[3.5 .5 2 2]);	title('PLOT 42');
%	shg;
%	p=mtit('the BIG title',...
%	     'fontsize',14,'color',[1 0 0],...
%	     'xoff',-.1,'yoff',.025);
% % refine title using its handle <p.th>
%	set(p.th,'edgecolor',.5*[1 1 1]);

% created:
%	us	24-Feb-2003		/ R13
% modified:
%	us	24-Feb-2003		/ CSSM
%	us	06-Apr-2003 21:21:11	/ TMW

%--------------------------------------------------------------------------------
function	par=mtit(varargin)

		defunit='normalized';
	if	nargout
		par=[];
	end

% check input
	if	nargin < 1
		help(mfilename);
		return;
	end
		vl=logical(ones(size(varargin)));
	if	ishandle(varargin{1})
		figh=varargin{1};
		txt=varargin{2};
		vl(1:2)=0;
	else
		figh=gcf;
		txt=varargin{1};
		vl(1)=0;
	end
		vin=varargin(vl);
		[off,vout]=get_off(vin{:});

% find surrounding box
		ah=findall(figh,'type','axes');
	if	isempty(ah)
        fprintf('mtit> no axis');
		return;
	end
		ou=get(ah,'units');
		set(ah,'units',defunit);
		ap=get(ah,'position');
	if	iscell(ap)
		ap=cell2mat(get(ah,'position'));
	end
		ap=[min(ap(:,1)) max(ap(:,1)+ap(:,3)) ...
			min(ap(:,2)) max(ap(:,2)+ap(:,4))];
		ap=[ap(1) ap(3) ...
		ap(2)-ap(1) ap(4)-ap(3)];
% create axis ...
		xh=axes('position',ap);
% ... and title
		th=title(txt,vout{:});
		tp=get(th,'position');
		set(th,'position',tp+off);
		set(xh,'visible','off');
		set(th,'visible','on');

% reset original units
		ix=find(~strcmp(lower(ou),defunit));
	if	~isempty(ix)
	for	i=ix(:).'
		set(ah(i),'units',ou{i});
	end
	end

	if	nargout
		par.pos=ap;
		par.ah=xh;
		par.th=th;
	end

		return;
%--------------------------------------------------------------------------------

function	[off,vout]=get_off(varargin)

% search for pairs <.off>/<value>
		off=[];
	for	mode={'xoff' 'yoff' 'zoff'};
		ix=strcmp(varargin,mode);
	if	any(ix)
		yx=find(ix);
		ix(yx+1)=1;
		off(end+1)=varargin{yx(1)+1};
		varargin=varargin(xor(ix,1));
	else
		off(end+1)=0;
	end
	end
		vout=varargin;
		return;
%--------------------------------------------------------------------------------




function hardfigurecolorX(fig, name, tag, last)
% HARDFIGURECOLOR.	Generate hardcopy output of a figure.
% function hardfigurecolor(fig, name, tag)
% Sample usage:	hardfigure(1, 'Open Loop')  % creates single eps file
% Author:	D. A. Gutz
% Written:	24-Feb-98	Create.	from hardfigures.m
% Revisions:    25-Aug-03       Add hardenable
%               24-Feb-04       Port to PC
% Input:
% fig		    Number of figure.
% name          Root name
% tag           Integer file tag

% Differential IO:
% none.

% Local:
% none.

% Functions called:
% lpp		ascii printer

% Parameters.
% none.

% Componenets.
% none.

if ~exist('../figures'), mkdir('../figures'), end
figure(fig),
set(0,'CurrentFigure',fig)
prnote = 'Information.  The information on this sheet is subject to the restrictions on the cover sheet or first page.';
% p      = mtit(prnote,'fontsize',7,'color',[0 0 0],'xoff',-.06,'yoff',-1.12);
% Add prop info statement to 'South' (just inside figure)
% This will have to do until modify textLoc to modify 'buffer' argument
p       = textLoc(prnote,'South','fontsize',7);
orient portrait
if tag == last,
    if getStamp(['../figures/' name '.ps']) > 0,
        delete(['../figures/' name '.ps']);
        fprintf('deleting ../figures/%s.ps\n', name);
    end
end
if tag < 10,
    tagk=['print -depsc -tiff -r300 ../figures/' name '00' int2str(tag)];
    tagf=['hgsave (''../figures/' name '00' int2str(tag) ''')'];
    disp(sprintf('writing %s figure %s ...', name, int2str(tag)))
elseif tag > 99,
    tagk=['print -depsc -tiff -r300 ../figures/' name '' int2str(tag)];
    tagf=['hgsave (''../figures/' name '' int2str(tag) ''')'];
    disp(sprintf('writing %s figure %s ...', name, int2str(tag)))
else
    tagk=['print -depsc -tiff -r300 ../figures/' name '0' int2str(tag)];
    tagf=['hgsave (''../figures/' name '0' int2str(tag) ''')'];
    disp(sprintf('writing %s figure %s...', name, int2str(tag)))
end
% eval(tagk);
% eval(tagf);
orient landscape
disp(sprintf('appending ../figures/%s.ps', name))
tagp=['print -dpsc2 -append ../figures/' name '.ps'];
eval(tagp);

% par = mtit(text[,tmp(s)])
% par = mtit(figh,text[,tmp(s)])
%		creates title of an invisible axis
%		surrounding all axes in the figure
%		identified by handle <gcf>/<figh>
%
% figh	:	a valid figure handle		[def: gcf]
% text	:	title string
% tmp(s):	title modifier pair(s)		[see: get(text)]
%	:	additional pairs in <mtit>
%  xoff	:	+/- displacement along X	[def: 0]
%  yoff	:	+/- displacement along Y	[def: 0]
%  zoff	:	+/- displacement along Z	[def: 0]
%
% par	:	parameter structure
%  .pos :	position of surrounding axis
%   .ah :	handle of invisible surrounding box
%   .th :	handle of title
%
% % example
%	subplot(2,3,[1 3]);		title('PLOT 1');
%	subplot(2,3,4); 		title('PLOT 2');
%	subplot(2,3,5); 		title('PLOT 3');
%	axes('units','inches',...
%	     'color',[0 1 .5],...
%	     'position',[.5 .5 2 2]);	title('PLOT 41');
%	axes('units','inches',...
%	     'color',[0 .5 1],...
%	     'position',[3.5 .5 2 2]);	title('PLOT 42');
%	shg;
%	p=mtit('the BIG title',...
%	     'fontsize',14,'color',[1 0 0],...
%	     'xoff',-.1,'yoff',.025);
% % refine title using its handle <p.th>
%	set(p.th,'edgecolor',.5*[1 1 1]);

% created:
%	us	24-Feb-2003		/ R13
% modified:
%	us	24-Feb-2003		/ CSSM
%	us	06-Apr-2003 21:21:11	/ TMW

%--------------------------------------------------------------------------------
function	par=mtit(varargin)

		defunit='normalized';
	if	nargout
		par=[];
	end

% check input
	if	nargin < 1
		help(mfilename);
		return;
	end
		vl=logical(ones(size(varargin)));
	if	ishandle(varargin{1})
		figh=varargin{1};
		txt=varargin{2};
		vl(1:2)=0;
	else
		figh=gcf;
		txt=varargin{1};
		vl(1)=0;
	end
		vin=varargin(vl);
		[off,vout]=get_off(vin{:});

% find surrounding box
		ah=findall(figh,'type','axes');
	if	isempty(ah)
        fprintf('mtit> no axis');
		return;
	end
		ou=get(ah,'units');
		set(ah,'units',defunit);
		ap=get(ah,'position');
	if	iscell(ap)
		ap=cell2mat(get(ah,'position'));
	end
		ap=[min(ap(:,1)) max(ap(:,1)+ap(:,3)) ...
			min(ap(:,2)) max(ap(:,2)+ap(:,4))];
		ap=[ap(1) ap(3) ...
		ap(2)-ap(1) ap(4)-ap(3)];
% create axis ...
		xh=axes('position',ap);
% ... and title
		th=title(txt,vout{:});
		tp=get(th,'position');
		set(th,'position',tp+off);
		set(xh,'visible','off');
		set(th,'visible','on');

% reset original units
		ix=find(~strcmp(lower(ou),defunit));
	if	~isempty(ix)
	for	i=ix(:).'
		set(ah(i),'units',ou{i});
	end
	end

	if	nargout
		par.pos=ap;
		par.ah=xh;
		par.th=th;
	end

		return;
%--------------------------------------------------------------------------------
function	[off,vout]=get_off(varargin)

% search for pairs <.off>/<value>
		off=[];
	for	mode={'xoff' 'yoff' 'zoff'};
		ix=strcmp(varargin,mode);
	if	any(ix)
		yx=find(ix);
		ix(yx+1)=1;
		off(end+1)=varargin{yx(1)+1};
		varargin=varargin(xor(ix,1));
	else
		off(end+1)=0;
	end
	end
		vout=varargin;
		return;
%--------------------------------------------------------------------------------

function [H]=textLoc(varargin)
% function [H]=textLoc('string',location[,parameter,value,...])
%
% Puts string onto the current axes with location similar to legend locations.
% Passes all parameter, value pairs to text. textLoc works with semilog and 
% loglog plots.
% 
% H is the handle from the text command after modifications by textLoc.
%
% location can also be a 1x2 cell array containing {location,buffer} where
%   buffer is a spacing buffer (in normalized units) for distance from the axes.
%   buffer default is 1/50
%
% location can be any of:
%        'North'                   inside plot box near top
%        'South'                   inside bottom
%        'East'                    inside right
%        'West'                    inside left
%        'Center'                  centered on plot
%        'NorthEast'               inside top right (default)
%        'NorthWest'                inside top left
%        'SouthEast'               inside bottom right
%        'SouthWest'               inside bottom left
%        'NorthOutside'            outside plot box near top
%        'SouthOutside'            outside bottom
%        'EastOutside'             outside right
%        'WestOutside'             outside left
%        'NorthEastOutside'        outside top right
%        'NorthWestOutside'        outside top left
%        'SouthEastOutside'        outside bottom right
%        'SouthWestOutside'        outside bottom left
%        'NorthEastOutsideAbove'   outside top right (above)
%        'NorthWestOutsideAbove'   outside top left (above)
%        'SouthEastOutsideBelow'   outside bottom right (below)
%        'SouthWestOutsideBelow'   outside bottom left (below)
%        'Random'                  Random placement inside axes
% or
%       1 = Upper right-hand corner (default)
%       2 = Upper left-hand corner
%       3 = Lower left-hand corner
%       4 = Lower right-hand corner
%      -1 = To the right of the plot
%
% EXAMPLES:
%  figure(1); x=0:.1:10; y=sin(x); plot(x,y);
%  t=textLoc('North','North')
%  t=textLoc('southeastoutside',{'southeastoutside',1/20},'rotation',90)
%  t=textLoc('SouthEast',4)
%  t=textLoc('West',{'west',.1})
%  t=textLoc('northwest',{2,.3},'Color','red')
%  t=textLoc({'\downarrow','south'},'south')
%  t=textLoc('SWRot',{3},'rotation',45)
%  t=textLoc('NEOAbove',{'NorthEastOutsideAbove',0},'FontSize',8)
%  t=textLoc('textLoc','center','edgecolor','black','fontsize',20)

%testall={'North','South','East','West','Center','NorthEast','NorthWest','SouthEast','SouthWest','NorthOutside','SouthOutside','EastOutside','WestOutside','NorthEastOutside','NorthWestOutside','SouthEastOutside','SouthWestOutside','NorthEastOutsideAbove','NorthWestOutsideAbove','SouthEastOutsideBelow','SouthWestOutsideBelow','Random'};for i=1:length(testall),textLoc(testall{i},testall{i}); end

% Author: Ben Barrowes, barrowes@alum.mit.edu


if nargin<2
 varargin{2}=1;
end

% send all but 2nd arg to text
tArg=true(1,length(varargin)); tArg(2)=false;
H=text(0,0,varargin{tArg});

%locationing and 2nd arg handling
loc=varargin{2};
buffer=1/50;
if iscell(loc)
 if length(loc)==0
  loc=1;
 elseif length(loc)==1
  loc=loc{1};
 elseif length(loc)>1
  buffer=loc{2};
  loc=loc{1};
 end
end
if isnumeric(loc)
 loc=num2str(loc);
end

% set the text position
set(H,'units','normalized');
switch lower(loc)
  case 'north' %              inside plot box near top
    set(H,'Position',[.5,1-buffer]);
    set(H,'HorizontalAlignment','Center');
    set(H,'VerticalAlignment','Top');
  case 'south' %              inside bottom
    set(H,'Position',[.5,  buffer]);
    set(H,'HorizontalAlignment','Center');
    set(H,'VerticalAlignment','Bottom');
  case 'east' %               inside right
    set(H,'Position',[1-buffer,.5]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Middle');
  case 'west' %               inside left
    set(H,'Position',[  buffer,.5]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Middle');
  case 'center' %               inside left
    set(H,'Position',[.5,.5]);
    set(H,'HorizontalAlignment','Center');
    set(H,'VerticalAlignment','Middle');
  case {'northeast','1'} %          inside top right (default)
    set(H,'Position',[1-buffer,1-buffer]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Top');
  case {'northwest','2'} %           inside top left
    set(H,'Position',[  buffer,1-buffer]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Top');
  case {'southeast','4'} %          inside bottom right
    set(H,'Position',[1-buffer,  buffer]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Bottom');
  case {'southwest','3'} %          inside bottom left
    set(H,'Position',[  buffer,  buffer]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Bottom');
  case 'northoutside' %       outside plot box near top
    set(H,'Position',[.5,1+buffer]);
    set(H,'HorizontalAlignment','Center');
    set(H,'VerticalAlignment','Bottom');
  case 'southoutside' %       outside bottom
    set(H,'Position',[.5, -buffer]);
    set(H,'HorizontalAlignment','Center');
    set(H,'VerticalAlignment','Top');
  case 'eastoutside' %        outside right
    set(H,'Position',[1+buffer,.5]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Middle');
  case 'westoutside' %        outside left
    set(H,'Position',[ -buffer,.5]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Middle');
  case {'northeastoutside','-1'} %   outside top right
    set(H,'Position',[1+buffer,1]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Top');
  case 'northwestoutside' %   outside top left
    set(H,'Position',[ -buffer,1]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Top');
  case 'southeastoutside' %   outside bottom right
    set(H,'Position',[1+buffer,0]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Bottom');
  case 'southwestoutside' %   outside bottom left
    set(H,'Position',[ -buffer,0]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Bottom');
  case 'northeastoutsideabove' %   outside top right (above)
    set(H,'Position',[1,1+buffer]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Bottom');
  case 'northwestoutsideabove' %   outside top left (above)
    set(H,'Position',[0,1+buffer]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Bottom');
  case 'southeastoutsidebelow' %   outside bottom right (below)
    set(H,'Position',[1, -buffer]);
    set(H,'HorizontalAlignment','Right');
    set(H,'VerticalAlignment','Top');
  case 'southwestoutsidebelow' %   outside bottom left (below)
    set(H,'Position',[0, -buffer]);
    set(H,'HorizontalAlignment','Left');
    set(H,'VerticalAlignment','Top');
  case 'random' % random placement
    set(H,'Position',[rand(1,2)]);
    set(H,'HorizontalAlignment','Center');
    set(H,'VerticalAlignment','Middle');
  otherwise
    error('location (4th argument) not recognized by textLoc')
end

hdr = {'%INFORMATION:'
'%552(b)(4).'};


function area = hole(x, d);
% @(#)hole.m 1.2 93/06/22
% HOLE.		Calculate hole area as a function of uncovered length.
% Author:     Dave Gutz 09-Jun-90.
% Revisions:  None.

% Inputs:
% x		Spool edge relative to start of hole.
% d		Hole diameter.

% Local:
% r		Hole radius.
% frac		Fraction of hole uncovered.
% frac		Fraction of hole uncovered.

r	= d / 2.;
x	= max((min(x, d - 1e-16)), 1e-16);
frac	= 1. - x / r;

if(frac > 1e-16),
	area	= atan( sqrt(1. - frac * frac) / frac);
elseif(frac < -1e-16),
	area	= pi + atan( sqrt(1. - frac * frac) / frac);
else
	area	= pi / 2.;
end
area	= r * r * area   -   (r - x) * sqrt(x * (2.*r - x));
area	= max(area, 1e-16);

function [sys, dp] = ip_wtodp(a, b, c, d, r1, ~, r2, b2, rpm, wf, sg, tau)
% function [sys, dp] = ip_wtodp(a, b, c, d, r1, ~, r2, b2, rpm, wf, sg, tau)
% function sys = ip_wtodp(a, b, c, r1, b1, r2, b2, rpm, wf, sg, tau);
% Impeller model, flow and discharge pressure to supply.
% Author:   D. A. Gutz
% Written:  08-Jul-92
% Revisions: 19-Aug-92 Simplify return arguments.
%
% Input:
% a     Pump head coefficients.
% b              "
% c              "
% d              "
% r1    Inner radius, in.
% b1    Inner disk width, in.
% r2    Outer radius, in.
% b2    Outer disk width, in.
% rpm   Speed.
% wf    Flow, pph.
% sg    Specific gravity.
% tau   Time constant, sec.
%
% Differential IO:
% wf  Input #  1, flow, pph.
% ps  Input #  2, supply pressure, psi.
% rpm Input #  3, speed, rpm.
% pd  Output # 1, discharge pressure, psi.
%
% Output:
% sys   Packed system of Input and Output.
% pd-ps Pressure rise, psid

% Local:
% q  Connection matrix.
% u  Input matrix.
% y  Output matrix.


% States:
% none.

% Functions called:
% None.

% Parameters.
% fc    Flow coefficient.
% dwdc  Conversion cis to pph.
dwdc = 129.93948 * sg;
fc   = 5.851 * wf / dwdc / (3.85 * b2 * r2^2 * rpm);
hc   = a + (b + (c + d*fc)*fc)*fc;
dp   = 1.022e-6 * hc * sg * (r2^2 - r1^2) * rpm^2;

% Partials.
% dfcdwf  Flow coefficient due to flow, 1/pph.
% dhcdfc  Head coefficient due to flow coefficient.
% dpdhc   Pressure due to head coefficient, psi.
% dfcdrpm Flow coefficient due to speed, 1/rpm.
dfcdwf  = fc / wf;
dhcdfc  = b + 2 * c * fc;
dpdhc   = 1.022e-6 * sg * (r2^2 - r1^2) * rpm^2;
dfcdrpm = -fc / rpm;

% Connections and system construction.
as  = -1/tau;
bs  = [dfcdwf*dhcdfc*dpdhc/tau 0 dfcdrpm*dhcdfc*dpdhc/tau];
cs  = -1;
es  = [0 1 0];
sys = pack_ss(as, bs, cs, es);
function wf = la_kptow(k, ps, pd, kvis)
% function wf = la_kptow(k, ps, pd, kvis)
% Laminar orifice function, area/pressure to flow.
% Author:    D. A. Gutz
% Written:   22-Jun-92
% Revisions: None.
%
% Input:
% k    Laminar coefficient
% pd   Discharge pressure, psia.
% ps   Supply pressure, psia.
% kvis Kinematic viscosity, centistokes
%
% Output:
% wf		Flow, pph.

% Functions called:

% Perform:
wf = k / kvis * (ps - pd);
function k = la_wptok(wf, ps, pd, kvis)
% function k = la_wptok(wf, ps, pd, kvis)
% Laminar orifice function, area/pressure to flow.
% Author:    D. A. Gutz
% Written:   22-Jun-92
% Revisions: None.
%
% Input:
% wf		Flow, pph.
% pd   Discharge pressure, psia.
% ps   Supply pressure, psia.
% kvis Kinematic viscosity, centistokes
%
% Output:
% k    Laminar coefficient

% Perform:
k = wf* kvis / (ps - pd);
function [zeta] = Mp2Zeta(Mp)
%   zeta	Mp	 MpdB
zeta2Mp = [0.001	500.00025	53.97940443
0.005	100.00125	40.00010857
0.01	50.00250019	33.9798344
0.02	25.0050015	27.9605377
0.03	16.67417173	24.4408854
0.04	12.51001202	21.94515454
0.05	10.01252349	20.01087096
0.06	8.348373955	18.43203789
0.07	7.160421719	17.09877202
0.08	6.270096515	15.94548452
0.09	5.578193172	14.929871
0.1	5.025189076	14.02304814
0.11	4.573206651	13.20441653
0.12	4.196994604	12.45876822
0.13	3.879071672	11.77455608
0.14	3.606951622	11.14280635
0.15	3.371478249	10.55640724
0.16	3.16578476	10.00962768
0.17	2.984620419	9.497782118
0.18	2.823901664	9.016991388
0.19	2.680404962	8.564008265
0.2	2.551551815	8.136087843
0.21	2.435255197	7.730889576
0.22	2.329807864	7.346402137
0.23	2.233799812	6.980885
0.24	2.146056363	6.632822478
0.25	2.065591118	6.300887149
0.26	1.991569763	5.983910479
0.27	1.923281923	5.680858993
0.28	1.860119048	5.390814799
0.29	1.801556873	5.112959539
0.3	1.747141395	4.846561069
0.31	1.696477552	4.590962346
0.32	1.649220043	4.345572081
0.33	1.605065806	4.109856852
0.34	1.563747831	3.883334407
0.35	1.525030036	3.665567948
0.36	1.488702996	3.456161248
0.37	1.454580369	3.254754439
0.38	1.422495888	3.061020395
0.39	1.392300822	2.874661594
0.4     1.363861814	2.6954074
0.41	1.337059042	2.523011709
0.42	1.311784651	2.357250899
0.43	1.287941396	2.197922044
0.44	1.265441486	2.044841366
0.45	1.24420558	1.897842894
0.46	1.224161917	1.756777297
0.47	1.205245571	1.621510885
0.48	1.187397793	1.491924749
0.49	1.170565452	1.367914041
0.5     1.154700538	1.249387366
0.51	1.139759746	1.136266292
0.52	1.1257041	1.028484961
0.53	1.112498644	0.925989807
0.54	1.100112168	0.828739365
0.55	1.088516982	0.736704177
0.56	1.077688727	0.649866798
0.57	1.067606218	0.568221893
0.58	1.058251328	0.491776442
0.59	1.049608894	0.420550043
0.6     1.041666667	0.354575339
0.61	1.034415282	0.293898556
0.62	1.02784827	0.238580185
0.63	1.021962101	0.188695813
0.64	1.016756262	0.144337119
0.65	1.012233377	0.105613068
0.66	1.008399371	0.072651325
0.67	1.00526369	0.045599922
0.68	1.002839569	0.024629232
0.69	1.001144381	0.009934287
0.7     1.00020006	0.001737525
0.707	1.000000046	3.96094E-07];
zeta = interp1(zeta2Mp(:,2), zeta2Mp(:,1), Mp, 'linear', 0);
return
function [Z, MOD] = numCond(Z, MOD, E)
% 11-Apr-2016       DA Gutz     Created
% Revisions

%
switch(MOD.condition)
    case {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
        Z.awfb  = E.sawfb(MOD.condition);
        Z.pcn25 = E.spcn25(MOD.condition);
        Z.xn25  = Z.pcn25*172.1;
        Z.wf36  = E.swf(MOD.condition);
        Z.pamb  = MOD.cpstd;
        sfxven  = E.sfxven(MOD.condition);
        if sfxven, Z.fxven = sfxven; end
        clear sfxven
        MOD.run = {sprintf('%05.0f%#, N25=%5.0frpm, Wf=%5.0fpph, %4.1fpsia', Z.fxven, Z.xn25, Z.wf36, Z.pamb)};
    otherwise
        error('Unknown conditon = %ld', MOD.condition);
end
function wf = or_aptow(a, ps, pd, cd, sg)
% function wf = or_aptow(a, ps, pd, cd, sg);
% Square law orifice function, area/pressure to flow.
% Author:    D. A. Gutz
% Written:   22-Jun-92
% Revisions: None.
%
% Input:
% a    Orifice area, sqin.
% cd   Coefficient of discharge.
% pd   Discharge pressure, psia.
% ps   Supply pressure, psia.
% sg   Specific gravity.
%
% Output:
% wf		Flow, pph.

% Functions called:
% ssqrt		Signed square root.

% Perform:
wf = a * 19020. * cd * ssqrt(sg * (ps - pd));
function ps = or_awtop(a, wf, pd, cd, sg)
% function ps = or_awtop(a, wf, pd, cd, sg);
% Square law orifice function, area/flow to pressure.
% 22-Jun-1992 DA Gutz   Written
% 20-May-2016 DA Gutz   Fixed bug sg was inside parenthesis
%
% Input:
% a    Orifice area, sqin.
% cd   Coefficient of discharge.
% pd   Discharge pressure, psia.
% sg   Specific gravity.
% wf   Flow, pph.
%
% Output:
% ps   Supply pressure, psia.

% Functions called:
% ssqr		Signed square.

% Perform:
ps = pd + ssqr(wf / 19020. / max(a, 1e-12) / cd) / sg;
function a = or_wptoa(wf, ps, pd, cd, sg)
% function a = or_wptoa(wf, ps, pd, cd, sg);
% Square law orifice function, flow/pressure to area.
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	17-Oct-96	Trap divide by cd=0.
%
% Input:
% cd    Coefficient of discharge.
% pd    Discharge pressure, psia.
% ps    Supply pressure, psia.
% sg    Specific gravity.
% wf    Flow, pph.
%
% Output:
% a		Calculated orifice area, sqin.

% Functions called:
% ssqrt	Signed square root.

% Perform:
psmpd	= sgn(ps - pd) * max(abs(ps - pd), 1e-16);
a	= wf / ssqrt(sg * psmpd) / max(cd, 1e-16) / 19020.;
function SortedStruct = OrderAllFields(StructToSort)
% function SortedStruct = OrderAllFields(StructToSort)
%
% Sorts all fieldnames in a structure array alphabetically
% on all levels.
% Recursive function.
%
if ~isstruct(StructToSort)
  SortedStruct = StructToSort;
  if iscell(SortedStruct)
    for iCell = 1:numel(SortedStruct)
      SortedStruct{iCell} = OrderAllFields(SortedStruct{iCell});
    end
  end
else
  SortedStruct = orderfields(StructToSort);
  SortedFields = fieldnames(SortedStruct);
  for iField = 1:length(SortedFields)
    SortedStruct.(SortedFields{iField}) = ...
      OrderAllFields(SortedStruct.(SortedFields{iField}));
  end
end

return
function sys = pack_ss(a,b1,b2,c1,c2,e11,e12,e21,e22)
% PACK_SS	Form a system from component matrices.
%
% Syntax: SYS = PACK_SS(A,B1,B2,C1,C2,E11,E12,E21,E22) or ...
%         SYS = PACK_SS(A,B1,B2,C1,C2) or ...
%         SYS = PACK_SS(A,B,C,E) or ...
%         SYS = PACK_SS(A,B,C)
%
% Purpose:	The first version of PACK_SS 'packs' a full set of
%		nine matrices defining a TITO system into a single
%		data element.  The function uses the NaN (not_a_number)
%		symbol to denote partitioning between the A, B, C, and
%		E sections and the Inf (infinity) symbol to denote
%		partitioning between B1 and B2, C1 and C2, and E11, E12,
%		E21, and E22.  If the A matrix is empty, a static system
%		made up only of the partitioned E matrix is returned
%
%		The second version creates an appropiate identically zero 
%		partitioned E matrix to complete the TITO system.
%
%		The third version 'packs' the four matrices of a SISO
%		state-space realization into a single data element using
%		the NaN symbol to denote partitioning.
%
%		The fourth version creates an identically zero E matrix to
%		complete the SISO system.
%
% Input:	A,B1,B2,C1,E11,E12,E21,E22 - Regular matrices denoting
%		   the elements of a TITO state-space system, or ...
%		A,B,C,E - Regular matrices denoting the elements of 
%		   a SISO state-space system.
%		(Note that the dimensions of these matrices must be 
%		   conformable in either case.)
%
% Output:	SYS -  Resulting packed matrix system, with state
%		   dimension equal to the dimension of A.
%
% See Also:	UNPACK_SS, MAT2SYS, SYS2MAT

% Calls: 
%
% Called By:


%**********************************************************************

%
% --- SISO case ---
% 
% Check Arguements
%
if nargin == 3 | nargin == 4,
   %
   % Check dimensions of a, b, c
   %
   b = b1; c = b2;
   [ma,na] = size(a); [mb,nb] = size(b); [mc,nc] = size(c);
   if (ma ~= na) | (mb ~= ma) | (nc ~= na),
      error('Matrix dimensions are incompatible for packing')
   end
   %
   % Now check dimension of e matrix or build it with zeros
   %
   if nargin == 3,
      e = zeros(mc,nb);
   else
      e = c1; [me,ne] = size(e);
      if ((me ~= mc) | (ne ~= nb)) & ~isempty(a),
	 error('Matrix dimensions are incompatible for packing')
      end
   end
%
% Calculations
%
   if isempty(a),
      sys = e;
   else
      sys = [a nan*ones(ma,1) b; nan*ones(1,ma+1+nb); c nan*ones(mc,1) e];
   end

%**********************************************************************

%
% --- TITO case ---
%
% Check Arguments
%

elseif nargin == 5 | nargin == 9,
   %
   % Check dimensions of a, b1, b2, c1, and c2 matrices
   %
   [ma,na] = size(a);
   [mb1,nb1] = size(b1); [mb2,nb2] = size(b2);
   [mc1,nc1] = size(c1); [mc2,nc2] = size(c2);
   if (ma ~= na) | (mb1 & (mb1 ~= ma)) | (mb2 & (mb2 ~= ma)) | ...
                   (mc1 & (nc1 ~= na)) | (mc2 & (nc2 ~= na))
      error('Matrix dimensions are incompatible for packing')
   end
   %
   % Now build any missing e matrices and check e matrix dimensions
   %
   if nargin == 5,
      e11 = zeros(mc1,nb1); e12 = zeros(mc1,nb2);
      e21 = zeros(mc2,nb1); e22 = zeros(mc2,nb2);
   end
   [me11,ne11] = size(e11); [me12,ne12] = size(e12);
   [me21,ne21] = size(e21); [me22,ne22] = size(e22);
   %
   % when a is not empty we have the dynamic system case
   %
   if ~isempty(a),
      if ((mb1 & mc1) & (me11 ~= mc1 | ne11 ~= nb1)) | ...
         ((mb2 & mc1) & (me12 ~= mc1 | ne12 ~= nb2)) | ...
         ((mb1 & mc2) & (me21 ~= mc2 | ne21 ~= nb1)) | ...
         ((mb2 & mc2) & (me22 ~= mc2 | ne22 ~= nb2)),
        error('Matrix dimensions are incompatible for packing')
      elseif ((~mb1 | ~mc1) & (me11 ~= 0)) | ...
             ((~mb2 | ~mc1) & (me12 ~= 0)) | ...
             ((~mb1 | ~mc2) & (me21 ~= 0)) | ...
             ((~mb2 | ~mc2) & (me22 ~= 0)),
            error('Matrix dimensions are incompatible for packing')
      end
      %
      % Calculation
      %
      sys = [a nan*ones(ma,1) b1 inf*ones(ma,1) b2 
             nan*ones(1,na+nb1+nb2+2)
             c1 nan*ones(mc1,1) e11 inf*ones(mc1,1) e12
             inf*ones(1,na) nan inf*ones(1,nb1+nb2+1)
             c2 nan*ones(mc2,1) e21 inf*ones(mc2,1) e22];
   %
   % if a is empty we have the static system case
   %
   else
      if ((me11 & me21) & (ne11 ~= ne21)) | ...
	 ((ne11 & ne12) & (me11 ~= me12)) | ...
	 ((ne21 & ne22) & (me21 ~= me22)) | ...
	 ((me12 & me22) & (ne12 ~= ne22)),
         error('Matrix dimensions incompatible for packing')
      end
      %
      % Calculation
      %
      sys = [e11 inf*ones(max([me11 me12]),1) e12
             inf*ones(1,max([ne11+ne12+1 ne21+ne22+1]))
             e21 inf*ones(max([me21 me22]),1) e22];
   end
	     
%**********************************************************************

%
% If neither the normal case nor the TITO case, print error
%

else
   error('Invalid number of input arguments to PACK_SS')
end

function [P, DV, lastFig]= plot_F414_FuelSystem(bdroot, titleName, E, lastFig, swHcopy, desc)
% function [DV, lastFig} = plot_F414_FuelSystem(ifcname, venname, titlename, lastFig, swHcopy, desc)
% plot full F414 fuel system
% 16-Jun-2016   DA Gutz     Created
% Plot cdf file reading
% Inputs:
% ifcname       Name ifc.dat
% venname       Name ven.dat
% titlename     Name .titl
% lastFig       last used figure number (starts with lastFig+1)[0]
% swHcopy       hardcopy command [0]
% Outputs:
% DV             The data
% lastFig   The number of the latest figure
% Sample usage:  > [DV, lastFig]= plot_F414_FuelSystem('opLine06_INS6.ifc.dat', 'opLine06_INS6.ven.dat', 'opLine06_INS6.titl', 0, 0)
% plot 0 and make hardcopies of the plots for recorP.


%%Initialize
warning off 'MATLAB:linkaxes:RequireDataAxes'
clear DV
nax     = 0;
naxN    = 0;

%%From GRC:  Assign log variables to workspace
% lognames = logsout.getElementNames;
% for k=1:numel(lognames)
%     logname_var = ['LOG_' regexprep(lognames{k},'(\W)','_')];
%     assignin('caller',logname_var,logsout.getElement(lognames{k}).Values);
% end

%%Read in the data
dat         = evalin('base', 'logsout.getElement(''VEN'')');
DV          = dat.Values;
dat         = evalin('base', 'logsout.getElement(''MAIN'')');
DM          = dat.Values;
clear dat
P.time      = DM.eng.ps3.Time;
P.ps3       = DM.eng.ps3.Data;
P.ng        = DM.eng.xn25.Data*100/E.N25100Pct;
P.wf36      = DM.eng.wf36.Data;
P.mv_x      = DM.ifc.Calc.Comp.fmv.mv.Result.x.Data;
P.mvsv_x    = DM.ifc.Calc.Comp.fmv.mvsv.SPOOL.x.Data;
P.mvtv_x    = DM.ifc.Calc.Comp.mvtv.Result.x.Data;
P.hs_x      = DM.ifc.Calc.Comp.hs.Result.x.Data;
P.check_x   = P.hs_x*0 -.2;
P.prt_x     = P.hs_x*0 -.2;
P.fvg_x     = P.hs_x*0 -.5;
P.cvg_x     = P.hs_x*0 -.5;
P.p1c       = DM.ifc.Calc.Press.p1c.Data;
P.p2        = DM.ifc.Calc.Press.p2.Data;
P.p3        = DM.ifc.Calc.Press.p3.Data;
P.prt       = DM.ifc.Calc.Press.prt.Data;
P.pr        = DM.ifc.Calc.Press.pr.Data;
P.pd        = DM.ifc.PD.Data;
P.px        = DM.ifc.Calc.Press.px.Data;
P.ptank     = DM.ac.Mon_ABOOST.ptank.Data;
P.pengine   = DM.ac.Mon_ABOOST.pengine.Data;
P.poc       = DM.supply.Calc.POC.Data;
P.pocs      = DM.supply.Calc.POCS.Data;
P.pmainp    = DM.supply.Calc.PMAINP.Data;
P.pb1       = DM.bvs.Calc.PB1.Data;
P.pb2       = DM.bvs.Calc.PB2.Data;
P.psven     = DM.bvs.PSVEN.Data;
P.wffilt    = DM.bvs.Calc.WFFILT.Data;
P.wf1p      = DM.ifc.WF1P.Data;
P.wfengine  = DM.supply.WFENGINE.Data;
P.wftank    = DM.ac.Mon_ABOOST.wftank.Data;
P.wfb2      = DM.supply.Calc.WFB2.Data;
P.wfabocx1  = DM.supply.Calc.WFABOCX1.Data;
P.wfocmx1   = DM.supply.Calc.WFOCMX1.Data;
P.wf1cx     = DM.ifc.Calc.Flow.wf1cx.Data;
P.wf1c      = DM.ifc.Calc.Flow.wf1c.Data;
P.wf1mv     = DM.ifc.Calc.Flow.wf1mv.Data;
P.wf3       = DM.ifc.Calc.Flow.wf3.Data;
P.wfmd      = DM.ifc.In.wfmd.Data;
P.wf1vg     = DM.ifc.In.wf1vg.Data;
P.wf1v      = DM.ifc.In.wf1v.Data;
P.wftvb     = DM.ifc.Calc.Flow.wftvb.Data;

%%Titles etc
if ~exist('saves', 'dir'), mkdir('saves'), end
lastFigIn = lastFig+1;
titleStr    = sprintf('%s_%s', bdroot, desc);
fileStr    = sprintf('%s_%s', bdroot, titleName);


%%Plots

% Figure 1
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,1);
plot(P.time, [P.ng]);
ylim([-5 115]);
grid;xlabel('Time, s');ylabel('see legend');legend({'N25, %'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 122, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,2);
plot(P.time, [P.ps3]);
ylim([0 500]);
grid;xlabel('Time, s');ylabel('see legend');legend({'PS3, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
nax         = nax + 1;
axTIME(lastFigIn, nax)  = subplot(3,1,3);
plot(P.time, [P.wf36]);
ylim([0 20000]);
grid;xlabel('Time, s');ylabel('see legend');legend({'WF36, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 2
lastFig     = lastFig+1;
figure(lastFig);clf;
naxN         = naxN + 1;
axNGR(lastFigIn, naxN)    = subplot(2,1,1);
plot(P.ng, [P.ps3]);
ylim([0 580]);
grid;xlabel('NG, %');ylabel('see legend');legend({'PS3, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(75.99, 580, fileStr,'fontsize',6, 'interpreter', 'none');
naxN         = naxN + 1;
axNGR(lastFigIn, naxN)  = subplot(2,1,2);
plot(P.ng, [P.wf36]);
ylim([0 20000]);
grid;xlabel('NG, %');ylabel('see legend');legend({'WF36, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 3
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,1);
plot(P.time, [P.mv_x P.mvsv_x P.mvtv_x P.hs_x P.check_x P.prt_x]);
ylim([-0.2 0.7]);
grid;xlabel('Time, s');ylabel('see legend');legend({'mv_x, in', 'mvsv_x, in', 'mvtv_x, in', 'hs_x, in', 'check_x, in', 'prt_x, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 0.723, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,2);
plot(P.time, [P.fvg_x P.cvg_x]);
ylim([-0.5 4]);
grid;xlabel('Time, s');ylabel('see legend');legend({'fvg_x, in', 'cvg_x, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 4
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,1);
plot(P.time, [P.ptank P.pengine P.pb1 P.pb2 P.psven P.pmainp]);
grid;xlabel('Time, s');ylabel('see legend');legend({'ptank, psia', 'pengine, psia', 'pb1, psia', 'pb2, psia', 'psven, psia', 'pmainp, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 206, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,2);
plot(P.time, [P.wftank P.wfengine P.wffilt P.wfb2 P.wfocmx1 P.wf1p]);
grid;xlabel('Time, s');ylabel('see legend');legend({'wftank, pph', 'wfengine, pph', 'wffilt, pph', 'wfb2, pph', 'wfocmx1, pph', 'wf1p, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 5
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,1);
plot(P.time, [P.p1c P.p2 P.p3 P.prt P.pr P.pd P.px]);
grid;xlabel('Time, s');ylabel('see legend');legend({'p1c, psia', 'p2, psia', 'p3, psia', 'prt, psia', 'pr, psia', 'pd, psia', 'px, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 2130, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,2);
plot(P.time, [P.wf1cx P.wf1c P.wf1mv P.wf3 P.wfmd P.wf1vg P.wf1v P.wftvb]);
grid;xlabel('Time, s');ylabel('see legend');legend({'wf1cx, pph', 'wf1c, pph', 'wf1mv, pph', 'wf3, pph', 'wfmd, pph', 'wf1vg, pph', 'wf1v, pph', 'wftvb, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,3);
plot(P.time, P.p2-P.p3);
grid;xlabel('Time, s');ylabel('see legend');legend({'p2-p3, psid'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


%%Synchronize x-axes
linkaxes(axTIME,'x');
if exist('axNGR', 'var'), linkaxes(axNGR,'x'); end %#ok<*NODEF>

if swHcopy,
    for figNum = lastFigIn:1:lastFig,
        hardfigurecolor(figNum, sprintf('%s_%s', bdroot, titleName), figNum-lastFigIn+1)
    end
end

warning on 'MATLAB:linkaxes:RequireDataAxes'

return
   
% plot_opLine_lti_F414_FuelSystemPlot
% Plot results of exercise full F414 fuel system
% 7-Jan-2013   DA Gutz     Created


% Model path
if L.swINS6
    modelPath = 'F414_Fuel/Main/';
else
    modelPath = 'F414_Fuel/Main/';
end
modelTopPath = 'F414_Fuel';


clear SYS
L.wmax1 = 10000*2*pi;  % 3e3;
L.fmax1   = 10000;   %100
L.wmax2   = 10000*2*pi; % 600;
L.wmax3   = 10000*2*pi;   % 3e4
L.fmax2   = 10000;  % 6e3
L.fmax3   = 10000;  % 6e2
L.fmax4   = 10000;  % 100
%%Open loop response pump Fig 1
if L.swPPUMP
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodePUMP=L.nfigs; figure(M.figBodePUMP);
        M.PPUMP = bodeoptions('cstprefs');
        M.PPUMP.PhaseWrapping='off'; M.PPUMP.Grid='on'; M.PPUMP.FreqScale='log';
        M.PPUMP.Title.Interpreter = 'none';
        M.PPUMP.OutputLabels.Interpreter = 'none';
        M.PPUMP.InputLabels.Interpreter = 'none';
        M.PPUMP.Title.String = '';
        M.PPUMP.MagLowerLimMode = 'manual';
        M.PPUMP.MagLowerLim = -80;
        M.PPUMP.FreqUnits = 'Hz';
        M.PPUMP.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodePUMP) = {'Pressure Subsystem'}; %#ok<*SAGROW>
    end
    clear LIN
    %     LIN.ioLin(1)    = linio('lti_F414_FuelSystem/eboost', 2, 'in', 'off');
    if L.swbase
        LIN.ioLin(1)    = linio([modelPath 'xn25'], 1, 'in', 'off');
        if swINS6
            LIN.ioLin(2)    = linio([modelPath 'wf1psum'], 1, 'out', 'off');
        else
            LIN.ioLin(2)    = linio([modelPath 'p1sum'], 1, 'out', 'off');
        end
        LIN.ioLin(3)    = linio([modelPath 'mvsub'], 7, 'none', 'on');  % p1 feedback disabled
        LIN.ioLin(4)    = linio([modelPath 'ven'], 2, 'none', 'on');  % wfsven feedback disabled
        LIN.ioLin(5)    = linio([modelPath 'ven'], 3, 'none', 'on');  % wfrven feedback disabled
        LIN.ioLin(6)    = linio([modelPath 'mvsub'], 4, 'none', 'on');  % wfc feedback disabled
        LIN.ioLin(7)    = linio([modelPath 'vgline'], 2, 'none', 'on');  % wfcvy feedback disabled
    else
        LIN.ioLin(1)    = linio([modelPath 'xn25'], 1, 'in', 'off');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6'], 2, 'out', 'off');
    end
    LIN.sys_F414_FuelSystem_PPUMP  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_PPUMP = LIN.sys_F414_FuelSystem_PPUMP;
    figure(M.figBodePUMP); bodeplot(LIN.sys_F414_FuelSystem_PPUMP, M.PPUMP);
    [SYS.pump.mag, SYS.pump.phase, SYS.pump.w] = bode(LIN.sys_F414_FuelSystem_PPUMP, {1, L.wmax1});
    LRES(L.nCases).pump = SYS.pump;
    if ~L.held, hold('on'); end
else
     M.figBodePUMP = 999;
end

%%Closed loop PUMPS Stability Fig 2 and 3
if L.swINLET
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeINLET=L.nfigs; figure(M.figBodeINLET);
        M.INLET = bodeoptions('cstprefs');
        M.INLET.PhaseWrapping='off'; M.INLET.Grid='on'; M.INLET.FreqScale='log';
        M.INLET.Title.Interpreter = 'none';
        M.INLET.OutputLabels.Interpreter = 'none';
        M.INLET.InputLabels.Interpreter = 'none';
        M.INLET.Title.String = '';
        M.INLET.MagLowerLimMode = 'manual';
        M.INLET.MagLowerLim = -80;
        M.INLET.FreqUnits = 'Hz';
        M.INLET.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeINLET) = {'INLET'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/wfengine'], 1, 'in', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost/man_n_vm_inlet'], 2, 'out', 'on');
        LIN.ioLin(3)    = linio([modelPath 'eboost/ip_wpdtops_boost'], 1, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost/man_n_vm_inlet'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/wfengine'], 1, 'in', 'on');             % wfengine
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/man_n_vm_vsin'], 1, 'out', 'on');      % pboost
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/man_n_vm_inlet'], 2, 'none', 'on');     % wfboost
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/man_n_vm_inlet'], 1, 'none', 'on');     % pengine
    end
    LIN.sys_F414_FuelSystem_INLET  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeINLET); bodeplot(LIN.sys_F414_FuelSystem_INLET, M.INLET);
    if ~L.held, hold('on'); end
else
     M.figBodeINLET = 999;
end

%     save ModelData magCLPUMPS wCLPUMPS

if L.swBOOST
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeBOOST=L.nfigs; figure(M.figBodeBOOST);
        M.BOOST = bodeoptions('cstprefs');
        M.BOOST.PhaseWrapping='off'; M.BOOST.Grid='on'; M.BOOST.FreqScale='log';
        M.BOOST.Title.Interpreter = 'none';
        M.BOOST.OutputLabels.Interpreter = 'none';
        M.BOOST.InputLabels.Interpreter = 'none';
        M.BOOST.Title.String = '';
        M.BOOST.MagLowerLimMode = 'manual';
        M.BOOST.MagLowerLim = -80;
        M.BOOST.FreqUnits = 'Hz';
        M.BOOST.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeBOOST) = {'BOOST Pump'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/Gain'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost/ip_wpdtops_boost'], 1, 'out', 'on');
        LIN.ioLin(3)    = linio([modelPath 'eboost/man_n_vm_inlet'], 2, 'in', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost/f414_filter'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/Gain'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/ip_wpstopd_boost'], 1, 'out', 'on');
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/man_n_mv_inlet'], 2, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/mom_1_vsin'], 1, 'in', 'on');
    end
    LIN.sys_F414_FuelSystem_BOOST  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeBOOST); bodeplot(LIN.sys_F414_FuelSystem_BOOST, M.BOOST);
    if ~L.held, hold('on'); end
else
     M.figBodeBOOST = 999;
end

%%Boost subsystem
if L.swBOOSTSYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeBOOSTSYS=L.nfigs; figure(M.figBodeBOOSTSYS);
        M.BOOSTSYS = bodeoptions('cstprefs');
        M.BOOSTSYS.PhaseWrapping='off'; M.BOOSTSYS.Grid='on'; M.BOOSTSYS.FreqScale='log';
        M.BOOSTSYS.Title.Interpreter = 'none';
        M.BOOSTSYS.OutputLabels.Interpreter = 'none';
        M.BOOSTSYS.InputLabels.Interpreter = 'none';
        M.BOOSTSYS.Title.String = '';
        M.BOOSTSYS.MagLowerLimMode = 'manual';
        M.BOOSTSYS.MagLowerLim = -80;
        M.BOOSTSYS.FreqUnits = 'Hz';
        M.BOOSTSYS.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeBOOSTSYS) = {'BOOST SUBSYSTEM'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/wfengine'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost/man_n_mv_fab'], 1, 'in', 'off');
        LIN.ioLin(4)    = linio([modelPath 'eboost/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(6)    = linio([modelPath 'eboost/xn25'], 1, 'none', 'on');
        LIN.ioLin(7)    = linio([modelPath 'eboost/man_n_mm_aboc'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/pengine'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/man_n_mv_fab'], 1, 'in', 'off');
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost_ins6/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(6)    = linio([modelPath 'eboost_ins6/xn25'], 1, 'none', 'on');
        LIN.ioLin(7)    = linio([modelPath 'eboost_ins6/man_n_mm_aboc'], 1, 'none', 'on');
    end
    LIN.sys_F414_FuelSystem_BOOSTSYS  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeBOOSTSYS); bodeplot(LIN.sys_F414_FuelSystem_BOOSTSYS, M.BOOSTSYS);
    if ~L.held, hold('on'); end
else
     M.figBodeBOOSTSYS = 999;
end

%%Boost volume subsystem
if L.swBOOSTVOLSYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeBOOSTVOLSYS=L.nfigs; figure(M.figBodeBOOSTVOLSYS);
        M.BOOSTVOLSYS = bodeoptions('cstprefs');
        M.BOOSTVOLSYS.PhaseWrapping='off'; M.BOOSTVOLSYS.Grid='on'; M.BOOSTVOLSYS.FreqScale='log';
        M.BOOSTVOLSYS.Title.Interpreter = 'none';
        M.BOOSTVOLSYS.OutputLabels.Interpreter = 'none';
        M.BOOSTVOLSYS.InputLabels.Interpreter = 'none';
        M.BOOSTVOLSYS.Title.String = '';
        M.BOOSTVOLSYS.MagLowerLimMode = 'manual';
        M.BOOSTVOLSYS.MagLowerLim = -80;
        M.BOOSTVOLSYS.FreqUnits = 'Hz';
        M.BOOSTVOLSYS.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeBOOSTVOLSYS) = {'BOOST SUBSYSTEM'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/man_n_vm_inlet'], 2, 'in', 'off');
        LIN.ioLin(2)    = linio([modelPath 'eboost/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost/ip_wpdtops_boost'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/ip_wpstopd_boost'], 1, 'in', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost_ins6/man_n_mv_fab'], 1, 'none', 'on');
    end
    LIN.sys_F414_FuelSystem_BOOSTVOLSYS  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeBOOSTVOLSYS); bodeplot(LIN.sys_F414_FuelSystem_BOOSTVOLSYS, M.BOOSTVOLSYS);
    if ~L.held, hold('on'); end
else
     M.figBodeBOOSTVOLSYS = 999;
end



clear SYS
L.wmax1 = 10000*2*pi;  % 3e3;
L.fmax1 = 10000;   %100
L.wmax2 = 10000*2*pi; % 600;
L.wmax3 = 10000*2*pi;   % 3e4
L.fmax2 = 10000;  % 6e3
L.fmax3 = 10000;  % 6e2
L.fmax4 = 120;  % 100

%%Open loop response TV loop Fig 1
if L.swOLTV
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeOLTV=L.nfigs; figure(M.figBodeOLTV);
        M.POLTV = bodeoptions('cstprefs');
        M.POLTV.PhaseWrapping='on'; M.POLTV.Grid='on'; M.POLTV.FreqScale='log';
        M.POLTV.Title.Interpreter = 'none';
        M.POLTV.OutputLabels.Interpreter = 'none';
        M.POLTV.InputLabels.Interpreter = 'none';
        M.POLTV.Title.String = '';
        M.POLTV.MagLowerLimMode = 'manual';
        M.POLTV.MagLowerLim = -100;
        M.POLTV.FreqUnits = 'Hz';
        M.POLTV.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeOLTV) = {'Open Loop Throttling Valve'}; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_IFC/VALVE_A_mvtv/OpenLoopIn'], 1, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'F414_IFC/VALVE_A_mvtv/openLoopOut'], 1, 'out', 'on');
    LIN.sys_F414_FuelSystem_OLTV  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_OLTV = LIN.sys_F414_FuelSystem_OLTV;
    figure(M.figBodeOLTV); bodeplot(LIN.sys_F414_FuelSystem_OLTV, M.POLTV);
    [SYS.oltv.mag, SYS.oltv.phase, SYS.oltv.w] = bode(LIN.sys_F414_FuelSystem_OLTV, {1, L.wmax1});
    [SYS.oltv.gain, SYS.oltv.Pm, SYS.oltv.Wp, SYS.oltv.Wg]    = margin(SYS.oltv.mag, SYS.oltv.phase, SYS.oltv.w);
    SYS.oltv.Gm = 20*log10(SYS.oltv.gain);
    SYS.oltv.fp     = SYS.oltv.Wp/2/pi;
    SYS.oltv.fg     = SYS.oltv.Wg/2/pi;
    LRES(L.nCases).oltv = SYS.oltv;
    if ~L.held, hold('on'); end
else
     M.figBodeOLTV = 999;
end


%%Closed loop MFP Stability Fig 2 and 3
if L.swCLMFP
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeCLMFP=L.nfigs; figure(M.figBodeCLMFP);
        M.POLMFP = bodeoptions('cstprefs');
        M.POLMFP.PhaseWrapping='on'; M.POLMFP.Grid='on';
        M.POLMFP.Title.Interpreter = 'none';
        M.POLMFP.OutputLabels.Interpreter = 'none';
        M.POLMFP.InputLabels.Interpreter = 'none';
        M.POLMFP.Title.String = '';
        M.POLMFP.FreqScale='linear';
        M.POLMFP.PhaseVisible='off';
        M.POLMFP.Ylim = [-40 60];   % 20 is zeta=.05
        M.POLMFP.FreqUnits='Hz';
        M.POLMFP.Xlim = [0 L.fmax3];
        L.figTitle(M.figBodeCLMFP) = {'Pump Sensitivity'}; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_SUPPLY_BUS'], 4, 'inout', 'off');
    LIN.sys_F414_FuelSystem_CLMFP  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeCLMFP); bodeplot(LIN.sys_F414_FuelSystem_CLMFP, M.POLMFP);
    [magCLMFP, ~, wCLMFP] = bode(LIN.sys_F414_FuelSystem_CLMFP);
    maxMagCLMFP     = max(magCLMFP);
    wMaxMagCLMFP    = min(wCLMFP(find(magCLMFP >= max(magCLMFP)))); %#ok<FNDSB>
    LRES(L.nCases).clmfp.magDB   = 20*log10(maxMagCLMFP);
    LRES(L.nCases).clmfp.zeta    = Mp2Zeta(maxMagCLMFP);
    LRES(L.nCases).clmfp.fn      = wMaxMagCLMFP/sqrt(1-2*LRES(L.nCases).clmfp.zeta^2)/2/pi;
    if ~L.held, hold('on'); end
else
     M.figBodeCLMFP = 999;
end

% save ModelData magCLMFP wCLMFP

if L.swCLMFPS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeCLMFPs=L.nfigs; figure(M.figBodeCLMFPs);
        M.POLMFPs = bodeoptions('cstprefs');
        M.POLMFPs.PhaseWrapping='on'; M.POLMFP.Grid='on';
        M.POLMFPs.Title.Interpreter = 'none';
        M.POLMFPs.OutputLabels.Interpreter = 'none';
        M.POLMFPs.InputLabels.Interpreter = 'none';
        M.POLMFPs.Title.String = '';
        M.POLMFPs.FreqScale='linear';
        M.POLMFPs.PhaseVisible='off';
        M.POLMFPs.Ylim = [-40 60];   % 20 is zeta=.05
        M.POLMFPs.FreqUnits='Hz';
        M.POLMFPs.Xlim = [0 L.fmax4];
        L.figTitle(M.figBodeCLMFPs) = {'Pump Sensitivity Zoom'}; %#ok<*SAGROW>
    end
    if ~L.swCLMFP
        clear LIN
        LIN.ioLin(1)    = linio([modelPath 'F414_SUPPLY_BUS'], 4, 'inout', 'off');
        LIN.sys_F414_FuelSystem_CLMFP  = linearize(modelTopPath, LIN.ioLin);
    end
    figure(M.figBodeCLMFPs); bodeplot(LIN.sys_F414_FuelSystem_CLMFP, M.POLMFPs);
    [magCLMFPs, ~, wCLMFPs] = bode(LIN.sys_F414_FuelSystem_CLMFP, {0.01, 2*pi*L.fmax1});
    maxMagCLMFPs     = max(magCLMFPs);
    wMaxMagCLMFPs    = min(wCLMFPs(find(magCLMFPs >= max(magCLMFPs)))); %#ok<FNDSB>
    LRES(L.nCases).clmfps.magDB   = 20*log10(maxMagCLMFPs);
    LRES(L.nCases).clmfps.zeta    = Mp2Zeta(maxMagCLMFPs);
    LRES(L.nCases).clmfps.fn      = wMaxMagCLMFPs/sqrt(1-2*LRES(L.nCases).clmfps.zeta^2)/2/pi;
    if ~L.held, hold('on'); end
else
     M.figBodeCLMFPs = 999;
end

%%Closed loop response full system Fig 4 and Fig 5
if L.swCL
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeCL=L.nfigs; figure(M.figBodeCL);
        M.PCL = bodeoptions('cstprefs');
        M.PCL.PhaseWrapping='off'; M.PCL.Grid='on'; M.PCL.FreqScale='log';
        M.PCL.Title.Interpreter = 'none';
        M.PCL.OutputLabels.Interpreter = 'none';
        M.PCL.InputLabels.Interpreter = 'none';
        M.PCL.Title.String = '';
        M.PCL.MagLowerLimMode = 'manual';
        M.PCL.MagLowerLim = -100;
        M.PCL.Ylim = [-180 180];
        M.PCL.FreqUnits='Hz';
        M.PCL.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeCL) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_IFC/FMV/HALFVALVE_LAG_mv/Position'], 1, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'F414_ENGINE_SYSTEM/wf36'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeCL); bodeplot(LIN.sys_F414_FuelSystem, M.PCL);
    if ~L.held, hold('on'); end
else
     M.figBodeCL = 999;
end

% Step Wf demand
if L.swCLSTP
    if stepWfDmd
        if ~L.held
            L.nfigs = L.nfigs+1; figure(L.nfigs); M.figStepL=L.nfigs;
            L.figTitle(M.figStepL) = L.title; %#ok<*SAGROW>
        end
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_IFC/FMV/HALFVALVE_LAG_mv/Position'], 1, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'F414_ENGINE_SYSTEM/wf36q1000'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem = LIN.sys_F414_FuelSystem;
    if stepWfDmd
        t       = 0:0.00001:0.4;
        figure(M.figStepL); step(LIN.sys_F414_FuelSystem, t);
        if ~L.held, hold('on'); end
    end
    % Transients
    if ~L.held
        L.nfigs = L.nfigs+1; M.figStep=L.nfigs; figure(M.figStep);
        L.figTitle(M.figStep) = L.title; %#ok<*SAGROW>
    end
    t       = 0:0.000001:0.4;
    y     = step(LIN.sys_F414_FuelSystem, t);
    switch(testCase)
        case 'ven'
            yout = [yout y(:,2,2)*L.wfldvenStep];
        otherwise
            yout = [yout y(:,1,1)*L.wfStep];
    end
else
     M.figStepL = 999;
     M.figStep  = 999;
end


clear SYS

if L.swOLVEN
    %%Open loop response VEN loop Fig 6
    if ~L.held
        L.nfigs = L.nfigs+1; figure(L.nfigs); M.figBodeOLVEN=L.nfigs;
        M.POLVEN = bodeoptions('cstprefs');
        M.POLVEN.Grid='on'; M.POLVEN.FreqScale='log';
        M.POLVEN.PhaseWrapping = 'on';
        M.POLVEN.Title.Interpreter = 'none';
        M.POLVEN.OutputLabels.Interpreter = 'none';
        M.POLVEN.InputLabels.Interpreter = 'none';
        M.POLVEN.Title.String = '';
        M.POLVEN.MagLowerLimMode = 'manual';
        M.POLVEN.MagLowerLim = -100;
        M.POLVEN.FreqUnits='Hz';
        M.POLVEN.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeOLVEN) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'ven/vensubpress/pumpActVenPistonVen'], 3, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'ven/vensubpress/Gain'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem_OLVEN  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_OLVEN = LIN.sys_F414_FuelSystem_OLVEN;
    figure(M.figBodeOLVEN); bodeplot(LIN.sys_F414_FuelSystem_OLVEN, M.POLVEN);
    [SYS.olven.mag, SYS.olven.phase, SYS.olven.w] = bode(LIN.sys_F414_FuelSystem_OLVEN, {1, L.wmax1}, M.POLVEN);
    [SYS.olven.gain, SYS.olven.Pm, SYS.olven.Wp, SYS.olven.Wg]    = margin(SYS.olven.mag, SYS.olven.phase, SYS.olven.w);
    SYS.olven.fp    = SYS.olven.Wp/2/pi;
    SYS.olven.fg    = SYS.olven.Wg/2/pi;
    SYS.olven.Gm = 20*log10(SYS.olven.gain);
    LRES(L.nCases).olven = SYS.olven;
    if ~L.held, hold('on'); end
else
     M.figBodeOLVEN = 999;
end


if L.swVGD
    %%Disturbance response FVG/CVG Fig 7
    clear SYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeVGD=L.nfigs; figure(M.figBodeVGD);
        M.POLVGD = bodeoptions('cstprefs');
        M.POLVGD.PhaseWrapping='on'; M.POLVGD.Grid='on'; M.POLVGD.FreqScale='log';
        M.POLVGD.Title.Interpreter = 'none';
        M.POLVGD.OutputLabels.Interpreter = 'none';
        M.POLVGD.InputLabels.Interpreter = 'none';
        M.POLVGD.Title.String = '';
        M.POLVGD.MagLowerLimMode = 'manual';
        M.POLVGD.MagLowerLim = 0;
        M.POLVGD.FreqUnits = 'Hz';
        M.POLVGD.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeVGD) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelTopPath 'afvg'], 1, 'in', 'off');
    LIN.ioLin(2)    = linio([modelTopPath 'acvg'], 1, 'in', 'off');
    LIN.ioLin(3)    = linio([modelPath 'mvsub'], 3, 'out', 'off');
    LIN.ioLin(4)    = linio([modelPath 'eboost'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem_VGD  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_VGD = LIN.sys_F414_FuelSystem_VGD;
    figure(M.figBodeVGD); bodeplot(LIN.sys_F414_FuelSystem_VGD, M.POLVGD, {0.6, L.wmax2});
    if ~L.held, hold('on'); end
else
     M.figBodeVGD = 999;
end

if L.swVG
    %%Transfer response FVG/CVG Fig 8
    clear SYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeVGT=L.nfigs; figure(M.figBodeVGT);
        M.POLVGT = bodeoptions('cstprefs');
        M.POLVGT.PhaseWrapping='on'; M.POLVGT.Grid='on'; M.POLVGT.FreqScale='log';
        M.POLVGT.Title.Interpreter = 'none';
        M.POLVGT.OutputLabels.Interpreter = 'none';
        M.POLVGT.InputLabels.Interpreter = 'none';
        M.POLVGT.Title.String = '';
        M.POLVGT.MagLowerLimMode = 'manual';
        M.POLVGT.MagLowerLim = 0;
        M.POLVGT.FreqUnits = 'Hz';
        M.POLVGT.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeVGT) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelTopPath 'afvg'], 1, 'in', 'off');
    LIN.ioLin(2)    = linio([modelTopPath 'acvg'], 1, 'in', 'off');
    LIN.ioLin(3)    = linio([modelPath 'vgActLine'], 1, 'out', 'off');
    LIN.ioLin(4)    = linio([modelPath 'vgActLine'], 2, 'out', 'off');
    LIN.sys_F414_FuelSystem_VGT  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_VGT = LIN.sys_F414_FuelSystem_VGT;
    figure(M.figBodeVGT); bodeplot(LIN.sys_F414_FuelSystem_VGT, M.POLVGT, {0.6, L.wmax2});
    if ~L.held, hold('on'); end
else
     M.figBodeVGT = 999;
end

%%Open loop response SV loop Fig 9
if L.swSV
    clear SYS
    olSave  = D.startValve.openLoop;
    D.startValve.openLoop = 1;
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeOLSV=L.nfigs; figure(M.figBodeOLSV);
        M.POLSV = bodeoptions('cstprefs');
        M.POLSV.PhaseWrapping='on'; M.POLSV.Grid='on'; M.POLSV.FreqScale='log';
        M.POLSV.Title.Interpreter = 'none';
        M.POLSV.OutputLabels.Interpreter = 'none';
        M.POLSV.InputLabels.Interpreter = 'none';
        M.POLSV.Title.String = '';
        M.POLSV.MagLowerLimMode = 'manual';
        M.POLSV.MagLowerLim = -100;
        M.POLSV.FreqUnits = 'Hz';
        M.POLSV.Xlim = [0.6 L.fmax2];
        L.figTitle(M.figBodeOLSV) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'ven/xsvOL'], 1, 'in', 'off');
    LIN.ioLin(2)    = linio([modelPath 'ven/GainOLSV'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem_OLSV  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_OLSV = LIN.sys_F414_FuelSystem_OLSV;
    figure(M.figBodeOLSV); bodeplot(LIN.sys_F414_FuelSystem_OLSV, M.POLSV);
    [SYS.olsv.mag, SYS.olsv.phase, SYS.olsv.w] = bode(LIN.sys_F414_FuelSystem_OLSV, {1, L.wmax3});
    [SYS.olsv.gain, SYS.olsv.Pm, SYS.olsv.Wp, SYS.olsv.Wg]    = margin(SYS.olsv.mag, SYS.olsv.phase, SYS.olsv.w);
    SYS.olsv.Gm = 20*log10(SYS.olsv.gain);
    SYS.olsv.fp     = SYS.olsv.Wp/2/pi;
    SYS.olsv.fg     = SYS.olsv.Wg/2/pi;
    LRES(L.nCases).olsv = SYS.olsv;
    if ~L.held, hold('on'); end
    D.startValve.openLoop     = olSave;
else
     M.figBodeOLSV = 999;
end

%Sleep 5
myTimer = timer('TimerFcn','fprintf(''Made plots'')','StartDelay',5);
start(myTimer)
wait(myTimer)
clear myTimer
% runLTI_Study
% exercise full F414 fuel system
% 29-Nov-2012   DA Gutz     Created
% 18-Apr-2013   DA Gutz     ICD conditons called out


%%User inputs - make sure to use correct user input file and comment out others


% Initialize
clear L GEO MOD M LRES E F FP LIN V Z D COMP
bdclose all; close all; close all hidden
if ~exist('./figures', 'dir'), mkdir('./figures'), end
L.swHcopy = 1;



[nTok, tokens, ctokens]=tokenize(gcs, '/');
MOD.linearizing = 1;
MOD.swven = 0;
if isempty(tokens) || ~strcmp(tokens{1}, 'F414_Fuel')
    load_system('F414_Fuel')
    % Prevent strange algebraic loop error
    set_param('F414_Fuel','AlgebraicLoopSolver','LineSearch')
end
stepWfDmd = 0;      % 1 to run linear lti step response.   Usually doesn't work
Z.handTuning = 0;
L.swHcopy = 1;


try
    %%Top of redo loop
    % Critical inputs: all these inputs may be typed at command line or added to UserIn_TV or a
    % file called by it.
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('testCase',     '''default''');   % Operating condition
    default('L.overplot',       '0');       % ???
    default('L.swUseFile',      '0');       % use input file for From Workspace transients running
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.wfStep',         '50');      % wf pph metering step size when running in time mode (ignored)
    default('L.wfldvenStep',    '0');       % ven load pph step size for swsimpleven when running in time mode (ignored)
    default('L.sw_pipe',        '0');       % 0 = engine, 1=HON pipe, 2=handvalve
    default('L.swPPUMP',        '0');       % 1 = plot compare pumps
    default('L.swINLET',        '0');       % 1 = plot compare pumps
    default('L.swBOOST',        '0');       % 1 = plot compare pumps
    default('L.swBOOSTSYS',     '0');       % 1 = plot compare pumps
    default('L.swBOOSTVOLSYS',  '0');       % 1 = plot compare pumps
    default('L.swOLVEN',        '0');       % 1 = plot open loop VEN
    default('L.swOLTV',         '1');       % 1 = plot open loop throttle valve
    default('L.swCLMFP',        '0');       % 1 = plot closed loop MFP sensitivity response
    default('L.swCLMFPS',       '1');       % 1 = plot closed loop SCALED MFP sensitivity response
    default('L.swCL',           '0');       % 1 = plot closed loop fuel response
    default('L.swCLSTP',        '0');       % 1 = plot closed loop fuel response step
    default('L.swVGD',          '0');       % 1 = plot VG disturbance
    default('L.swVG',           '0');       % 1 = plot VG transfer response
    default('L.swSV',           '0');       % 1 = plot start valve transfer response
    default('L.swComparePumps',           '0');
    
    %%Loop
    [nRedo,~] = size(caseVector);
    redo = nRedo > 0;
    if ~redo, nRedo = 1; end
    if ~L.overplot, clear L.nCases M, end
    for iRedo = 1:nRedo
        try temp = L.nCases; %#ok<NASGU>
        catch ERR
            L.held      = 0;
            L.nCases    = 0;
            M.leg       = {};
            yout        = [];
            L.nfigs     = 0;
            close all
            clear LRES legOLVEN legOLTV legCLMFP OLD
        end
        MOD.linearizing = 1;    % Initialization control in .slx file for clean init IC
        
        Z.INPUTS_TUNE_T_C_S_D_V = caseVector{iRedo};
        Z.desc = Z.INPUTS_TUNE_T_C_S_D_V{1};
        Z.strC = Z.INPUTS_TUNE_T_C_S_D_V{2};
        Z.strS = Z.INPUTS_TUNE_T_C_S_D_V{3};
        Z.strD = Z.INPUTS_TUNE_T_C_S_D_V{4};
        
        InitFcn_F414_Fuel
        
        L.nCases          = L.nCases + 1;
        M.leg(L.nCases)   = {sprintf('%ld', L.nCases)};
        
        LRES(L.nCases).GEO    = GEO; %#ok<*SAGROW>
        OLD(L.nCases).GEO     = GEO;  OLD(L.nCases).MOD     = MOD;
        OLD(L.nCases).ic      = ic;
        
        
        %%Calculate and plot responses
        MOD = OrderAllFields(MOD);
        ic  = OrderAllFields(ic);
        L   = OrderAllFields(L);
        if L.nCases==1, fprintf('%s\n', char(sprintf('F414_Fuel-%s%s, %6.0f/%6.4f/%3.3f', char(Z.strC), char(Z.strS), FP.beta, FP.sg, FP.kvis))); end
        fprintf('Case %ld of %ld:...', L.nCases, nRedo);
        plot_opLine_lti_F414_FuelSystem
        L.held = 1;
        COMP(L.nCases).StudyName  = StudyName;
        COMP(L.nCases).source     = Z.strC;
        COMP(L.nCases).MOD        = MOD;
        COMP(L.nCases).Z          = Z;
        COMP(L.nCases).FP         = FP;
        COMP(L.nCases).ic         = ic;
        COMP(L.nCases).GEO        = GEO;
        
        
        %%Save case title information
        try
            caseTitle{L.nCases}  = Z.desc;
        catch ERR
            caseTitle{L.nCases}  = sprintf('%02ld', L.nCases);
        end
        
        
        %%Plot steps
        if L.swComparePumps
            %%Add legends
            for i = 1:L.nfigs,
                figure(i)
                switch i
                    case M.figBodePUMP
                        for j = 1:L.nCases
                            M.legPUMP{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legPUMP, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeINLET
                        for j = 1:L.nCases
                            M.legINLET{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legINLET, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeBOOST
                        for j = 1:L.nCases
                            M.legBOOST{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legBOOST, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeBOOSTSYS
                        for j = 1:L.nCases
                            M.legBOOSTSYS{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legBOOSTSYS, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeBOOSTVOLSYS
                        for j = 1:L.nCases
                            M.legBOOSTVOLSYS{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legBOOSTVOLSYS, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    otherwise
                        if L.nCases < 11,
                            legend(M.leg, 'interpreter', 'none', 'FontSize', 6)
                        end
                end
            end
        else
            if L.swCLSTP
                figure(M.figStep)
                switch(testCase)
                    case 'start'
                        plot(t, yout),  axis([-0.05 max(t) 0 4]), ylabel('wf36, pph'), grid
                    case {'tv', 'irp', 'slsirp'}
                        plot(t, yout),  axis([-0.05 max(t) 0 4]), ylabel('wf36, pph'), grid
                    case 'ven'
                        plot(t, yout),  axis([-0.05 max(t) -200*abs(wfldvenStep) 200*abs(wfldvenStep)]), ylabel('wflVen, pph'), grid
                    otherwise
                        plot(t, yout),  axis([-0.05 max(t) -2 6]), ylabel('wf36, pph'), grid
                end
            end
            
            %%Calculate title
            if L.nCases==1
                L.title = {sprintf('F414_Fuel-%s-%s, %6.0f/%6.4f/%3.3f', char(StudyName), char(Z.strS), FP.beta, FP.sg, FP.kvis)};
            end
            
            %%Add legends
            for i = 1:L.nfigs,
                figure(i)
                switch i
                    case M.figBodeOLTV
                        for j = 1:L.nCases
                            M.legOLTV{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).oltv.fg, LRES(j).oltv.Gm, LRES(j).oltv.Pm);
                        end
                        legend(M.legOLTV, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeCLMFP
                        for j = 1:L.nCases
                            M.legCLMFP{j} = sprintf('%s-%s: fn/z=%5.1f/%5.2f', M.leg{j}, caseTitle{j}, LRES(j).clmfp.fn, LRES(j).clmfp.zeta);
                        end
                        legend(M.legCLMFP, 'location', 'NorthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeCLMFPs
                        for j = 1:L.nCases
                            M.legCLMFPs{j} = sprintf('%s-%s: fn/z=%5.1f/%5.2f', M.leg{j}, caseTitle{j}, LRES(j).clmfps.fn, LRES(j).clmfps.zeta);
                        end
                        legend(M.legCLMFPs, 'location', 'NorthEast', 'interpreter', 'none', 'FontSize', 6)
                        grid on
                    case M.figBodeCL
                        for j = 1:L.nCases
                            M.legCL{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).oltv.fg, LRES(j).oltv.Gm, LRES(j).oltv.Pm);
                        end
                        legend(M.legCL, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case  M.figStep
                        for j = 1:L.nCases
                            M.legCL{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).oltv.fg, LRES(j).oltv.Gm, LRES(j).oltv.Pm);
                        end
                        legend(M.legCL, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeOLVEN
                        for j = 1:L.nCases
                            M.legOLVEN{j} = sprintf('%s-%s: %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).olven.fg, LRES(j).olven.Gm, LRES(j).olven.Pm);
                        end
                        legend(M.legOLVEN, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeVGD
                        for j = 1:L.nCases
                            M.legVGD{j} = sprintf('%s-%s', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legVGD, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeVGT
                        for j = 1:L.nCases
                            M.legVGD{j} = sprintf('%s-%s', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legVGD, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeOLSV
                        for j = 1:L.nCases
                            M.legOLSV{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).olsv.fg, LRES(j).olsv.Gm, LRES(j).olsv.Pm);
                        end
                        legend(M.legOLSV, 'interpreter', 'none', 'FontSize', 6)
                    otherwise
                        if L.nCases < 11,
                            legend(M.leg, 'interpreter', 'none', 'FontSize', 6)
                        end
                end
            end
        end
        fprintf('\n');
    end
    
    %%Titles
    for i = 1:L.nfigs,
        figure(i)
        h = axes('Position',[0 0 1 1],'Visible','off');
        set(gcf,'CurrentAxes',h)
        text(0.01, 0.980, char(L.title),       'Interpreter', 'none', 'FontSize', 12)
        text(0.05, 0.945, char(L.figTitle(i)), 'Interpreter', 'none', 'FontSize', 10)
    end
    
    
    % Save parameters to csv file
    WriteAllFieldsArray(COMP, ['.\saves\' StudyName] );
    
    
    %%Hardcopy
    L.swHcopy = 1;
    if L.swHcopy,
        for figNum = 1:L.nfigs,
            hardfigurecolor(figNum, StudyName, figNum)
            myTimer = timer('TimerFcn','fprintf(''Made hardcopy\n'')','StartDelay',4);
            start(myTimer)
            wait(myTimer)
        end
        %Sleep 1
        clear myTimer
    end
catch ERR
    MOD.linearizing = 0; %#ok<STRNU>
    clear iRedo i j n t h redo xref temp y yout err
    clear wCLMFP wMaxMagCLMFP xrefALL xrefGE xrefHON xrefSUN
    clear figNum filen filename filenameALL filenameGE filenameSUN
    clear maxMagCLMFP
    clear filenameHON hdr nRedo olSave overplot magCLMFP
    rethrow(ERR)
end

%%Cleanup
% Bring Fig 1 to fore
% Z.handTuning = 0;
MOD.linearizing = 0;
if ~L.swComparePumps, figure(M.figBodeOLTV); end
clear iRedo i j n t h redo xref temp y yout err
clear wCLMFP wMaxMagCLMFP xrefALL xrefGE xrefHON xrefSUN
clear figNum filen filename filenameALL filenameGE filenameSUN
clear maxMagCLMFP
clear filenameHON hdr nRedo olSave overplot magCLMFP
function y = sgn(x);
% SGN.		Safe sign.
%  Author:	D. A. Gutz
%  Written:	09-Apr-93
%  Revisions:	None.

%  Input:
%  x		Real number.

%  Output:
%  y		sign(x)

%  Perform:
if x ~= 0,
	y	= sign(x);
else
	y	= 1;
end
function y = ssqr(x);
% SSQR.	Signed square.
%  Author:	D. A. Gutz
%  Written:	22-Jun-92
%  Revisions:	None.

%  Input:
%  x		Real number.

%  Output:
%  y		sign(x) * x^2

%  Perform:
y	= sign(x) * x^2;
function y = ssqrt(x);
% SSQRT.	Signed square root.
%  Author:	D. A. Gutz
%  Written:	22-Jun-92
%  Revisions:	None.

%  Input:
%  x		Real number.

%  Output:
%  y		sign(x) * sqrt(abs(x))

%  Perform:
y	= sign(x) * sqrt(abs(x));

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

function [ts] = timestamper()
% stamp the time in the output stream
% DA Gutz   14-Sep-10   10_MODEL_122:  streamlined scripts fr
%
% Inputs
% none


c = clock;
cm10 = floor(c(5)/10); cm1 = c(5) - 10*cm10; cs10 = floor(c(6)/10); cs1 = c(6) - 10*cs10;
ts = sprintf('Date: %d/%d/%d   Time: %d:%d%d:%d%2.1f\n', c(1), c(2), c(3), c(4), cm10, cm1, cs10, cs1);
fprintf('%s', ts);
function [nTok, tokens, cTokens] = tokenize(targ, delims)
% function [nTok, tokens, ctokens] = tokenize(targ, delims)
% tokenize using optional delims (default is Matlab default:  'help strtok').  Return number, cell array result, and the ctokens
% stripped (the first ctokens elemement preceeds the first tokens element
% on reconstruction
tokens  = {}; 
nTok    = 0;
ncTok   = 0;
rem     = targ;
cTokens = {};
while true
    oldRem      = rem;
    oldLen      = length(oldRem);
    col1        = strfind(oldRem, rem);
    if nargin == 2,
        [str, rem]  = strtok(oldRem, delims);
    else
        [str, rem]  = strtok(oldRem);
    end
    cLen        = length(rem)-1;
    col2        = strfind(oldRem, rem);
    col3        = strfind(oldRem, str);
%     fprintf('oldRem=%s| rem=%s| str=%s| col1=%ld| col2=%ld| cLen=%ld| col3=%ld|\n', oldRem, rem, str, col1, col2, cLen, col3);
    if ncTok == 0,
        if col3>1,
            cTokens = {oldRem(1:col3-1)};
        else
            if ~isempty(oldRem),
                cTokens = oldRem(1:col3-1);
                if isempty(cTokens), cTokens = {''}; end
            else
                cTokens = {''};
            end
        end
        ncTok   = ncTok+1;
    else
        if ~isempty(oldRem),
            ncTok = ncTok+1;
            if isempty(col3),
                cTokens{ncTok} = oldRem;
            else
                cTokens{ncTok} = oldRem(1:col3-1);
            end
        end
    end
%     fprintf('ncTok= %ld:', ncTok);
%     for k=1:length(cTokens(:)), fprintf('(%ld)%s|', k, cTokens{k}); end
%     fprintf('\n');
    if isempty(str),  break;  end
    nTok            = nTok + 1;
    tokens{nTok}    =   str;
end
function [result] = untokenize(ctokens, tokens)
% function [result] = untokenize(ctokens, tokens)
% reconstruct result of tokenize; useful for after changing tokens or
% ctokens
result  = [];
nTok    = length(tokens);
nC_Tok  = length(ctokens);
if nC_Tok-nTok > 1 || nC_Tok<nTok,
    fprintf(1, 'WARNING(untokenize):  bad correspondence of ctokens and tokens');
end

% Reconstruct
for i=1:nC_Tok,
    result = sprintf('%s%s', result, ctokens{i});
    if nTok>=i, result = sprintf('%s%s', result, tokens{i});end
end

function Q = wf2q(Wf, SG)
% Q = wf2q(Wf, SG)
% Flow conversion

% 29-Oct-2012   DA Gutz     Created


Q   = Wf / (SG * 0.0360943 * 3600);
% write_opLine_lti_F414_FuelSystemCSV
% Write CSV results files full F414 fuel system
% 7-Jan-2013   DA Gutz     Created



%%Write
if ~exist('./figures'), mkdir('figures'), end
if ~exist('./figures/suppliers'), mkdir('figures/suppliers'), end
filenameHON = sprintf('./figures/suppliers/%s_HON.csv', testCase);
filenameSUN = sprintf('./figures/suppliers/%s_SUN.csv', testCase);
filenameGE  = sprintf('./figures/suppliers/%s_GE.csv', testCase);
filenameALL = sprintf('./figures/%s_ALL.csv', testCase);
defineXref
headerFile

filename = filenameHON; xref = xrefHON;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVHON, M.messageCSVHON] = fopen(filename, 'w+');
    if -1==M.fidCSVHON, error(M.messageCSVHON), end
    fprintf(M.fidCSVHON, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVHON, '%s,', xref{i, 2});
    end
    fprintf(M.fidCSVHON, '\n');
end
fprintf(M.fidCSVHON, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVHON, '%13.6g,', eval(xref{i,1}));
end
fprintf(M.fidCSVHON, '\n');


filename = filenameSUN; xref = xrefSUN;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVSUN, M.messageCSVSUN] = fopen(filename, 'w+');
    if -1==M.fidCSVSUN, error(M.messageCSVSUN), end
    fprintf(M.fidCSVSUN, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVSUN, '%s,', xref{i, 2});
    end
    fprintf(M.fidCSVSUN, '\n');
end
fprintf(M.fidCSVSUN, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVSUN, '%13.6g,', eval(xref{i,1}));
end
fprintf(M.fidCSVSUN, '\n');

filename = filenameGE; xref = xrefGE;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVGE, M.messageCSVGE] = fopen(filename, 'w+');
    if -1==M.fidCSVGE, error(M.messageCSVGE), end
    fprintf(M.fidCSVGE, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVGE, '%s,', xref{i, 2});
    end
    fprintf(M.fidCSVGE, '\n');
end
fprintf(M.fidCSVGE, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVGE, '%13.6g,', eval(xref{i,1}));
end
fprintf(M.fidCSVGE, '\n');

filename = filenameALL; xref = xrefALL;
[n, ~] = size(xref);
if ~held,
    [M.fidCSVALL, M.messageCSVALL] = fopen(filename, 'w+');
    if -1==M.fidCSVALL, error(M.messageCSVALL), end
    fprintf(M.fidCSVALL, 'testCase,');
    for i =1:n,
        fprintf(M.fidCSVALL, '%s,', xref{i, 2});
    end
%     fprintf(M.fidCSVALL, 'fgOLTV, fpOLTV, GmOLTV, PmOLTV, fgOLVEN, fpOLVEN, GmOLVEN, PmOLVEN, fnCLMFP, zetaCLMFP,');
    fprintf(M.fidCSVALL, 'fgOLTV, fpOLTV, GmOLTV, PmOLTV, fnCLMFP, zetaCLMFP,');
    fprintf(M.fidCSVALL, '\n');
end
fprintf(M.fidCSVALL, '%2s,', source);
for i =1:n,
    fprintf(M.fidCSVALL, '%13.6g,', eval(xref{i,1}));
end
if L.swComparePumps
%     fprintf(M.fidCSVALL, '%13.6g,', LRES(nCases).pump.fg, LRES(nCases).pump.fp, LRES(nCases).pump.Gm, LRES(nCases).pump.Pm);
else
%     fprintf(M.fidCSVALL, '%13.6g,', LRES(nCases).oltv.fg, LRES(nCases).oltv.fp, LRES(nCases).oltv.Gm, LRES(nCases).oltv.Pm, LRES(nCases).olven.fg, LRES(nCases).olven.fp, LRES(nCases).olven.Gm, LRES(nCases).olven.Pm, LRES(nCases).clmfp.fn, LRES(nCases).clmfp.zeta);
    fprintf(M.fidCSVALL, '%13.6g,', LRES(nCases).oltv.fg, LRES(nCases).oltv.fp, LRES(nCases).oltv.Gm, LRES(nCases).oltv.Pm, LRES(nCases).clmfp.fn, LRES(nCases).clmfp.zeta);
end
fprintf(M.fidCSVALL, '\n');

function WriteAllDataEnd(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllDataEnd(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically
% on all levels.
% Recursive function.
% Example of top call:
%   fid = WriteAllDataEnd(S,'myFileName','S'); fclose(fid);
%
if nargin<4
    fileId = fopen([fileRoot '.csv'], 'w');
end
if ~isstruct(StructToWrite)
    fprintf(fileId, '%s,%f,\n', parent, StructToWrite.Data(end));
else
    Fields = fieldnames(StructToWrite);
    for iField = 1:length(Fields)
        WriteAllDataEnd(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
    end
end

return
function fileIdRet = WriteAllFields(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllFields(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically
% on all levels.
% Recursive function.
% Example of top call:
%   fid= WriteAllFields(S,'myFileName','S'); fclose(fid);
%
% 24-Feb-2017       DA Gutz     Created
% Revisions

%

if nargin<4
    fileId = fopen([fileRoot '.csv'], 'w');
end
fileIdRet = fileId;
if ~isstruct(StructToWrite)
    [n,~] = size(StructToWrite);
    for i = 1:n  
        if n>1, % multi-dimensioned elements
            fprintf(fileId, '%s(%ld,:),', parent, i);
        else
            fprintf(fileId, '%s,', parent);
        end
        try
        fprintf(fileId, '%f,', StructToWrite(i,:));
        catch ERR
            keyboard
        end
        fprintf(fileId, '\n');
    end
else
    [~,n] = size(StructToWrite);
    for i = 1:n
        if n>1
            Fields = fieldnames(StructToWrite(i));
            for iField = 1:length(Fields)
                WriteAllFields(StructToWrite(i).(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        else
            Fields = fieldnames(StructToWrite);
            for iField = 1:length(Fields)
                WriteAllFields(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        end
    end
end

return
function WriteAllFieldsArray(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllFieldsArray(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically,
% multi-dimensional array
% on all levels.
% Recursive function.
% Example of top call:
%   fid= WriteAllFields(S,'myFileName','S'); fclose(fid);
%
% 24-Feb-2017       DA Gutz     Created
% Revisions

%

if nargin<4
    fileId = fopen([fileRoot '.csv'], 'w');
end
if nargin<3
    parent = 'emptyParent';
end

try
    WriteAllTitlesArray(StructToWrite, fileRoot, parent, fileId);
catch ERR
    fprintf('IS THE EXCEL FILE %s.csv STILL OPEN?   CLOSE IT\n', fileRoot);
    rethrow(ERR)
end
fprintf(fileId, '\n');
[~,m]=size(StructToWrite);
for i = 1:m
    WriteAllValuesArray(StructToWrite(i), fileRoot, parent, fileId);
    fprintf(fileId, '\n');
end
fclose(fileId);
return
function WriteAllTitlesArray(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllFieldsArray(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically,
% multi-dimensional array
% on all levels.
% Recursive function.
% Example of top call:
%   fid= WriteAllFields(S,'myFileName','S'); fclose(fid);
%
% 24-Feb-2017       DA Gutz     Created
% Revisions



if ~isstruct(StructToWrite)
    [n,m] = size(StructToWrite);
    for i = 1:n
        if n>1, % multi-dimensioned elements
            for j = 1:m
                if m>1,
                    fprintf(fileId, '%s(%ld | %ld),', strrep(parent, 'emptyParent.', ''), i, j);
                else
                    fprintf(fileId, '%s(%ld),', strrep(parent, 'emptyParent.', ''), i);
                end
            end
        else
            fprintf(fileId, '%s,', strrep(parent, 'emptyParent.', ''));
        end
    end
else
    [~,n] = size(StructToWrite);
    for i = 1:1  % Title row just once
        if n>1
            Fields = fieldnames(StructToWrite(i));
            for iField = 1:length(Fields)
                WriteAllTitlesArray(StructToWrite(i).(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        else
            Fields = fieldnames(StructToWrite);
            for iField = 1:length(Fields)
                WriteAllTitlesArray(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        end
    end
end

return
function fileIdRet = WriteAllValuesArray(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllValuesArray(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically
% on all levels.
% Recursive function.
% Example of top call:
%   fid= WriteAllFieldsArray(S,'myFileName','S'); fclose(fid);
%
% 24-Feb-2017       DA Gutz     Created
% Revisions

%

if nargin<4
    fileId = fopen([fileRoot '.csv'], 'w');
end
fileIdRet = fileId;
if ~isstruct(StructToWrite)
    [n,m] = size(StructToWrite);
    for i = 1:n
        if n>1, % multi-dimensioned elements
            for j = 1:m
                if m>1,
                    if ischar(StructToWrite(i,j))
                        fprintf(fileId, '%s,', StructToWrite(i,j));
                    else
                        fprintf(fileId, '%f,', StructToWrite(i,j));
                    end
                else
                    if ischar(StructToWrite(i))
                        fprintf(fileId, '%s,', StructToWrite(i));
                    else
                        fprintf(fileId, '%f,', StructToWrite(i));
                    end
                end
            end
        else
            if ischar(StructToWrite)
                fprintf(fileId, '%s,', StructToWrite);
            else
                if iscell(StructToWrite)
                    catStr = StructToWrite{:,1};
                    for j=2:length(StructToWrite)
                        smallS = StructToWrite{:,j};
                        if iscell(smallS)
                            [~, ms] = size(smallS);
                            for k=1:ms
                                catStr = [catStr '_' smallS{:,k}]; %#ok<AGROW>
                            end
                        else
                            catStr = [catStr '_' smallS]; %#ok<AGROW>
                        end
                    end
                    cleanStr = strrep(catStr, ',', ';');
                    fprintf(fileId, '%s,', cleanStr);
                else
                    fprintf(fileId, '%f,', StructToWrite);
                end
            end
        end
    end
else
    [~,n] = size(StructToWrite);
    for i = 1:n
        if n>1
            Fields = fieldnames(StructToWrite(i));
            for iField = 1:length(Fields)
                WriteAllValuesArray(StructToWrite(i).(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        else
            Fields = fieldnames(StructToWrite);
            for iField = 1:length(Fields)
                WriteAllValuesArray(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        end
    end
end

return
