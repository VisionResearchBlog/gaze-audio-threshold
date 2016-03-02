vidObj=VideoReader(moviename);

ctr=0;

while(vidObj.hasFrame)
    drawQuestionMark
    
    tex=Screen('MakeTexture', EXPWIN, vidObj.readFrame);
    Screen('DrawTexture', EXPWIN, tex,[],rect);
    
    %drawGazeCursor
    
    Screen('Flip', EXPWIN);
    Screen('Close', tex);
    
    WaitSecs(1/25); %
    
end
