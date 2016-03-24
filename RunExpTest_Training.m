global EXPWIN GREY Calib

InitExp;

ISI=Constants.ISI_INIT;

clear tmp
%in training limit the stimuli
if(Constants.TrainHiLo==1) %high training
    wavfilenames=wavfilenames(end);
elseif(Constants.TrainHiLo==2) %low training
    wavfilenames=wavfilenames(1);
elseif(Constants.TrainHiLo==3) %low &hi training
    tmp{1}=wavfilenames{1}; %low
    tmp{2}=wavfilenames{end}; %hi
    wavfilenames=tmp;
end

[pahandle, buffer]=LoadSoundSchedule(wavfilenames,Constants.audiodir);

if(Constants.TrainHiLo==3) %low &hi training
    [AudioStimList,CorrectLocation]=generateTrials(Constants);
elseif(Constants.LRvisible==Constants.LEFT+1)%LEFT
    CorrectLocation=Constants.LEFT;
elseif(Constants.LRvisible==Constants.RIGHT+1)%RIGHT
    CorrectLocation=Constants.RIGHT;
end


if(Constants.TrainHiLo~=3) %low &hi training
    if(Constants.StimulusAssignment==Constants.HiRight_LoLeft)
        if(Constants.TrainHiLo==1) %(hi1 lo2)
            CorrectLocation=Constants.RIGHT;
        else
            CorrectLocation=Constants.LEFT;
        end
        
    elseif(Constants.StimulusAssignment==Constants.HiLeft_LoRight)
        if(Constants.TrainHiLo==1) %(hi1 lo2)
            CorrectLocation=Constants.LEFT;
        else
            CorrectLocation=Constants.RIGHT;
        end
    end
end


while(training)
    
    trial=trial+1;
    
    if(Constants.TrainingTrials)
        animate_fix=1; % if we want each trial
    else
        animate_fix=0;
    end
    
    s = PsychPortAudio('GetStatus', pahandle);
    
    while (s.Active) % wait for press
        s = PsychPortAudio('GetStatus', pahandle);
        WaitSecs(0.01)
    end
    
    PsychPortAudio('UseSchedule', pahandle, 1);
    %we need to determine the appropriate sound to play for this trial
    if(Constants.TrainHiLo==3)
        PsychPortAudio('AddToSchedule', pahandle, buffer(AudioStimList(trial)+1), 1);
    else
        PsychPortAudio('AddToSchedule', pahandle, buffer(randi(length(wavfilenames))), 1);
    end
    
    %display fix point & start sound
    InitAV;
    VisStimInit=0;
    
    
    
    drawQuestionMark;
    
    if(Constants.TrainingTrials)
        moviename=[Constants.imagedir 'listen_' Constants.fixpoint_img '.mp4'];
        rect=FixationSquare;
        PlayMovieBegin;
    end
    
    while(~finished)
        
        drawQuestionMark;
        
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
            
            if(animate_fix)
                %playFixAnimation %character slides
                playFlashAnimation %character slides
                
                %make the target flash
                animate_fix=0;
            end
            
            if(length(EyeInsideLR)>Constants.FixThresh)
                %LOOKING AT LEFT SIDE AOI
                if(EyeInsideLR(end,1)==1 & EyeInsideLR(end,2)==0)
                    %don´t chnage if we are in a nonvisble trial
                    if(Constants.LRvisible ~= 2); %2=right only visible
                        if(sum(EyeInsideLR(end-Constants.FixThresh:end,1))>=Constants.FixThresh)
                            %evaluate if we are correct
                            if(CorrectLocation(trial)==Constants.LEFT)
                                moviename=[Constants.imagedir VidDirList(fn).name];
                                rect=LeftChoiceSquare;
                                PlayMovie
                                finished=1;
                                trialScore(trial)=1;
                            elseif(Constants.LRvisible == 0)
                                Screen('DrawTexture', EXPWIN, ...
                                    blockTex_Incorrect,...
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
                                moviename=[Constants.imagedir VidDirList(fn).name]; rect=RightChoiceSquare;
                                PlayMovie
                                finished=1;
                                trialScore(trial)=1;
                            elseif(Constants.LRvisible == 0)
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
        
        if( (finished == 0) & time_now>Constants.trialTime)
            finished=1;
            DrawTimeOutMask;
            
            Screen(EXPWIN,'Flip');
            WaitSecs(Constants.IncorrectTimeOut);
            
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
        PauseCheck;
        
        
    end
    
    
    %wait ISI
    Screen('FillRect',EXPWIN,GREY);
    Screen(EXPWIN,'Flip');
    
    %based on performance adjust ISI
    if(trialScore(trial)==1) %if correct decrease
        if(ISI>Constants.ISI_MIN)
            ISI=ISI-Constants.ISI_RATE;
        end
    elseif(trialScore(trial)==0) %if incorrect increase
        if(ISI<Constants.ISI_MAX)
            ISI=ISI+Constants.ISI_RATE;
        end
    end
    
    ISI
    WaitSecs(ISI);
    
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
    
    
    %reset & add more trials
    if(mod(trial,Constants.numTrialEval)==0)% we are at the end of eval period
        nCorrect=sum(trialScore(end-(Constants.numTrialEval-1):end));
        if(nCorrect>=Constants.numTrialCorrect)
            training=0;
        elseif(Constants.TrainHiLo==3)
            [tL,cL]=generateTrials(Constants);
            AudioStimList=[AudioStimList; tL];
            CorrectLocation=[CorrectLocation cL];
        end
    end
    
    if(Constants.TrainHiLo~=3) %for static trials where only one side is used
        CorrectLocation(trial+1)=CorrectLocation(1);
    end
    
    if(Constants.TrainHiLo==3)
        save(Constants.savefile,'Calib', 'trialScore','AudioStimList','CorrectLocation',...
            'Constants','EyeData', 'TrialData')
    else
        save(Constants.savefile,'Calib', 'trialScore','CorrectLocation',...
            'EyeErrorTestStart','Constants','EyeData','TrialData')
    end
    
    
end %training & trial +1


Screen('FillRect',EXPWIN,GREY);

Screen(EXPWIN,'Flip');
WaitSecs(2);

% Stop playback:
PsychPortAudio('Stop', pahandle);

% Delete all dynamic audio buffers:
PsychPortAudio('DeleteBuffer');

% Close audio device, shutdown driver:
PsychPortAudio('Close');

clear trialScore AudioStimList CorrectLocation...
    EyeData StepStimulus


%keyboard