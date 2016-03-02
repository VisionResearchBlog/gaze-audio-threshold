global EXPWIN GREY Calib
MONITOR=1; %set to zero for running exp
SKIP_SYNC=1; %Should be set to 0 when running exp, 1 for programming
DEBUG=0; %turn  to 1 if already have calibrated eye

eyetrackerhost = 'TX300-010102211502.local.' %brian's tracker
%eyetrackerhost = 'TX300-010105528621.local.' %ellie's tracker

Constants.FixThresh=30; %30*16.67=500ms @ 60hz samples Fixation Duration Movie Target
Constants.trialTime=4; %trial timeout - 4 seconds

Constants.ISI_RATE=0.5; %interstimulus interval maximum
Constants.ISI_MAX=3; %interstimulus interval maximum
Constants.ISI_MIN=0.5; %interstimulus interval minumum
Constants.ISI_INIT=Constants.ISI_RATE+Constants.ISI_MAX;

%For training trials only: TrialCorrect must be less or equal to
%TrialEval, if TrialCorrect equals TrialEval the subject must be 100%
%correct of the evaluation period
Constants.numTrialEval=6; %for training how many trials to evaluate over
Constants.numTrialCorrect=5; % what number correct are needed?

%for full experiment trials
Constants.MaximumPerformanceTrialNum=4; %how many trials at top before we stop trial
Constants.MinimumPerformanceTrialNum=6; %how many trials at bottom before we stop trial
Constants.MaxReversals=11; %how many reversals before stopping testing

Constants.TrainingTrials=1; %if it is training
Constants.AnimatedTrials=3; %how many trials at beginning need animated fixaiton point
Constants.animate_fix=1;

Constants.IncorrectTimeOut=1.5;
Constants.ShakeFixThresh=120; %when to start attention grabber 120frames = 2s
Constants.FixThreshFixationImage=18; %18*16.67=300ms
Constants.CalVolume=0.05; %18*16.67=300ms Volume on calibration sounds for infant
Constants.CalVideoLength=1.5; %specify desired duration for calibration video
%-----------------------------------------


ESC_PRESSED=0;

%--don't below alter unless you have good reason--
Constants.showGaze=1; %O=Nogaze pointer visible 1=gaze pointer visible


expdir=[pwd '\'];
PITCH_HUMAN=[expdir '\STIMULI\AUDIO\pitch human\'];
PITCH_ELEC=[expdir '\STIMULI\AUDIO\pitch elec\'];
RHYTHM_ELEC=[expdir '\STIMULI\AUDIO\rhythm elec\'];
RHYTHM_HUMAN=[expdir '\STIMULI\AUDIO\rhythm human\'];


VOLUME=[expdir '\STIMULI\AUDIO\volume\'];

REWARD_DIRECTORY=[expdir '\STIMULI\VISUAL\rewards\'];
%Rwd_Img1='cauldron.tif'; Rwd_Img2='coins.tif';
%Rwd_Img1='jelly bean jar.tif'; Rwd_Img2='jelly beans.tif';
Rwd_Img1='star box.tif'; Rwd_Img2='star.tif';


ALIEN_DIRECTORY=[expdir '\STIMULI\VISUAL\Aliens\'];
DINO_DIRECTORY=[expdir '\STIMULI\VISUAL\Dinos\'];
SNAIL_DIRECTORY=[expdir '\STIMULI\VISUAL\Snails\'];
COMBO_DIRECTORY=[expdir '\STIMULI\VISUAL\Combined\'];

Constants.calpoint_dir=[expdir '\InfantCalibration\'];
Constants.calpoint_size=50;

Constants.HiLeft_LoRight=1;
Constants.HiRight_LoLeft=2;

Constants.gColor=[255 150 0 255]; %gaze cursor colour
%---------
Constants.fpXY=120; %fixation image XY size in pixels
Constants.sXY=[300 240]; %movie stimulus size
GREY=[220 220 220]; 


%we use convention that locations of left & right have 0 & 1 assigned
Constants.LEFT=0; Constants.RIGHT=1;
Constants.LOW=0; Constants.HIGH=1;

Calib = SetCalibParams(MONITOR, SKIP_SYNC); %Variable indicates monitor
