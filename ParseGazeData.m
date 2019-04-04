function GazeDataParsed = ParseGazeData(GazeData)
%PARSEGAZEDATA is used to parse the gazedata from each eye.

if ~isempty(GazeData)
    GazeDataParsed.left_gaze_point_2d.x = double(GazeData(end).LeftEye.GazePoint.OnDisplayArea(1));
    GazeDataParsed.left_gaze_point_2d.y = double(GazeData(end).LeftEye.GazePoint.OnDisplayArea(2));
    GazeDataParsed.left_pupil_diameter = double(GazeData(end).LeftEye.Pupil.Diameter);
    GazeDataParsed.left_validity = GazeData(end).LeftEye.GazePoint.Validity.value;
    
    GazeDataParsed.left_eye_position_3d.x = double(GazeData(end).LeftEye.GazeOrigin.InUserCoordinateSystem(1));
    GazeDataParsed.left_eye_position_3d.y = double(GazeData(end).LeftEye.GazeOrigin.InUserCoordinateSystem(2));
    GazeDataParsed.left_eye_position_3d.z = double(GazeData(end).LeftEye.GazeOrigin.InUserCoordinateSystem(3));
    
    GazeDataParsed.left_eye_position_3d_relative.x = double(GazeData(end).LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(1));
    GazeDataParsed.left_eye_position_3d_relative.y = double(GazeData(end).LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(2));
    GazeDataParsed.left_eye_position_3d_relative.z = double(GazeData(end).LeftEye.GazeOrigin.InTrackBoxCoordinateSystem(3));
    
    GazeDataParsed.left_gaze_point_3d.x = double(GazeData(end).LeftEye.GazePoint.InUserCoordinateSystem(1));
    GazeDataParsed.left_gaze_point_3d.y = double(GazeData(end).LeftEye.GazePoint.InUserCoordinateSystem(2));
    GazeDataParsed.left_gaze_point_3d.z = double(GazeData(end).LeftEye.GazePoint.InUserCoordinateSystem(3));

    GazeDataParsed.right_gaze_point_2d.x = double(GazeData(end).RightEye.GazePoint.OnDisplayArea(1));
    GazeDataParsed.right_gaze_point_2d.y = double(GazeData(end).RightEye.GazePoint.OnDisplayArea(2));
    GazeDataParsed.right_pupil_diameter = double(GazeData(end).RightEye.Pupil.Diameter);
    GazeDataParsed.right_validity = GazeData(end).RightEye.GazePoint.Validity.value;
    
    GazeDataParsed.right_eye_position_3d.x = double(GazeData(end).RightEye.GazeOrigin.InUserCoordinateSystem(1));
    GazeDataParsed.right_eye_position_3d.y = double(GazeData(end).RightEye.GazeOrigin.InUserCoordinateSystem(2));
    GazeDataParsed.right_eye_position_3d.z = double(GazeData(end).RightEye.GazeOrigin.InUserCoordinateSystem(3));
    
    GazeDataParsed.right_eye_position_3d_relative.x = double(GazeData(end).RightEye.GazeOrigin.InTrackBoxCoordinateSystem(1));
    GazeDataParsed.right_eye_position_3d_relative.y = double(GazeData(end).RightEye.GazeOrigin.InTrackBoxCoordinateSystem(2));
    GazeDataParsed.right_eye_position_3d_relative.z = double(GazeData(end).RightEye.GazeOrigin.InTrackBoxCoordinateSystem(3));
    
    GazeDataParsed.right_gaze_point_3d.x = double(GazeData(end).RightEye.GazePoint.InUserCoordinateSystem(1));
    GazeDataParsed.right_gaze_point_3d.y = double(GazeData(end).RightEye.GazePoint.InUserCoordinateSystem(2));
    GazeDataParsed.right_gaze_point_3d.z = double(GazeData(end).RightEye.GazePoint.InUserCoordinateSystem(3));

end

if ~exist('GazeDataParsed'); disp('Eye tracking data Not streaming, error!'); end
end
