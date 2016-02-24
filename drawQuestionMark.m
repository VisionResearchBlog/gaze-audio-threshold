WHITE=[255 255 255];
anim_t_length=60;

if(animate_fix)
    
    Screen('FillRect', EXPWIN, GREY);
    
    %if(Constants.LRvisible ~= 1); %1=left
    if(CorrectLocation==Constants.RIGHT)
        %creat path
        xd=mean(FixationSquare([1 3]))-mean(RightChoiceSquare([1 3]));
        yd=mean(FixationSquare([2 4]))-mean(RightChoiceSquare([2 4]));
    elseif(CorrectLocation==Constants.LEFT)
        %elseif(Constants.LRvisible ~= 2); %2=right only visible
        xd=mean(FixationSquare([1 3]))-mean(LeftChoiceSquare([1 3]));
        yd=mean(FixationSquare([2 4]))-mean(LeftChoiceSquare([2 4]));
    end
    
    %lets animate in 1 sec
    xd=xd/anim_t_length;
    yd=yd/anim_t_length;
    
    for fr=1:anim_t_length
        
        NewFixationSquare=[FixationSquare(1)-xd*fr FixationSquare(2)-yd*fr FixationSquare(3)-xd*fr FixationSquare(4)-yd*fr];
        Screen('DrawTexture', EXPWIN, blockTex, bRect, NewFixationSquare);
        
        Screen('FillRect', EXPWIN, choiceColors, ...
            [LeftChoiceSquare; RightChoiceSquare]');
        
        Screen('TextSize',EXPWIN, 60);
        if(Constants.LRvisible == 2); %1=left only visible
            DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
        elseif(Constants.LRvisible == 1); %2=right only visible
            DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
        else
            DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
            DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
        end
        
        drawGazeCursor;
        
        Screen(EXPWIN,'Flip');
        WaitSecs(1/anim_t_length);
    end
    
    Screen('FillRect', EXPWIN, choiceColors, ...
        [LeftChoiceSquare; RightChoiceSquare]');
    
    Screen('TextSize',EXPWIN, 60);
    if(Constants.LRvisible == 2); %1=left only visible
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
    elseif(Constants.LRvisible == 1); %2=right only visible
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
    else
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
    end
    
    animate_fix=0;
else
    
    Screen('FillRect', EXPWIN, GREY);
    Screen('FillRect', EXPWIN, choiceColors, ...
        [LeftChoiceSquare; RightChoiceSquare]');
    
    Screen('TextSize',EXPWIN, 60);
    if(Constants.LRvisible == 2); %1=left only visible
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
    elseif(Constants.LRvisible == 1); %2=right only visible
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
    else
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
    end
    
    %    Screen(EXPWIN,'Flip');
end