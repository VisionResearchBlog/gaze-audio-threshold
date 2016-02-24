function [left_xy, right_xy, left_pupil, right_pupil, left_validity,...
    right_validity] = ParseGazeData(gazedataleft, gazedataright)
%PARSEGAZEDATA is used to parse the gazedata from each eye.

if ~isempty(gazedataleft)
    %GazeData.left_eye_position_3d.x = gazedataleft(:,1);
    %GazeData.left_eye_position_3d.y = gazedataleft(:,2);
    %GazeData.left_eye_position_3d.z = gazedataleft(:,3);
    %GazeData.left_eye_position_3d_relative.x = gazedataleft(:,4);
    %GazeData.left_eye_position_3d_relative.y = gazedataleft(:,5);
    %GazeData.left_eye_position_3d_relative.z = gazedataleft(:,6);
    left_xy = [gazedataleft(:,7) gazedataleft(:,8)];
    %GazeData.left_gaze_point_3d.x = gazedataleft(:,9);
    %GazeData.left_gaze_point_3d.y = gazedataleft(:,10);
    %GazeData.left_gaze_point_3d.z = gazedataleft(:,11);
    left_pupil = gazedataleft(:,12);
    left_validity = gazedataleft(:,13);
end

if ~isempty(gazedataright)
    %GazeData.right_eye_position_3d.x = gazedataright(:,1);
    %GazeData.right_eye_position_3d.y = gazedataright(:,2);
    %GazeData.right_eye_position_3d.z = gazedataright(:,3);
    %GazeData.right_eye_position_3d_relative.x = gazedataright(:,4);
    %GazeData.right_eye_position_3d_relative.y = gazedataright(:,5);
    %GazeData.right_eye_position_3d_relative.z = gazedataright(:,6);
    right_xy = [gazedataright(:,7) gazedataright(:,8)];
    %GazeData.right_gaze_point_3d.x = gazedataright(:,9);
    %GazeData.right_gaze_point_3d.y = gazedataright(:,10);
    %GazeData.right_gaze_point_3d.z = gazedataright(:,11);
    right_pupil = gazedataright(:,12);
    right_validity = gazedataright(:,13);
end

return