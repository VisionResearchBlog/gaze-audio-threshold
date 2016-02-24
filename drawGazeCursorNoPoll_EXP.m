%expect eye data to be present
c=5;
if(length(left_xy)>c)
    x=median(median([right_xy(end-c:end,1) left_xy(end-c:end,1)]))*Calib.screen.width;
    y=median(median([right_xy(end-c:end,2) left_xy(end-c:end,2)]))*Calib.screen.height;
    gazeCursor = [x-Constants.gXY/2, y-Constants.gXY/2, ...
        x+Constants.gXY/2, y+Constants.gXY/2];
    Screen('FillRect', EXPWIN, Constants.gColor, gazeCursor );
end