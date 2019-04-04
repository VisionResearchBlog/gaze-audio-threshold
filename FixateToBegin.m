
fixateToStart=1;
left_xy_PRE=[]; right_xy_PRE=[]; left_pupil_PRE=[];
right_pupil_PRE=[]; left_validity_PRE=[]; right_validity_PRE=[];
EyeInsideLR_PRE=[]; EyeTime_PRE=[];
OffsetFixationSquare=FixationSquare;

while (fixateToStart) % wait for press
    
    Screen('FillRect',EXPWIN,GREY);
    Screen('DrawTexture', EXPWIN, blockTex, bRect, OffsetFixationSquare);
    
    if(Constants.UseEyeTracker)
       GetGazeDataTypes
    else
        UseMouse
    end
    
    if(~emptyset)
        left_xy_PRE(end+1,:)=left_xyTMP(end,:);
        right_xy_PRE(end+1,:)=right_xyTMP(end,:);
        left_pupil_PRE(end+1,:)=left_pupilTMP(end,:);
        right_pupil_PRE(end+1,:)=right_pupilTMP(end,:);
        left_validity_PRE(end+1,:)=left_validityTMP(end,:);
        right_validity_PRE(end+1,:)=right_validityTMP(end,:);
        EyeTime_PRE(end+1)=ScreenTime(end);
        
        %only one data point most recent
        %EyeInsideLR_PRE(end+1,3)=EyeInAOI_Median(right_xy_PRE(end,:),... %is eye in AOI? yes / no
        %    left_xy_PRE(end,:),Calib,OffsetFixationSquare,Constants.AOI_border);
        
        %median
        EyeInsideLR_PRE(end+1,3)=EyeInAOI_Median(right_xyTMP,... %is eye in AOI? yes / no
            left_xyTMP,Calib,OffsetFixationSquare,Constants.AOI_border);
        
        if(size(EyeInsideLR_PRE,1)>Constants.FixThreshFixationImage) %is it large enough for the constant fixation threshold?
            if(sum(EyeInsideLR_PRE(end-Constants.FixThreshFixationImage:end,3))>=Constants.FixThreshFixationImage) % if it is long enough (ie 45 samples) is the length of time
                %that fix was inside AOI minus the time ist was not in the
                %AOI above the threshold?
                fixateToStart=0; % if yes - keep waiting for fix, if no - continute to audio.
            else
                if(size(EyeInsideLR_PRE,1)>Constants.ShakeFixThresh)
                    %will shake +/-2 degress at scale of 0.05
                    x_offset=sin(length(ScreenTime)*0.1)*Calib.screen.pixperdeg*.05;
                    OffsetFixationSquare(1)=OffsetFixationSquare(1)+x_offset;
                    OffsetFixationSquare(3)=OffsetFixationSquare(3)+x_offset;
                end
            end
            
        end
        
        %should we filter out invalid samples too?
        if(Constants.showGaze)
            drawGazeCursorNoPoll;
        end
        
    end
    
    ScreenTime(end+1)=Screen(EXPWIN,'Flip');
    
    Recalibrate;
    
    if(CheckEsc)
        training=0;
        finished=1;
        ESC_PRESSED=1;
    end
    
end


