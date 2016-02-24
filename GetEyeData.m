function [left_xy, right_xy, left_pupil, right_pupil, left_validity,...
    right_validity, emptyset]=GetEyeData(StimShownTime, StimEndTime)

emptyset=0;

[lefteye, righteye, timestamp, ~] = tetio_readGazeData;

if(~isempty(timestamp))
    
if ~tetio_clockSyncState()
    disp('No data collected: Clocks are not synchronized');
    return;
end


numStamps = size(timestamp); %Number of samples collected
timestamp64 = int64(timestamp); %The function remoteToLocalTime() requires a int64 format

%Convert the timestamps collected to local time

for i=1:numStamps
    remoteToLocalTime(i,1) = tetio_remoteToLocalTime(timestamp64(i,1));
end

[~,startIdx]=min(abs(remoteToLocalTime-int64(StimShownTime*10e5)));
[~,endIdx]=min(abs(remoteToLocalTime-int64(StimEndTime*10e5)));
range=startIdx:endIdx;

[left_xy, right_xy, left_pupil, right_pupil, left_validity,...
    right_validity]=ParseGazeDataExp(lefteye(range,:), righteye(range,:));
%     rx=median(Calib.screen.width*GazeData.right_gaze_point_2d.x(end) );
%     ry=median(Calib.screen.height*GazeData.right_gaze_point_2d.y(end));
%     lx=median(Calib.screen.width*GazeData.left_gaze_point_2d.x(end) );
%     ly=median(Calib.screen.height*GazeData.left_gaze_point_2d.y(end));
%     gazepos=[ mean([rx lx])  mean([ry ly])];
else
  emptyset=1;

  left_xy=0; right_xy=0; left_pupil=0; 
  right_pupil=0; left_validity=0; right_validity=0;

end

return