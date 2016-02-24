FlushEvents;

[~,~,keyCode,~] = KbCheck;

if( find(keyCode)== 67 ) % 'C' key
    PsychPortAudio('Close');
    
    disp('RECALIBRATING!')
    Tobii_calibration_with_psychtoolbox;
    tetio_startTracking;
    mOrder = randperm(Calib.points.n);
    EyeErrorTestStart=TestEyeTrackerError(Calib,mOrder,Constants);
    
    InitializePsychSound(1);
    [pahandle, buffer]=LoadSoundSchedule(wavfilenames,Constants.audiodir);

    PsychPortAudio('UseSchedule', pahandle, 1);
    %we need to determine the appropriate sound to play for this trial
    if(Constants.TrainHiLo==3)
        PsychPortAudio('AddToSchedule', pahandle, buffer(AudioStimList(trial)+1), 1);
    else
        PsychPortAudio('AddToSchedule', pahandle, buffer(randi(length(wavfilenames))), 1);
    end

end

