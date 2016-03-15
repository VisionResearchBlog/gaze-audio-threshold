%move the character so it looks like they slide across screen

Screen('FillRect', EXPWIN, GREY);
anim_t_length=30;

%
% if(Constants.TrainingTrials)
%     if(CorrectLocation(trial)==Constants.RIGHT)
%         creat path
%         xd=mean(FixationSquare([1 3]))-mean(RightChoiceSquare([1 3]));
%         yd=mean(FixationSquare([2 4]))-mean(RightChoiceSquare([2 4]));
%         ANIM_blockTex=blockTex_RIGHT;
%     elseif(CorrectLocation(trial)==Constants.LEFT)
%         elseif(Constants.LRvisible ~= 2); %2=right only visible
%         xd=mean(FixationSquare([1 3]))-mean(LeftChoiceSquare([1 3]));
%         yd=mean(FixationSquare([2 4]))-mean(LeftChoiceSquare([2 4]));
%         ANIM_blockTex=blockTex_LEFT;
%     end
% else
%     LOOKING AT LEFT SIDE AOI
%     if(EyeInsideLR(end,1)==1 & EyeInsideLR(end,2)==0)
%         xd=mean(FixationSquare([1 3]))-mean(LeftChoiceSquare([1 3]));
%         yd=mean(FixationSquare([2 4]))-mean(LeftChoiceSquare([2 4]));
%         ANIM_blockTex=blockTex_LEFT;
%         LOOKING AT RIGHT SIDE AOI
%     elseif(EyeInsideLR(end,1)==0 & EyeInsideLR(end,2)==1)
%         xd=mean(FixationSquare([1 3]))-mean(RightChoiceSquare([1 3]));
%         yd=mean(FixationSquare([2 4]))-mean(RightChoiceSquare([2 4]));
%         ANIM_blockTex=blockTex_RIGHT;
%     end
% end
% lets animate in 1 sec
% xd=xd/anim_t_length;
% yd=yd/anim_t_length;


for fr=1:anim_t_length
    
    
    Screen('FillRect',EXPWIN,GREY);
    %NewFixationSquare=[FixationSquare(1)-xd*fr FixationSquare(2)-yd*fr FixationSquare(3)-xd*fr FixationSquare(4)-yd*fr];
    %Screen('DrawTexture', EXPWIN, ANIM_blockTex, bRect, NewFixationSquare);
    
    if( ~mod(fr,10)==0 ) %flash off
        
        if(CorrectLocation(trial)==Constants.LEFT)
            Screen('FillRect', EXPWIN, choiceColors(:,2), RightChoiceSquare);
            DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
        elseif(CorrectLocation(trial)==Constants.RIGHT)
            Screen('FillRect', EXPWIN, choiceColors(:,1), LeftChoiceSquare);
            DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
        end
        
    else %flashing on
        
        Screen('FillRect', EXPWIN, choiceColors, ...
            [LeftChoiceSquare; RightChoiceSquare]');
        Screen('TextSize',EXPWIN, 60);
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],LeftChoiceSquare);
        DrawFormattedText(EXPWIN,'?','Center','Center',WHITE,[],[],[],[],[],RightChoiceSquare);
        
    end
    drawGazeCursor;
    
    Screen(EXPWIN,'Flip');
    WaitSecs(1/60);
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

