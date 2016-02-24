clear all; clc;
global EXPWIN BLACK Calib


Priority(1);
AssertOpenGL;
%Screen('Preference', 'SkipSyncTests', 1);
GetSecs;

%In a 2 monitor setup Windows 7 uses Monitor 0 as both screens000%Monitor 1 & 2 are the individual screens. Which screen is assigned
%1 or 2 seems to be buggy as sometimes it is the main desktop & sometimes not
Calib = SetCalibParams(0); %Variable indicates monitor

Screen('BlendFunction', EXPWIN, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

debug=0;
trackEyes=0;
savefile='pilotdata.mat';

%--------------CONSTANTS-------------
BLACK=[0 0 0];
trialTime=10; %30;
rX=50; rY=50; %block sizes
mX=5; mY=5; %mouse cursor size
sY=20; sX=20; %sort area size
fpSz=10; %fix point size
Change_SOA=0.2; %when should change occur wrt the color word +/-
PU_SOA=0.4;
samplerate=1/60;
timeLock=5; %how long do we wait before can touch block
TimeToPlayPD=0.5; %if this value is too large (1s+) there won't be enough time to play after change
ChangeDuration=1;
numReps=2; %17; %numtrials = 6*numreps
numRepsConflict=0; %4; %numtrials = 6*numrepsConflict
tally=0;
control=1;
BLUELEFT=1;
TRAINING=0;

if(BLUELEFT) %make this an option
    wavfilenames={...
        
        'impulse';
        'impulse';
        'impulse';
        'impulse';}
else
    wavfilenames={...
        'impulse';
        'impulse';
        'impulse';
        'impulse';}
end

PU_begin=2; PU_end=2;
PD_begin=3; PD_end=4;


generateTrialTypes;
%----END --- Initialize general constants------------------------

%SORT AREA CONSTANTS
sortAreaColors=[10 10; 10 10; 10 10; 255 255];
centerBlockColor=[75; 75; 75; 255];
%note BLUE is always Cat. 1 else color & audio won't match
ChangedBlockColor=[40 0 150 255; 70 0 140 255;];
blockColorList = [ 100 100 100 100]';

randSort1x=(rand(numTrials,1)-0.5)*mean(Calib.screen.pixperdeg)*8;
randSort1y=(rand(numTrials,1)-0.5)*mean(Calib.screen.pixperdeg)*8;

r1=[Calib.screen.width/5, ...
    3*(Calib.screen.height/4), ...
    Calib.screen.width/5+sY, ...
    3*(Calib.screen.height/4)+sX];
rectSortArea(1:numTrials,[1 3],1)=round(repmat(r1([1 3]),numTrials,1)+...
    repmat(randSort1x,1,2));
rectSortArea(1:numTrials,[2 4],1)=round(repmat(r1([2 4]),numTrials,1)+...
    repmat(randSort1y,1,2));

%define two sort areas bottom left & right
randSort2x=(rand(numTrials,1)-0.5)*mean(Calib.screen.pixperdeg)*8;
randSort2y=(rand(numTrials,1)-0.5)*mean(Calib.screen.pixperdeg)*8;

r2=[4*(Calib.screen.width/5), ...
    3*(Calib.screen.height/4), ...
    4*(Calib.screen.width/5)+sY,...
    3*(Calib.screen.height/4)+sX];
rectSortArea(1:numTrials,[1 3],2)=round(repmat(r2([1 3]),numTrials,1)+...
    repmat(randSort2x,1,2));
rectSortArea(1:numTrials,[2 4],2)=round(repmat(r2([2 4]),numTrials,1)+...
    repmat(randSort2y,1,2));

%FIXATION POINT
fixPointRect=[(Calib.screen.width/2)-fpSz, ...
    (Calib.screen.height/2)-fpSz, (Calib.screen.width/2)+fpSz, ...
    (Calib.screen.height/2)+fpSz];

%sortable blocks

nBlocks=size(blockColorList,2);

rMouse= [0,0, 0+mX,0+mY];
blockX=Calib.screen.width/2;
blockY=Calib.screen.height/12;
centerBlock= [blockX-(rX*2)/2, Calib.screen.height/3-(rY*2)/2, ...
    blockX+(rX*2)/2, Calib.screen.height/3+(rY*2)/2]';

%TrafficLightRect=[centerBlock(3)-fpSz/2, ...
%    centerBlock(4)-fpSz/2, centerBlock(3)+fpSz/2, ...
%    centerBlock(4)+fpSz/2];

TrafficLightRect=[centerBlock(1)-Calib.screen.pixperdeg_xy(1)/8 ,  ...
    centerBlock(2)-Calib.screen.pixperdeg_xy(2)/8,...
    centerBlock(3)+Calib.screen.pixperdeg_xy(1)/8, ...
    centerBlock(4)+Calib.screen.pixperdeg_xy(2)/8];


audiodir=[pwd '\audio\'];
griddir=[pwd '\audio\'];

[pahandle, buffer]=LoadSoundSchedule(wavfilenames,audiodir);
%txt=ReadTextgrid(wavfilenames(2:end),griddir);
disp('Testing Sounds')
PsychPortAudio('UseSchedule', pahandle, 1);
PsychPortAudio('AddToSchedule', pahandle, buffer(1), 1);
PsychPortAudio('Start', pahandle, [], 0, 1);

if(trackEyes)
    Tobii_calibration_with_psychtoolbox;
    mOrder = randperm(Calib.points.n);
    tetio_startTracking;
    EyeErrorTestStart=TestEyeTrackerError(Calib,mOrder);
end

beforeLIST=[];
afterLIST=[];
sameList=[];
stepsz=(0.1)/trialTime;

myimgfile='1271715083.png';
[imdata,MAP,ALPHA]=imread(myimgfile);
blockTex(1)=Screen('MakeTexture', EXPWIN, imdata);
bRect=Screen('Rect', blockTex);

myimgfile='1283175242.png';
[imdata,MAP,ALPHA]=imread(myimgfile);
blockTex(2)=Screen('MakeTexture', EXPWIN, imdata);


for i=1:trialTime
    TimerBlock(:,i)=[Calib.screen.width*(.8+stepsz*(i-1))-fpSz/2 ...
        (Calib.screen.height*.05)-fpSz/2 ...
        Calib.screen.width*(.8+stepsz*(i-1))+fpSz/2 ...
        (Calib.screen.height*.05)+fpSz/2]';
end

for trial=1:numTrials
    
    disp(['Start' num2str(trial)])
    
    Screen('FillRect',EXPWIN,BLACK);
    DrawFormattedText(EXPWIN,'Click & Look in Center to Start','Center',...
        Calib.screen.height/3, [255 255 255]);
    Screen('FillRect', EXPWIN, [255 255 255], fixPointRect );
    Screen(EXPWIN,'Flip');
    
    clickToStart=1;
    while (clickToStart) % wait for press
        [x,y,buttons] = GetMouse(Calib.screenNumber);
        if( IsInRect(x,y, fixPointRect) & any(buttons) )
            clickToStart=0;
        end
    end
    
    %SETUP sortable blocks
    %these could be moved out as constants...
    SubjectData(trial).ColorPerm=randperm(size(blockColorList,2));
    blockColorTrial= blockColorList(:,SubjectData(trial).ColorPerm);
    
    rectBlock= [blockX-rX/2, blockY-rY/2, blockX+rX/2, blockY+rY/2]';
    
    %SETUP & RESET FLAGS for individual trials
    finished=0;
    BlockLock=0;
    PU_played=0;
    PD_played=0;
    changeEnd=0;
    changeEndTiming=0;
    changeStart=0;
    startChangeTime=0;
    changeTimeFlip=0;
    pu_rand=randi([PU_begin PU_end]);
    pd_rand=pd_randList(trial);
    sortedInto=0;
    EyeInsideScale=0;
    tlock=0;
    InsideScale=0;
    ReadyForPD=0;
    blockLocked=0;
    
    SubjectData(trial).PU_Instruction=wavfilenames{pu_rand};
%    SubjectData(trial).PU_InstructTiming=[ cell2mat(txt.t_start(:,pu_rand-1)) ...
%        cell2mat(txt.t_end(:,pu_rand-1))];
 %   SubjectData(trial).PU_InstructText=txt.words(:,pu_rand-1);
    SubjectData(trial).PU_id=pu_rand;
    
    SubjectData(trial).PD_Instruction=wavfilenames{pd_rand};
 %   SubjectData(trial).PD_InstructTiming=[ cell2mat(txt.t_start(:,pd_rand-1)) ...
 %       cell2mat(txt.t_end(:,pd_rand-1))];
 %   SubjectData(trial).PD_InstructText=txt.words(:,pd_rand-1);
    SubjectData(trial).PD_id=pd_rand;
    
    rectBlockTrial=[]; mouseTrial=[]; screentime=[];
    %flush buffer before starting new recordings
    
    if(trackEyes)
        tetio_readGazeData;
    end
    
    changeCatType=changeCatTypeList(trial);
    changeTimeType=changeTimeTypeList(trial); %1-before, 2-after
    
    if(changeCatType==0)
        disp('cat Blue')
    elseif(changeCatType==1)
        disp('cat Purple')
    end
    
    changeTimeType=3;
    
    if(changeTimeType==1)
        disp('change before color word')
    elseif(changeTimeType==2)
        disp('change after color word')
    elseif(changeTimeType==3)
        disp('change at same time')
    end
    
    if(conflictList(trial))
        disp('Conlict Trial')
    end
    
    
    t1=GetSecs;
    
    left_xy=[]; right_xy=[]; left_pupil=[];
    right_pupil=[]; left_validity=[]; right_validity=[];
    %HideCursor
    
    
    %try something special
    for xzx= 1:20
        WaitSecs(5);
        Screen('FillRect',EXPWIN,BLACK);
        Screen(EXPWIN,'Flip');
        PsychPortAudio('UseSchedule', pahandle, 1);
        PsychPortAudio('AddToSchedule', pahandle, buffer(pd_rand), 1);
        KbWait
        Screen('FillRect',EXPWIN,[255 255 255]);
        [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos]=Screen(EXPWIN,'Flip');
        startTime=PsychPortAudio('Start', pahandle);
        
    end
    
    keyboard
    
 
    while(~finished)
        
        %play pick up
%         if(GetSecs-t1>=PU_SOA & PU_played==0)
%             try
%                 PsychPortAudio('UseSchedule', pahandle, 1);
%             catch ME
%                 ME
%             end
%             
%             PsychPortAudio('AddToSchedule', pahandle, buffer(pu_rand), 1);
%             tmp=PsychPortAudio('Start', pahandle, [], 0, 1);
%             SubjectData(trial).PU_AudioStart=tmp-t1;
%             PU_played=1;
%         end
        PU_played=1;
         
        [x,y,buttons] = GetMouse(Calib.screenNumber);
        mouseTrial(end+1,:)=[x,y,buttons(1)];
        rMouse = [x-mX/2, y-mX/2, x+mX/2, y+mY/2];
        
        % if block is being sorted we want to remove
        for i=1:size(rectSortArea,3)
            if( IsInRect(x,y, rectSortArea(trial,:,i))  && BlockLock && ~any(buttons))
                sortedInto=i;
                finished=1;
            end
        end
        
        if(GetSecs-t1 > trialTime)
            finished=1;
        end
        
        if(~finished)
            %move rectangle if mouse clicked
            if(~ReadyForPD & ~blockLocked)
                for i=1:nBlocks
                    if( IsInRect(x,y, rectBlock)  && buttons(1) && ~BlockLock )
                        BlockLock=1; TouchedNum=i;
                        rectBlock= [x-rX/2, y-rX/2, x+rX/2, y+rY/2];
                        break; %to avoid multiple blocks sticking to each other
                        %(could evaluate distance & choose closest block?)
                    elseif(BlockLock && buttons(1))
                        rectBlock= [x-rX/2, y-rX/2, x+rX/2, y+rY/2];
                    elseif(BlockLock && ~buttons(1))
                        BlockLock=0;
                    end
                end
            end
            
            if( trackEyes && length(screentime)>1 )
                [left_xyTMP, right_xyTMP, left_pupilTMP, right_pupilTMP, ...
                    left_validityTMP, right_validityTMP, emptyset]=...
                    GetEyeData(screentime(end-1), screentime(end));
                
                if(~emptyset)
                    left_xy(end+1,:)=left_xyTMP(end,:);
                    right_xy(end+1,:)=right_xyTMP(end,:);
                    left_pupil(end+1,:)=left_pupilTMP(end,:);
                    right_pupil(end+1,:)=right_pupilTMP(end,:);
                    left_validity(end+1,:)=left_validityTMP(end,:);
                    right_validity(end+1,:)=right_validityTMP(end,:);
                    
                    EyeInsideScale(end+1)=IsInRect(...
                        mean([left_xy(end,1)*Calib.screen.width right_xy(end,1)*Calib.screen.width]),...
                        mean([left_xy(end,2)*Calib.screen.height right_xy(end,2)*Calib.screen.height]),...
                        centerBlock);
                    
                end
            else
                EyeInsideScale(end+1)=1;
            end
            
            %Find if the moveable block is in the 'scale'
            InsideScale=IsInRect(mean(rectBlock([1 3])), mean(rectBlock([2 4])), centerBlock);
            s = PsychPortAudio('GetStatus', pahandle);
            
            %are we inside the area with right conditions
            if(~BlockLock & InsideScale & ~PD_played & PU_played & ...
                    ~s.Active & ~ReadyForPD)
                ReadyForPD=1;
                putDownTime=GetSecs-t1;
                rectBlock= [...
                    mean(centerBlock([1 3]))-rX/2, mean(centerBlock([2 4]))-rX/2,...
                    mean(centerBlock([1 3]))+rX/2, mean(centerBlock([2 4]))+rY/2];
                disp('Ready PD')
                blockLocked=1;
            end
            
            if(ReadyForPD==1)
                %begin with
                if( (GetSecs-t1-putDownTime) < timeLock/3 )
                    %do nothihg just chill
                    
                elseif( (GetSecs-t1-putDownTime) > TimeToPlayPD && ...
                        ~PD_played && EyeInsideScale(end) )
                    PsychPortAudio('UseSchedule', pahandle, 1);
                    PsychPortAudio('AddToSchedule', pahandle, buffer(pd_rand), 1);
                    %tmp=PsychPortAudio('Start', pahandle, [], 0, 1);
                    SubjectData(trial).PD_AudioStart=tmp-t1;
                    PD_ready_to_play=1;
                    pd_to_viz(1)=GetSecs-t1;
                    disp('Stop PD')
                    tic
                elseif( (GetSecs-t1-putDownTime) > timeLock && PD_played )
                    ReadyForPD=0;
                    blockLocked=0;
                end
            end
        end
        
        %determine when to trigger change
        time1=GetSecs-t1;
        
        if(EyeInsideScale(end))
            if(changeTimeType==1 && ~changeStart && blockLocked)%change is before
                % earliest time when we want change to trigger by
                %tmp1=putDownTime+ TimeToPlayPD + SubjectData(trial).PD_InstructTiming(4,1)-Change_SOA; %slightly before utterance
                tmp1=putDownTime+ TimeToPlayPD - Change_SOA; %slightly before utterance
                
                if( time1>=(tmp1-samplerate))
                    % this is IF the time between now & when audio started is greater than
                    %trigger time
                    changeStart=1;
                    changeLIST(trial,1)=toc; %time when PD was started
                    changeLIST(trial,2)=tmp1; %time we want to make visual change happen
                    changeLIST(trial,3)=tmp1-time1; %time difference between when we want change to happend and when entered this loop
                end
                
            elseif(changeTimeType==2 && ~changeStart && blockLocked & PD_played)% change is after
                tmp2=SubjectData(trial).PD_AudioStart+Change_SOA;
                
                
                if( time1>=(tmp2-samplerate))
                    % keyboard
                    changeStart=1;
                    changeLIST(trial,1)=toc;
                    changeLIST(trial,2)=tmp2;
                    changeLIST(trial,3)=tmp2-time1;
                    changeLIST(trial,4)=tmp2-(0+...
                        SubjectData(trial).PD_AudioStart);
                end
                
            elseif(changeTimeType==3 && ~changeStart && blockLocked & PD_played)% change is same time
                tmp3=SubjectData(trial).PD_AudioStart; %same time as word uttered
                
                if( time1>=(tmp3-samplerate))
                    changeStart=1;
                    changeLIST(trial,1)=toc;
                    changeLIST(trial,2)=tmp3;
                    changeLIST(trial,3)=tmp3-time1;
                    changeLIST(trial,4)=tmp3-(0+...
                        SubjectData(trial).PD_AudioStart);
                end
            end
        end
        
        if(changeTimeFlip>0)
            if( (GetSecs-changeTimeFlip)>= ChangeDuration)
                changeEnd=1;
            end
        end
        
        rectBlockTrial(end+1,:)=rectBlock;
        
        if( sortedInto==0 & ~finished)
            Screen('FillRect', EXPWIN, BLACK);
            Screen('FillRect', EXPWIN, sortAreaColors, [rectSortArea(trial,:,1); rectSortArea(trial,:,2)]');
            
            if(blockLocked)
                Screen('FillRect', EXPWIN, [255 0 0], TrafficLightRect );
            else
                Screen('FillRect', EXPWIN, [0 255 0], TrafficLightRect );
            end
            
            Screen('FillRect', EXPWIN, centerBlockColor, centerBlock);
            
            %test for gaze contingent
            if(0)
                if(EyeInsideScale(end))
                    Screen('FillRect', EXPWIN, [0 0 255], [TrafficLightRect(1:2)*0.975 TrafficLightRect(3:4)*1.025]);
                else
                    Screen('FillRect', EXPWIN, [255 255 0],[TrafficLightRect(1:2)*0.975 TrafficLightRect(3:4)*1.025]);
                end
            end
            
            if(changeStart & ~changeEnd) %change trial
                %Screen('FillRect', EXPWIN, ChangedBlockColor(changeCatType+1,:), rectBlock);
                %Screen('DrawTexture', EXPWIN, blockTex(changeCatType+1), bRect, rectBlock);
                pd_to_viz(2)=GetSecs-t1;
                Screen('FillRect',EXPWIN,[255 255 255]);
            else
                Screen('FillRect', EXPWIN, blockColorTrial, rectBlock);
            end
            
            for i=1:(trialTime-floor(GetSecs-t1))
                Screen('FillRect', EXPWIN, [255 255 50], TimerBlock(:,i))
            end
            
            if(BLUELEFT&TRAINING)
                DrawFormattedText(EXPWIN,'BEAR', rectSortArea(trial,1,1),rectSortArea(trial,4,1), [255 255 255]);
                DrawFormattedText(EXPWIN,'DUCK', rectSortArea(trial,1,2),rectSortArea(trial,4,2), [255 255 255]);
            elseif(TRAINING)
                DrawFormattedText(EXPWIN,'DUCK', rectSortArea(trial,1,1),rectSortArea(trial,4,1), [255 255 255]);
                DrawFormattedText(EXPWIN,'BEAR', rectSortArea(trial,1,2),rectSortArea(trial,4,2), [255 255 255]);
            end
            
            Screen('FillRect', EXPWIN, [255 255 255], rMouse );
            
        elseif(  sortedInto~=0 & finished)
            Screen('FillRect', EXPWIN, BLACK);
            Screen('FillRect', EXPWIN, sortAreaColors, [rectSortArea(trial,:,1); rectSortArea(trial,:,2)]');
            
            if(blockLocked)
                Screen('FillRect', EXPWIN, [255 0 0], TrafficLightRect );
            else
                Screen('FillRect', EXPWIN, [0 255 0], TrafficLightRect );
            end
            
            Screen('FillRect', EXPWIN, centerBlockColor, centerBlock);
            
            %render all but sorted block!
            tmp_idx=ones(nBlocks,1); tmp_idx(TouchedNum)=0;
            
            Screen('FillRect', EXPWIN, [255 255 255], rMouse );
            if(sortedInto==(changeCatType+1))
                DrawFormattedText(EXPWIN,'+1\n \nGreat!','Center',...
                    Calib.screen.height/2, [0 205 0]);
                
                tally=tally+1;
            else
                DrawFormattedText(EXPWIN,'-1\n \nWRONG!!!','Center',...
                    Calib.screen.height/2, [205 0 0]);
                
                tally=tally-1;
            end
            % keyboard
            
            DrawFormattedText(EXPWIN,['Point Total =  ' num2str(tally)],...
                'Center', Calib.screen.height*.75, [155 155 0]);
            
        elseif( sortedInto==0 & finished )
            DrawFormattedText(EXPWIN,'-1\n \nTOO SLOW!','Center',...
                Calib.screen.height/2, [255 0 0]);
            
            tally=tally-1;
            DrawFormattedText(EXPWIN,['Point Total =  ' num2str(tally)],...
                'Center', Calib.screen.height*.75, [200 200 0]);
            
        end
        screentime(end+1,:)=Screen(EXPWIN,'Flip');
        if(PD_ready_to_play)
            audioTime=PsychPortAudio('Start', pahandle, [], 0, 1);
            PD_played=1;
            PD_ready_to_play=0;
        end
        
        if(changeStart && ~changeEndTiming)
            changeTimeFlip=screentime(end);
            changeEndTiming=1;
        end
        
    end
    
    
    keyboard
    
    WaitSecs(1.5)
    if(changeTimeType==1 && changeStart && PD_played)
%        changeLIST(trial,4)=tmp1-(SubjectData(trial).PD_InstructTiming(4,1)+...
%            SubjectData(trial).PD_AudioStart);
    end
    
    %after each trial we should save
    ShowCursor;
    
    if(debug)
        figure(1); clf; hold on;
        plot(screentime-screentime(1))
        figure(2); clf; hold on;
        plot(SubjectData(trial).mouse(:,1), Calib.screen.height-SubjectData(trial).mouse(:,2),'k')
        plot( SubjectData(trial).leye_xypv(:,1)*Calib.screen.width, ...
            Calib.screen.height-SubjectData(trial).leye_xypv(:,2)*Calib.screen.height,'*r' )
        plot( SubjectData(trial).reye_xypv(:,1)*Calib.screen.width, ...
            Calib.screen.height-SubjectData(trial).reye_xypv(:,2)*Calib.screen.height,'*b' )
        xlim([0 Calib.screen.width]); ylim([0 Calib.screen.height]);
    end
    
    
    SubjectData(trial).time=screentime-screentime(1);
    SubjectData(trial).mouse=mouseTrial;
    SubjectData(trial).sortBlocks=rectBlockTrial;
    SubjectData(trial).SortedInto=sortedInto;
    SubjectData(trial).ChangeTimeStart=startChangeTime-t1;
    SubjectData(trial).ChangeTimeFlip=changeTimeFlip-t1;
    SubjectData(trial).ChangeTimeType=changeTimeType;
    SubjectData(trial).BlockColor=blockColorTrial;
    SubjectData(trial).EyeInsideScale=EyeInsideScale;
    if(trackEyes)
        SubjectData(trial).leye_xypv=[left_xy  left_pupil   left_validity];
        SubjectData(trial).reye_xypv=[right_xy right_pupil right_validity];
    end
    %keyboard
end

ShowCursor

if(trackEyes)
    EyeErrorTestEnd=TestEyeTrackerError(Calib,mOrder);
end
Screen('FillRect',EXPWIN,BLACK);
DrawFormattedText(EXPWIN,'Thank you for Participating!','Center',...
    Calib.screen.height/3, [255 255 255]);
Screen(EXPWIN,'Flip');
WaitSecs(3);

Constants.NumberTrials=numTrials;
Constants.NumberSortBlocks=nBlocks;
Constants.SortAreaColor=sortAreaColors;
Constants.SortAreaLocation=rectSortArea;
Constants.centerBlock=centerBlock;
Constants.centerBlockColor=centerBlockColor;
Constants.TrafficLight=TrafficLightRect;

Constants.FixPoint=fixPointRect;
Constants.SortBlocksColor=blockColorList;
Constants.ChangedBlockColor=ChangedBlockColor;
Constants.changeCatTypeList=changeCatTypeList;
Constants.changeTimeTypeList=changeTimeTypeList;
Constants.conflictList=conflictList;

if(trackEyes)
    save(savefile,'SubjectData','Calib', 'numTrials','nBlocks',...
        'EyeErrorTestStart','EyeErrorTestEnd','Constants')
end

Screen('CloseAll')

% Stop playback:
PsychPortAudio('Stop', pahandle);

% Delete all dynamic audio buffers:
PsychPortAudio('DeleteBuffer');

% Close audio device, shutdown driver:
PsychPortAudio('Close');

%keyboard