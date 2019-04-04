global EXPWIN KEYBOARD SPACEKEY CENTER GREY Calib

%**************************
% Open Psychtoolbox window
%**************************
Screen('Preference','SkipSyncTests',1);

%Open settings for screen & tracker
%Calib=SetCalibParams;

%Window variables
CENTER = [round((Calib.screen.width - Calib.screen.x)/2) ...
    round((Calib.screen.height -Calib.screen.y)/2)];
KEYBOARD=max(GetKeyboardIndices);
SPACEKEY = 32;%Windows system key code

    




%*********************
% TrackStatus
%*********************
TrackStatus(Calib, Tobii, Calib.tracker);

%*********************
% Calibration
%*********************
disp('Starting Calibration workflow');
[pts, TrackError,calibplot] = HandleCalibWorkflow(Calib,Constants);
disp('Calibration workflow stopped');
Screen('FillRect',EXPWIN,GREY);
Screen(EXPWIN,'Flip');
 
%*********************
% Calibration finished
%********************
%tetio_cleanUp()
%Screen('Close',EXPWIN)
disp('Displaying point by point error:')
disp('[Mean StandardDev]')
TrackError
disp('Closing Calibration Software')


