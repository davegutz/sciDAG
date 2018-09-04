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



