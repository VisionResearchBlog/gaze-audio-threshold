%MainTrailLoop
%display fix %& wait for fixation
InitAV;


VisStimInit=0;

animate_fix=Constants.animate_fix;

while(~finished)
    
    %Screen('FillRect', EXPWIN, GREY);
    %Screen('FillRect', EXPWIN, choiceColors, ...
    %    [LeftChoiceSquare; RightChoiceSquare]');
    drawQuestionMark;
    
    if(Constants.trackEyes)
        
        [left_xyTMP, right_xyTMP, left_pupilTMP, right_pupilTMP, ...
            left_validityTMP, right_validityTMP, emptyset]=...
            GetEyeData(ScreenTime(end-1), ScreenTime(end));
        
        if(~emptyset)
            left_xy(end+1,:)=left_xyTMP(end,:);
            right_xy(end+1,:)=right_xyTMP(end,:);
            left_pupil(end+1,:)=left_pupilTMP(end,:);
            right_pupil(end+1,:)=right_pupilTMP(end,:);
            left_validity(end+1,:)=left_validityTMP(end,:);
            right_validity(end+1,:)=right_validityTMP(end,:);
            EyeTime(end+1)=ScreenTime(end);
            
            EyeInsideLR(end+1,1)=EyeInAOI_Median(right_xy(end,:),...
                left_xy(end,:),Calib,LeftChoiceSquare,Constants.AOI_border);
            EyeInsideLR(end,2)=EyeInAOI_Median(right_xy(end,:),...
                left_xy(end,:),Calib,RightChoiceSquare,Constants.AOI_border);
            EyeInsideLR(end,3)=0;
            
            
            AllEyeData= [AllEyeData; zeros(size(left_xyTMP,1),1)+EyeTime(end) ...
                left_xyTMP right_xyTMP left_pupilTMP right_pupilTMP ...
                left_validityTMP right_validityTMP];
            
            if(length(EyeInsideLR)>Constants.FixThresh)
                %LOOKING AT LEFT SIDE AOI
                if(EyeInsideLR(end,1)==1 & EyeInsideLR(end,2)==0)
                    %don´t chnage if we are in a nonvisble trial
                    if(Constants.LRvisible ~= 2); %2=right only visible
                        if(sum(EyeInsideLR(end-Constants.FixThresh:end,1))>=Constants.FixThresh)
                            %evaluate if we are correct
                            if(CorrectLocation(trial)==Constants.LEFT)
                                PlayMovie([Constants.imagedir VidDirList(fn).name],LeftChoiceSquare)
                                finished=1;
                                trialScore(trial)=1;
                            else
                                Screen('DrawTexture', EXPWIN, blockTex_Incorrect, bRect_Incorrect, LeftChoiceSquare);
                                %display incorrect X
                                finished=1;
                                Screen(EXPWIN,'Flip');
                                WaitSecs(Constants.IncorrectTimeOut);
                            end
                        end
                    end
                    %LOOKING AT RIGHT SIDE AOI
                elseif(EyeInsideLR(end,1)==0 & EyeInsideLR(end,2)==1)
                    if(Constants.LRvisible ~= 1); %1=left only visible
                        if(sum(EyeInsideLR(end-Constants.FixThresh:end,2))>=Constants.FixThresh)
                            %evaluate if we are correct
                            if(CorrectLocation(trial)==Constants.RIGHT)
                                PlayMovie([Constants.imagedir VidDirList(fn).name],RightChoiceSquare)
                                finished=1;
                                trialScore(trial)=1;
                            else
                                Screen('DrawTexture', EXPWIN, blockTex_Incorrect, bRect_Incorrect, RightChoiceSquare);
                                %display incorrect X
                                finished=1;
                                Screen(EXPWIN,'Flip');
                                WaitSecs(Constants.IncorrectTimeOut);
                            end
                        end
                    end
                end
            end
            
            if(Constants.showGaze & ~finished)
                drawGazeCursorNoPoll_EXP
            end
            
            ScreenTime(end+1)=Screen(EXPWIN,'Flip');
            time_now=GetSecs-t1;
        else
            time_now=GetSecs-t1;
            ScreenTime(end+1)=Screen(EXPWIN,'Flip');
        end
    else
        time_now=GetSecs-t1;
        ScreenTime(end+1)=Screen(EXPWIN,'Flip');
    end
    
    if( (finished == 0) & time_now>Constants.trialTime)
        finished=1;
        DrawTimeOutMask;
    end
    
    if(~VisStimInit)
        VisStimInit=1;
        VisStimAppearTime=ScreenTime(end);
    end
    
    FlushEvents;
    [~,~,keyCode,~] = KbCheck;
    if( find(keyCode)== 80 ) %P
        disp('Starting attention movie......')
        PlayAttentionMovie
    end
    
    if(CheckEsc)
        training=0;
        finished=1;
        ESC_PRESSED=1;
    end
    
    Recalibrate;
    
    
end
