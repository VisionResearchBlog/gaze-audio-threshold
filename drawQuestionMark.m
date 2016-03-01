WHITE=[255 255 255];

Screen('FillRect', EXPWIN, GREY);
Screen('FillRect', EXPWIN, choiceColors, [LeftChoiceSquare; RightChoiceSquare]');


Screen('TextSize',EXPWIN, 60);
if(Constants.LRvisible == 2); %1=left only visible
    DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
elseif(Constants.LRvisible == 1); %2=right only visible
    DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
else
    DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
    DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
end

