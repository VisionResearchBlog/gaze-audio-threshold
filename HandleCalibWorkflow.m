function [pts,TrackError,calibPlot] = HandleCalibWorkflow(Calib,Constants)
%HandleCalibWorkflow Main function for handling the calibration workflow.
%   Input:
%         Calib: The calib config structure (see SetCalibParams)
%   Output:
%         pts: The list of points used for calibration. These could be
%         further used for the analysis such as the variance, mean etc.

global EXPWIN GREY
TrackError=[];
calLoop=1;

while(1)
    disp('1')
    try
        while(calLoop)
            mOrder = randperm(Calib.points.n);
            disp('2')
            calibPlot = Calibrate_infant(Calib,mOrder, 0, [],Constants);
            disp('3')
            
            % Show calibration points and compute calibration.
            %do the same but with psychtoolbox and more info + user interaction
            [pts, TrackError] = PlotCalibrationPoints_Psychtoolbox(calibPlot, mOrder, Calib);
            
            %PlotCalibrationPoints_Psychtoolbox leaves up the recent
            %claibration & error estimates - here we wait for repsonse from
            %user
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
            
        end
    catch ME    %  Calibration failed
        Screen('FillRect',EXPWIN,GREY);
        Screen('TextSize',EXPWIN , 15);
        DrawFormattedText(EXPWIN,'Not enough calibration data. Do you want to try again([y]/n), Else continue to Experiment','Center',Calib.screen.height/2, [0 0 0]);
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
    end
end








