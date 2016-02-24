function [pts,TrackError,calibplot] = HandleCalibWorkflow(Calib,Constants)
%HandleCalibWorkflow Main function for handling the calibration workflow.
%   Input:
%         Calib: The calib config structure (see SetCalibParams)
%   Output:
%         pts: The list of points used for calibration. These could be
%         further used for the analysis such as the variance, mean etc.

global BLACK EXPWIN
TrackError=[];
calLoop=1;

while(1)
    disp('1')
    try
        mOrder = randperm(Calib.points.n);
        disp('2')
        calibplot = Calibrate_infant(Calib,mOrder, 0, [],Constants);
        disp('3')

        % Show calibration points and compute calibration.
        %do the same but with psychtoolbox and more info + user interaction
        [pts, TrackError] = PlotCalibrationPoints_Psychtoolbox(calibplot, mOrder, Calib);

        while(calLoop)
            
            clear keyIsDown keyCode
            while KbCheck; end %wait for release
            FlushEvents; go=1;
            while go %accept calibration prompt?
                [~,~,keyCode,~] = KbCheck;
                if(find(keyCode)== 13 | find(keyCode)== 89 )
                    disp('Stopping Calibration')
                    return
                elseif(find(keyCode)== 78)
                    go=0;
                    disp('Recalibrating')
                end
            end
            
            Screen('FillRect',EXPWIN,BLACK);
            DrawFormattedText(EXPWIN,'Recalibrate all points (a) or some points (b)? Type a or b and return','Center',Calib.screen.height/2, [120 170 175]);
            Screen(EXPWIN,'Flip');
            
            
            clear keyIsDown keyCode
            while KbCheck; end %wait for release
            FlushEvents; go=1;
            while go %accept calibration prompt?
                [~,~,keyCode,~] = KbCheck;
                if(find(keyCode)== 65 )
                    go=0; allpts=1;
                elseif(find(keyCode)== 66)
                    go=0; allpts=0;
                end
            end
            
            if allpts
                close all;
                break;
            else
                Screen('FillRect',EXPWIN,BLACK);
                DrawFormattedText(EXPWIN,'Please enter (space separated) the points you wish to recalibrate, eg. 1 3, Followed by return:','Center',Calib.screen.height/2, [255 255 255]);
                Screen(EXPWIN,'Flip');
                h = input('Please enter (space separated) the point numbers that you wish to recalibrate e.g. 1 3, Followed by return:  ', 's');
                
                recalibpts = str2num(h);
                [calibplot, calibError] = Calibrate(Calib,mOrder, 1, recalibpts);
 
                if(calibError)
                    Screen('FillRect',EXPWIN,BLACK);
                    Screen('TextSize',EXPWIN , 15);
                    DrawFormattedText(EXPWIN,'Failed to compute calibration. Starting full calibration','Center',Calib.screen.height/2, [255 255 255]);
                    Screen(EXPWIN,'Flip');
                    WaitSecs(3);
                    break;
                end
                
                [pts, TrackError] = PlotCalibrationPoints_Psychtoolbox(calibplot, mOrder, Calib);% Show calibration points and compute calibration.
                
                clear keyIsDown keyCode
                while KbCheck; end %wait for release
                FlushEvents; go=1;
                
                while go %accept calibration prompt?
                    [~,~,keyCode,~] = KbCheck;
                    if(find(keyCode)== 13 | find(keyCode)== 89 )
                        disp('Stopping Calibration')
                        return
                    elseif(find(keyCode)== 78)
                        go=0;
                        disp('Recalibrating')
                        allpts=1;
                    end
                end
                
                
                
            end
        end
    catch ME    %  Calibration failed
        Screen('FillRect',EXPWIN,BLACK);
        Screen('TextSize',EXPWIN , 15);
        DrawFormattedText(EXPWIN,'Not enough calibration data. Do you want to try again([y]/n), Else continue to Experiment','Center',Calib.screen.height/2, [255 255 255]);
        Screen(EXPWIN,'Flip');

        ME
        
        clear keyIsDown keyCode
        while KbCheck; end %wait for release
        FlushEvents; go=1;
        while go %accept calibration prompt?
            [~,~,keyCode,~] = KbCheck;
            if(find(keyCode)== 89 | find(keyCode)== 13)
                go=0; not_enough_calData=1;
            elseif(find(keyCode)== 78)
                go=0; not_enough_calData=0;
            end
        end
        
        pts=[];
        if not_enough_calData %recalibrate
            try
                tetio_stopCalib
            end
            continue;
        else
            return; %quit calib
        end
        
    end
end








