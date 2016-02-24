Screen('FillRect',EXPWIN,GREY);
DrawFormattedText(EXPWIN,'Click mouse to begin','Center',...
    Calib.screen.height/3, [255 255 255]);
Screen(EXPWIN,'Flip');

clickToStart=1;
while (clickToStart) % wait for press
    [x,y,buttons] = GetMouse(Calib.screenNumber);
    if( any(buttons) )
        clickToStart=0;
    end
end
