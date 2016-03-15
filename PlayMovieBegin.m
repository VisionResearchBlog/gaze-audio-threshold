vidObj=VideoReader(moviename);

ctr=0;
%randomize looking at 50/50
if(rand<=0.5)
    flipit=1;
else
    flipit=0;
end

while(vidObj.hasFrame)
    drawQuestionMark
    
    tmp=vidObj.readFrame;
    if(flipit)
        tmp=fliplr(tmp);
    end
    
    tex=Screen('MakeTexture', EXPWIN, tmp);
    Screen('DrawTexture', EXPWIN, tex,[],rect);
    
    %drawGazeCursor
    
    Screen('Flip', EXPWIN);
    Screen('Close', tex);
    
    WaitSecs(1/25); %
    
end
