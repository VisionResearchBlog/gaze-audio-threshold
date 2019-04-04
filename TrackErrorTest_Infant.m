function eyes= TrackErrorTest_Infant(Calib,morder,Constants)
global EXPWIN BLACK
%CALIBRATE calibrate the eye tracker
%   This function is used to set and view the calibration results for the tobii eye tracker.
%
%   Input:
%         Calib: The calib structure (see CalibParams)
%         morder: Order of the calibration point
%         iter: 0/1 (0 = A new calibation call, ensure that calibration is not already started)
%                   (1 = just fixing a few Calibration points)
%         donts: Points (with one in the index) that are to be
%         recalibrated, 0 else where
%   Output:
%         calibPlotData: The calibration plot data, specifying the input and output calibration data


disp('In Tracker Test')
assert(Calib.points.n >= 2 && length(Calib.points.x)==Calib.points.n, ...
    'Err: Invalid Calibration params, Verify...');

FixPointVidDir=dir([Constants.calpoint_dir '*.mp4']);
fn=randi(length(FixPointVidDir));
moviename = [Constants.calpoint_dir FixPointVidDir(fn).name];


movieWidthReduced = Constants.calpoint_size; % movieWidth*0.5;
movieHeightReduced = Constants.calpoint_size;  %movieHeight*0.5;

validmat = ones(1,Calib.points.n);
WaitSecs(0.25);

for  i =1:Calib.points.n
    
 
    vidObj=VideoReader(moviename);
    [Y,FS] = audioread(moviename);
    
    %show the big marker
    if (validmat(i)==0)
        continue;
    end
    
    %Prepare movie location
    sRect (1) = round(Calib.screen.width*Calib.points.x(morder(i))-movieWidthReduced/2);
    sRect (2) = round(Calib.screen.height*Calib.points.y(morder(i))-movieHeightReduced/2);
    sRect (3) = round(Calib.screen.width*Calib.points.x(morder(i))+movieWidthReduced/2);
    sRect (4) = round(Calib.screen.height*Calib.points.y(morder(i))+movieHeightReduced/2);
    
    %sound(Y*Constants.CalVolume,FS) %soften sound
    sound(Y*Constants.CalVolume, FS*((length(Y)/FS)/Constants.CalVideoLength) )
    
    Screen('FillRect',EXPWIN,BLACK);
    t1=Screen('Flip', EXPWIN);
    
    while 1
        % Wait for next movie frame, retrieve texture handle to it
        %tex = Screen('GetMovieImage', EXPWIN, movie);
        tex=Screen('MakeTexture', EXPWIN, vidObj.readFrame);
        
        % Draw the new texture immediately to screen:
        
        if (vidObj.hasFrame)
            %Screen('DrawTexture', EXPWIN,tex,[0 0 movieWidth movieHeight],sRect);
            Screen('DrawTexture', EXPWIN, tex,[],sRect);
            
            % Update display:
            Screen('Flip', EXPWIN);
            % Release texture:
            Screen('Close', tex);
        else
            break
        end
        
        %calculate appropriate wait time to enforce common length
        WaitSecs(1/(round(vidObj.Duration*vidObj.FrameRate)/Constants.CalVideoLength));
        
    end
    
    %t2=Screen(EXPWIN, 'Flip');
    GazeDataCurrent= Calib.tracker.get_gaze_data();
    GazeData = ParseGazeData(GazeDataCurrent); % Parse last gaze data.
    
    eyes.left(i).xy=[GazeData.left_gaze_point_2d.x GazeData.left_gaze_point_2d.y];
    eyes.right(i).xy=[GazeData.right_gaze_point_2d.x GazeData.right_gaze_point_2d.y];
    eyes.left(i).pupil=GazeData.left_pupil_diameter;
    eyes.right(i).pupil=GazeData.right_pupil_diameter;
    eyes.left(i).validity=GazeData.left_validity;
    eyes.right(i).validity=GazeData.right_validity ;
    
    disp(['Point: ' num2str(i)])
    
    
end


Screen('FillRect',EXPWIN,Calib.bkcolor*255);
Screen(EXPWIN, 'Flip');
disp('Out Tracker Test')



return