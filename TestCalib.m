function [pts,TrackError] = TestCalib(Calib)

mOrder = randperm(Calib.points.n);
eyes=TrackErrorTest(Calib,mOrder);
[pts, error2] = PlotCalibrationPoints_Psychtoolbox(eyes, mOrder, Calib);

return









