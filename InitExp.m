Priority(1);
AssertOpenGL;
Screen('BlendFunction', EXPWIN, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%--------------CONSTANTS-------------
LoadConstants_EyeDependent;

Screen('TextStyle', EXPWIN, 1);
Screen('TextFont',EXPWIN, 'Arial');
Screen('TextSize',EXPWIN, 24);

%Constants.fixpoint_img
VidDirList=dir([Constants.imagedir Constants.fixpoint_img(1) '*.mp4']);
WavDirList=dir([Constants.audiodir '*.wav']);

%write wav names in string
for i=1:length(WavDirList)
    wavfilenames{i}=WavDirList(i).name;
end


if(Constants.LRvisible==0) %real trial
    choiceColors(:,1)=[ 120 20 220 255];
    choiceColors(:,2)=[ 120 20 220 255];
elseif(Constants.LRvisible==1) %only LEFT VISIBLE
    choiceColors(:,1)=[ 120 20 220 255];
    choiceColors(:,2)=[ GREY 255];
elseif(Constants.LRvisible==2) %only RIGHT visible
    choiceColors(:,1)=[ GREY 255];
    choiceColors(:,2)=[ 120 20 220 255];
end


FixationSquare=[Calib.screen.width/2-Constants.fpXY/2, ...
    (Calib.screen.height/2)-Constants.fpXY/2, ...
    Calib.screen.width/2+Constants.fpXY/2, ...
    (Calib.screen.height/2)+Constants.fpXY/2];

LeftChoiceSquare=[Calib.screen.width/4-Constants.sXY(1)/2, ...
    (Calib.screen.height/2)-Constants.sXY(2)/2, ...
    Calib.screen.width/4+Constants.sXY(1)/2, ...
    (Calib.screen.height/2)+Constants.sXY(2)/2];

RightChoiceSquare=[3*(Calib.screen.width/4)-Constants.sXY(1)/2, ...
    (Calib.screen.height/2)-Constants.sXY(2)/2, ...
    3*(Calib.screen.width/4)+Constants.sXY(1)/2,...
    (Calib.screen.height/2)+Constants.sXY(2)/2];



if(DEBUG)
    try
        tetio_stopTracking;
    end
    tetio_startTracking;
    
else
    Tobii_calibration_with_psychtoolbox;
    tetio_startTracking;
    mOrder = randperm(Calib.points.n);
    EyeErrorTestStart=TestEyeTrackerError(Calib,mOrder,Constants);
end



Incorrect_img='Incorrect';
myimgfile=[Incorrect_img '.png'];
[imdata,map,alpha] =imread([Constants.imagedir myimgfile]);
blockTex_Incorrect=Screen('MakeTexture', EXPWIN, imdata);
bRect_Incorrect=Screen('Rect', blockTex_Incorrect);



[imdata,map,alpha] =imread([REWARD_DIRECTORY Rwd_Img1]);
blockTex_RWD1=Screen('MakeTexture', EXPWIN, imdata);
bRect_RWD1=Screen('Rect', blockTex_Incorrect);
[imdata,map,alpha] =imread([REWARD_DIRECTORY Rwd_Img2]);
blockTex_RWD2=Screen('MakeTexture', EXPWIN, imdata);
bRect_RWD2=Screen('Rect', blockTex_Incorrect);


trial=0;

%always start at most different stim
StepStimulus=1;
TrialNumAtStep=0;
training=1;
