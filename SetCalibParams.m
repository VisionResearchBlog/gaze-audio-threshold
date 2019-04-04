function Calib = SetCalibParams(screenNumber, SKIP_SYNC)

global EXPWIN GREY

if(SKIP_SYNC)
    Screen('Preference', 'SkipSyncTests', 1);
end

screens=Screen('Screens');
%Select the screen where the stimulus is going to be presented
if(exist('screenNumber'))
    Calib.screenNumber=screenNumber;
else
     Calib.screenNumber=max(screens);
end

[EXPWIN, winRect] = Screen('OpenWindow', Calib.screenNumber);

%in future we should be able to get dimensions automated
Calib.screen.sz=[43.5 26.7];  %display screen dimensions  (cm) 

Calib.screen.vdist= 60; % Observer's viewing distance to screen (cm)

disp(['Using Viewing Distance of: ' num2str(Calib.screen.vdist) ...
    'cm, with monitor width of ' num2str(Calib.screen.sz(1)) ...
    'cm and height of ' num2str(Calib.screen.sz(2)) 'cm'])
Calib.screen.x = winRect(1);
Calib.screen.y = winRect(2);
Calib.screen.width = winRect(3);
Calib.screen.height = winRect(4);

degperpix=2*((atan(Calib.screen.sz ./ (2*Calib.screen.vdist))).*(180/pi))./[Calib.screen.width Calib.screen.height];
pixperdeg=1./degperpix;
Calib.screen.pixperdeg_xy=1./degperpix;
Calib.screen.degperpix = mean(degperpix);
Calib.screen.pixperdeg = mean(pixperdeg);

Calib.points.x = [0.1 0.9 0.5 0.9 0.1];  % X coordinates in [0,1] coordinate system
Calib.points.y = [0.1 0.1 0.5 0.9 0.9];  % Y coordinates in [0,1] coordinate system
Calib.points.n = size(Calib.points.x, 2); % Number of calibration points
Calib.bkcolor = GREY; % background color used in calibration process
Calib.fgcolor = [0 0 1]; % (Foreground) color used in calibration process
Calib.fgcolor2 = [1 0 0]; % Color used in calibration process when a second foreground color is used (Calibration dot)

Calib.BigMark = 65; % the big marker
Calib.TrackStat = 25; %
Calib.SmallMark = 7; % the small marker
Calib.delta = 250; % Moving speed from point a to point b
Calib.resize = 1; % To show a smaller window

Calib.subject_control=1; %subject clicks when ready for calib point
return



