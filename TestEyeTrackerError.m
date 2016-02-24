function EyeErrorResult=TestEyeTrackerError(Calib,mOrder,Constants)

global KEYBOARD SPACEKEY EXPWIN BLACK

% DrawFormattedText(EXPWIN,'Click mouse to Start Calibration Check','Center',...
%     Calib.screen.height/3, [255 255 255]);
% Screen(EXPWIN,'Flip');
% 
% clickToStart=1;
% while (clickToStart) % wait for press
%     [x,y,buttons] = GetMouse(Calib.screenNumber);
%     if(any(buttons))
%         clickToStart=0;
%     end
% end
WaitSecs(2)

errorTestDat=TrackErrorTest_Infant(Calib,mOrder,Constants);
EyeErrorResult = PlotTrackError(mOrder, Calib, errorTestDat);

clickToStart=1;

% while (clickToStart) % wait for press
%     [x,y,buttons] = GetMouse(Calib.screenNumber);
%     if(any(buttons))
%         clickToStart=0;
%     end
% end

while (clickToStart) % wait for press
    [~,~,keyCode]=PsychHID('KbCheck', KEYBOARD);
    if keyCode(SPACEKEY)
        clickToStart=0;
    end
end

return