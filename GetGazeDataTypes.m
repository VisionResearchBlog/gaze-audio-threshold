%get gaze data

GazeDataCurrent= Calib.tracker.get_gaze_data();

if(isempty(GazeDataCurrent))
    emptyset=1;
else
    GazeData = ParseGazeData(GazeDataCurrent); % Parse last gaze data.
    left_xyTMP=[GazeData.left_gaze_point_2d.x ...
        GazeData.left_gaze_point_2d.y];
    right_xyTMP=[ GazeData.right_gaze_point_2d.x ...
        GazeData.right_gaze_point_2d.y];
    left_pupilTMP=GazeData.left_pupil_diameter;
    right_pupilTMP=GazeData.right_pupil_diameter;
    left_validityTMP=GazeData.left_validity;
    right_validityTMP=GazeData.right_validity;
    emptyset=0;
end