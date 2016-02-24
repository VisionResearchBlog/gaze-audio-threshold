
KeyStop=0;
while(attnObj.hasFrame && ~KeyStop)
    tex=Screen('MakeTexture', EXPWIN, attnObj.readFrame);
    Screen('DrawTexture', EXPWIN, tex,[],...
        [0 0 Calib.screen.width Calib.screen.height]);
    Screen('Flip', EXPWIN);
    Screen('Close', tex);
    WaitSecs(1/30); %movies are 30 hz
    
    FlushEvents;
    [~,~,keyCode,~] = KbCheck;
    if( find(keyCode)== 83 ) % press 'S'
        disp('Stopping attention movie......')
        KeyStop=1;
    end
end
