Constants.BG_MASK=75;
Constants.STIM_MASK=125;
Constants.MaskTimeOut=0.5;
Screen('FillRect', EXPWIN, GREY-Constants.BG_MASK);

if(Constants.LRvisible == 2) %2=right only visible
    Screen('FillRect', EXPWIN,  choiceColors(:,1)-Constants.STIM_MASK, RightChoiceSquare);
elseif(Constants.LRvisible == 1)
    Screen('FillRect', EXPWIN,  choiceColors(:,2)-Constants.STIM_MASK, LeftChoiceSquare);
else
    Screen('FillRect', EXPWIN, choiceColors-Constants.STIM_MASK, ...
        [LeftChoiceSquare; RightChoiceSquare]');
end
Screen(EXPWIN,'Flip');
WaitSecs(Constants.MaskTimeOut);

