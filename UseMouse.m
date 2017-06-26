[mx,my]=GetMouse(Calib.screenNumber);
%tobii outputs values zero to one
mx=mx/Calib.screen.width;
my=my/Calib.screen.height;

left_xyTMP=[mx my];
right_xyTMP=[mx my];

%create fake data to pass eye data quality checks
left_pupilTMP=10;
right_pupilTMP=10;
left_validityTMP=4;
right_validityTMP=4;
emptyset=0;