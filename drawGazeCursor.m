%get recent eye pos
GetGazeDataTypes

%window to average cursor over
c=5;

if(~emptyset)
    left_xy_PRE(end+1,:)=left_xyTMP(end,:);
    right_xy_PRE(end+1,:)=right_xyTMP(end,:);
    left_pupil_PRE(end+1,:)=left_pupilTMP(end,:);
    right_pupil_PRE(end+1,:)=right_pupilTMP(end,:);
    left_validity_PRE(end+1,:)=left_validityTMP(end,:);
    right_validity_PRE(end+1,:)=right_validityTMP(end,:);
    EyeTime_PRE(end+1)=ScreenTime(end);
    
    EyeInsideLR_PRE(end+1,1)=EyeInAOI_Median(right_xy_PRE(end,:),...
        left_xy_PRE(end,:),Calib,LeftChoiceSquare,Constants.AOI_border);
    EyeInsideLR_PRE(end,2)=EyeInAOI_Median(right_xy_PRE(end,:),...
        left_xy_PRE(end,:),Calib,RightChoiceSquare,Constants.AOI_border);
    
    
    
    if(length(left_xy_PRE)>c)
        x=median(median([right_xy_PRE(end-c:end,1) left_xy_PRE(end-c:end,1)]))*Calib.screen.width;
        y=median(median([right_xy_PRE(end-c:end,2) left_xy_PRE(end-c:end,2)]))*Calib.screen.height;
        gazeCursor = [x-Constants.gXY/2, y-Constants.gXY/2, ...
            x+Constants.gXY/2, y+Constants.gXY/2];
        Screen('FillRect', EXPWIN, Constants.gColor, gazeCursor );
    end
    
end
