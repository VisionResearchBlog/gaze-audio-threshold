%function PlayMovie(moviename,rect)
%global EXPWIN

%moviename=[imagedir fn];
vidObj=VideoReader(moviename);

%old code for playing the trial sound twice
% if(Constants.LRvisible~=0 & trial <=3)
%     PsychPortAudio('UseSchedule', pahandle, 1);
%     %we need to determine the appropriate sound to play for this trial
%     if(Constants.TrainHiLo==3)
%         PsychPortAudio('AddToSchedule', pahandle, buffer(AudioStimList(trial)+1), 1);
%     else
%         PsychPortAudio('AddToSchedule', pahandle, buffer(randi(length(wavfilenames))), 1);
%     end
%
%     PsychPortAudio('Start', pahandle, [], 0, 1);
%     %    s=PsychPortAudio('GetStatus', pahandle);
% end

ctr=0;

while(vidObj.hasFrame)
    tex=Screen('MakeTexture', EXPWIN, vidObj.readFrame);
    Screen('DrawTexture', EXPWIN, tex,[],rect);
    Screen('Flip', EXPWIN);
    Screen('Close', tex);
    
    %add green border -- unused
    %     if(Constants.LRvisible~=0 & trial <=3)
    %         colr=[0 175 0];
    %         c1=-20; c2=20;
    %         if(Constants.LRvisible == 2); %1=left only visible
    %             Screen('FillRect',EXPWIN,colr,[RightChoiceSquare(1:2)+c1 RightChoiceSquare(3:4)+c2]);
    %         elseif(Constants.LRvisible == 1); %2=right only visible
    %             Screen('FillRect',EXPWIN,colr,[LeftChoiceSquare(1:2)+c1 LeftChoiceSquare(3:4)+c2]);
    %         else
    %             Screen('FillRect',EXPWIN,colr,[RightChoiceSquare(1:2)+c1 RightChoiceSquare(3:4)+c2]);
    %             Screen('FillRect',EXPWIN,colr,[LeftChoiceSquare(1:2)+c1 LefttChoiceSquare(3:4)+c2]);
    %         end
    %     end
    WaitSecs(1/25); %movies are 30 hz
end

if(~isempty( regexp(moviename,'11','ONCE') ))
    notdone=1;
    ctr=0; px_c=150;
    while(notdone)
        
        c=sin(ctr/16);
        Screen('DrawTexture', EXPWIN, blockTex_RWD1, bRect_RWD1, rect);
        Screen('DrawTexture', EXPWIN, blockTex_RWD2, [], ...
            [mean(rect([1 3]))-(px_c*(1-c)) mean(rect([2 4]))-(px_c*(1-c)) ...
            mean(rect([1 3]))+(px_c*(1-c)) mean(rect([2 4]))+(px_c*(1-c))] )
        Screen('Flip', EXPWIN);
        
        WaitSecs(1/25); %movies are 30 hz
        ctr=ctr+1;
        %yd=
        if(ctr>50); notdone=0; end
        
    end
end
%return