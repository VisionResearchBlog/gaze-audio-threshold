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

%****************************
% Connect to eye tracker
%****************************

disp('Initializing tetio...');
tetio_init();
fprintf('Connecting to tracker "%s"...\n', eyetrackerhost);
%keyboard
tetio_connectTracker(eyetrackerhost)

%Wait until the synchronization of ET and Matlab clock is finished
tic; 
while tetio_clockSyncState() == 0
    pause(0.25)
    if toc > 5
        tetio_cleanUP()
        error('Error: Unable to synchronize Eye Tracker and computer clocks, retrying');
    end
end  	

%Get and print the Frame rate of the current ET
%tetio_setFrameRate(60);
fprintf('Frame rate: %d Hz.\n', tetio_getFrameRate);

%*********************
% TrackStatus
%*********************
TrackStatus(Calib);

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


