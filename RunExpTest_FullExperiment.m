global EXPWIN GREY Calib

InitExp;
ISI=Constants.ISI_MIN;

[pahandle, buffer]=LoadSoundSchedule(wavfilenames,Constants.audiodir);
[AudioStimList,CorrectLocation]=generateTrials(Constants);

%else keep all the wavs but set a range
if(Constants.AudioStimulusHeldConstant==Constants.LOW)
    %rng=10:-1:2;
    rng=length(wavfilenames):-1:2;
    constantStim=1;
elseif(Constants.AudioStimulusHeldConstant==Constants.HIGH)
    %rng=1:9;
    rng=1:(length(wavfilenames)-1);
    constantStim=length(wavfilenames);
end

while(training)

    trial=trial+1;
    PsychPortAudio('UseSchedule', pahandle, 1);
    %we need to determine the appropriate sound to play for this trial
    if(Constants.AudioStimulusHeldConstant==Constants.LOW)
        if(AudioStimList(trial)==Constants.LOW)
            PsychPortAudio('AddToSchedule', pahandle, buffer(constantStim), 1);
        elseif(AudioStimList(trial)==Constants.HIGH)
            PsychPortAudio('AddToSchedule', pahandle, buffer(rng(StepStimulus(trial))), 1);
        end
    elseif(Constants.AudioStimulusHeldConstant==Constants.HIGH)
        if(AudioStimList(trial)==Constants.LOW)
            PsychPortAudio('AddToSchedule', pahandle, buffer(rng(StepStimulus(trial))), 1);
        elseif(AudioStimList(trial)==Constants.HIGH)
            PsychPortAudio('AddToSchedule', pahandle, buffer(constantStim), 1);
        end
    end
    %end
    
    %display fix %& wait for fixation
    InitAV;
    
    disp(['Start' num2str(trial) ', step size: ' num2str( StepStimulus(trial)) ])
    
    VisStimInit=0;

    if(trial<=Constants.AnimatedTrials)
        animate_fix=Constants.animate_fix;
    else
        animate_fix=0;
    end
    
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
                                    %PlayMovie([Constants.imagedir VidDirList(fn).name],LeftChoiceSquare)
                                    moviename=[Constants.imagedir VidDirList(fn).name]; rect=LeftChoiceSquare;
                                    PlayMovie
                                    
                                    finished=1;
                                    trialScore(trial)=1;
                                else
                                    Screen('DrawTexture', EXPWIN, blockTex_Incorrect, ...
                                        bRect_Incorrect, LeftChoiceSquare);
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
                                    %PlayMovie([Constants.imagedir VidDirList(fn).name],RightChoiceSquare)
                                    moviename=[Constants.imagedir VidDirList(fn).name]; rect=RightChoiceSquare;
                                    PlayMovie
                                    
                                    finished=1;
                                    trialScore(trial)=1;
                                else
                                    Screen('DrawTexture', EXPWIN, blockTex_Incorrect, ...
                                        bRect_Incorrect, RightChoiceSquare);
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
        if( find(keyCode)== 80 ) % press 'P' button
            disp('Starting attention movie......')
            PlayAttentionMovie
        end
        
        if(CheckEsc)
            training=0;
            finished=1;
            ESC_PRESSED=1;
        end
        
        Recalibrate;
        PauseCheck;
        
    end
    
    %wait ISI
    Screen('FillRect',EXPWIN,GREY);
    Screen(EXPWIN,'Flip');
    WaitSecs(ISI);
    
    if(Constants.trackEyes)
        lxy=[left_xy_PRE; left_xy ];
        rxy=[right_xy_PRE; right_xy];
        lp=[left_pupil_PRE; left_pupil];
        rp=[right_pupil_PRE; right_pupil];
        lv=[left_validity_PRE; left_validity];
        rv=[right_validity_PRE; right_validity];
        eTime=[EyeTime_PRE'; EyeTime'];
        eAOI=[EyeInsideLR_PRE; EyeInsideLR];
        
        EyeData(trial).leye_xypv=[lxy lp lv];
        EyeData(trial).reye_xypv=[rxy rp rv];
        EyeData(trial).AOI=eAOI;
        EyeData(trial).time=eTime;
        
        TrialData(trial).AudioPlayTime=AudioPlayTime;
        TrialData(trial).VisStimAppearTime=VisStimAppearTime;
    end
    
    %evaluate score so far
    %     if(trial>=Constants.numTrialEval)
    %         %if we have enough trials
    %
    %         %running score average
    %         %nCorrect=sum(trialScore(end-(Constants.numTrialEval-1):end));
    %         %if(nCorrect>=Constants.numTrialCorrect)
    %         %    training=0;
    %         %end
    %     end
    
    %reset & add more trials
    if(trial==length(AudioStimList))
        [tL,cL]=generateTrials(Constants);
        AudioStimList=[AudioStimList; tL];
        CorrectLocation=[CorrectLocation cL];
    end
    
    %examine ongoing performance if 3 in a row correct move 1
    %if 1 fail move down
    TimeSinceLastStep=trial-TrialNumAtStep;
    
    %by default assume step stays same then evaluate for change
    StepStimulus(trial+1)=StepStimulus(trial);
    
    if(trial>2)
        if(trialScore(end)==0) %step down
            if(StepStimulus(trial)>1)
                disp('down')
                StepStimulus(trial+1)=StepStimulus(trial)-1;
            end
        elseif(sum(trialScore(end-2:end))==3 & TimeSinceLastStep>2);
            if(StepStimulus(trial)<length(rng))
                disp('up')
                StepStimulus(trial+1)=StepStimulus(trial)+1;
                TrialNumAtStep=trial;
            end
        end
        
    end
    
    %here we should insert rules for ending test
    EvalPerformance;
    %rules to make training=0,
    %1) if on lowest step, stop after 10 trials
    %2)if on highest step, stop after 10 trials
    %3) if 15 reversals
    
    save(Constants.savefile,'Calib', 'trialScore','AudioStimList','CorrectLocation',...
        'Constants','EyeData','StepStimulus', 'PerfCode', ...
        'ReversalCount','TrialData')
    
    
end %training & trial +1



% Stop playback:
PsychPortAudio('Stop', pahandle);

% Delete all dynamic audio buffers:
PsychPortAudio('DeleteBuffer');

% Close audio device, shutdown driver:
PsychPortAudio('Close');

if(~ESC_PRESSED)
    if(Constants.trackEyes)
        EyeErrorTestEnd=TestEyeTrackerError(Calib,mOrder,Constants);
    end
    
    Screen('FillRect',EXPWIN,GREY);
    Screen(EXPWIN,'Flip');
    WaitSecs(2);
    
    save(Constants.savefile,'Calib', 'trialScore','AudioStimList','CorrectLocation',...
        'EyeErrorTestEnd','Constants','EyeData','StepStimulus', 'PerfCode', ...
        'ReversalCount','TrialData')
    
end

%clean up & save data
ShowCursor

Screen('CloseAll')


