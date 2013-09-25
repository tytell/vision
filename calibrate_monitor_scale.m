function monitorscale = calibrate_monitor_scale

fig = openfig(mfilename, 'new');
data = guihandles(fig);

set(data.axes,'Units','pixels');

pos = get(data.axes,'Position');
plot(data.axes, [1 pos(3)], [1 pos(4)],'o');
axis(data.axes,'tight');
set(data.axes,'Box','on');

data.isOK = false;

setUICallbacks(data);
guidata(fig,data);

monitorscale = NaN;

uiwait(fig);
if (ishandle(fig))
    data = guidata(fig);
    
    if (data.isOK)
        xdistcm = str2double(get(data.widthedit,'String'));
        ydistcm = str2double(get(data.heightedit,'String'));
        
        pos = get(data.axes,'Position');
        xdistpix = pos(3);
        ydistpix = pos(4);
        
        monitorscale = [xdistpix/xdistcm ydistpix/ydistcm];
        monitorscale = mean(monitorscale);
    end
    
    delete(fig);
end
    

function setUICallbacks(data)

set(data.OKbutton,'Callback',@on_click_OK);
set(data.cancelbutton,'Callback',@on_click_Cancel);

function on_click_OK(obj,event)

data = guidata(obj);
data.isOK = true;
guidata(obj,data);

uiresume(data.figure);


function on_click_Cancel(obj,event)

data = guidata(obj);
data.isOK = false;
guidata(obj,data);

uiresume(data.figure);


