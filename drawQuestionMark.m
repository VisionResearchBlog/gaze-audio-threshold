WHITE=[255 255 255];
anim_t_length=60;

if(animate_fix)
    playFixAnimation
else
    
    Screen('FillRect', EXPWIN, GREY);
    Screen('FillRect', EXPWIN, choiceColors, ...
        [LeftChoiceSquare; RightChoiceSquare]');
    if(~Constants.animate_fix)
        Screen('DrawTexture', EXPWIN, blockTex, bRect, FixationSquare);
    end
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