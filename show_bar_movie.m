function show_bar_movie(barsize,barspeed, varargin)

opt.bartype = 'black';      % or sine
opt.contrast = 1;
opt.monitorscale = 52;     % pixels per cm
opt.refreshrate = 20;       % fps

opt = parsevarargin(opt, varargin, 3);

fig = gcf;
clf;
set(fig,'DoubleBuffer','on');
ax = axes('Position',[0 0 1 1], 'Parent',fig);
set(ax,'Units','pixels');
pos = get(ax,'Position');

widthpix = pos(3);
widthcm = widthpix/opt.monitorscale;
barsizepix = barsize*opt.monitorscale;

x = (1:widthpix+round(barsizepix)) / barsizepix;

I = repmat(sin(2*pi*x),[2 1]);
him = imagesc([-barsize widthcm],[0 widthcm],I);
set(ax,'XLim',[0 widthcm],'YLim',[0 widthcm]);
axis(ax,'off');

switch opt.bartype
    case 'sine'
        cmap = repmat(linspace(0,1,256)',[1 3]);
    case 'black'
        cmap = [zeros(128,3); ones(128,3)];
end
colormap(cmap);

dist = barspeed / opt.refreshrate;

for i = 1:15
    moveimage(fig,[], him,dist,barsize);
end

set(gcf,'KeyPressFcn',@on_keypress);

T = timer('TimerFcn',{@moveimage,him,dist,barsize}, ...
    'ExecutionMode','fixedRate', 'Period',1/opt.refreshrate);

start(T);
uiwait(fig);
stop(T);
delete(T);

function on_keypress(obj, event)

c = get(gcf,'CurrentCharacter');
if (c == 'q')
    uiresume(obj);
end
    
function moveimage(obj, event, him,d,barsize)

xd = get(him,'XData');
w = xd(2) - xd(1);
xd(1) = mod(xd(1)+barsize+d,barsize) - barsize;
xd(2) = xd(1) + w;

set(him,'XData',xd);






