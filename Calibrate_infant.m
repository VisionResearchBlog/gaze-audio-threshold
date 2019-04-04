function calibPlotData = Calibrate_infant(Calib,morder,iter,donts,Constants,tracker)
global EXPWIN GREY

%CALIBRATE calibrate the eye tracker
%   This function is used to set and view the calibration results for the tobii eye tracker.
%
%   Input:
%         Calib: The calib structure (see CalibParams)
%         morder: Order of the calibration point
%         iter: 0/1 (0 = A new calibation call, esnure that calibration is not already started)
%                   (1 = just fixing a few Calibration points)
%         donts: Points (with one in the index) that are to be
%         recalibrated, 0 else where
%   Output:
%         calibPlotData: The calibration plot data, specifying the input and output calibration data

calibPlotData = 0;

assert(Calib.points.n >= 2 && length(Calib.points.x)==Calib.points.n, ...
    'Err: Invalid Calibration params, Verify...');

%THE MOVIE AND THE FUNCTION THAT RUNS IT (THIS ONE) MUST BE IN THE
%MATLAB WORKING FOLDER. Otherwise Screen(OpenMovie) won't work
%tl x,y br x,y

FixPointVidDir=dir([Constants.calpoint_dir '*.mp4']);
fn=randi(length(FixPointVidDir));
moviename = [Constants.calpoint_dir FixPointVidDir(fn).name];

try
    tobiicalib = ScreenBasedCalibration(Calib.tracker);
    tobiicalib.enter_calibration_mode()
catch error
    disp( 'calibration error')
    disp(error.message)
end

try
    
    movieWidthReduced = Constants.calpoint_size; % movieWidth*0.5;
    movieHeightReduced = Constants.calpoint_size;  %movieHeight*0.5;
    
    
    Screen('FillRect',EXPWIN,Calib.bkcolor);
    Screen(EXPWIN, 'Flip');
    
    
    idx = 0;
    validmat = ones(1,Calib.points.n);
    %generate validity matrix
    if ~isempty(donts)
        validmat = zeros(1,Calib.points.n);
        for i = 1:length(donts)
            validmat(morder==donts(i))=1;
        end
    end
    
    pause(1);
    Screen('FillRect',EXPWIN,Calib.bkcolor);
    tic;
    %Open movie
    movie = 0;
    %[ movie duration fps movieWidth movieHeight count aspectRatio] = Screen('OpenMovie', EXPWIN, moviename);
    %Screen('PlayMovie', movie, 1,1,1.0);
    
    
    for  i =1:Calib.points.n
        vidObj= VideoReader(moviename);
        [Y,FS] = audioread(moviename);
        idx = idx+1;
        if (validmat(i)==0)
            continue;
        end
        
        %Prepare movie location
        sRect (1) = round(Calib.screen.width*Calib.points.x(morder(i))-movieWidthReduced/2);
        sRect (2) = round(Calib.screen.height*Calib.points.y(morder(i))-movieHeightReduced/2);
        sRect (3) = round(Calib.screen.width*Calib.points.x(morder(i))+movieWidthReduced/2);
        sRect (4) = round(Calib.screen.height*Calib.points.y(morder(i))+movieHeightReduced/2);
        
        %sound(Y*Constants.CalVolume,FS)
        sound(Y*Constants.CalVolume, FS*((length(Y)/FS)/Constants.CalVideoLength) )
        
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
        calibration_result = tobiicalib.collect_data([Calib.points.x(morder(i)),Calib.points.y(morder(i))]);
        
    end
    
    Screen('FillRect',EXPWIN,Calib.bkcolor);
    Screen(EXPWIN, 'Flip');
    
    calibration_result=tobiicalib.compute_and_apply();
    calibPlotData = calibration_result.CalibrationPoints;
    tobiicalib.leave_calibration_mode()
    
catch error
    disp( 'error')
    disp(error.message)
    disp(error.stack(1,1).name)
    disp(error.stack(1,1).line)
    calibPlotData = 0;
    
    
end

return



