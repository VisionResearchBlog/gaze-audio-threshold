clear all; clc;
warning off MATLAB:subscripting:noSubscriptsSpecified
savename=input('Please type Subject ID - then press enter: ','s');
LoadConstants;

%---- Edit Here to select audio stimuli -----
%Constants.audiodir=PITCH_HUMAN;
%Constants.audiodir=RHYTHM_ELEC;
%Constants.audiodir=RHYTHM_HUMAN;
%Constants.audiodir=VOLUME;
Constants.audiodir=PITCH_ELEC;

%---- Edit Here to select movies &  fixation image ----
%Constants.imagedir=ALIEN_DIRECTORY; Constants.fixpoint_img='alien';
Constants.imagedir=DINO_DIRECTORY; Constants.fixpoint_img='dino';
%Constants.imagedir=SNAIL_DIRECTORY; Constants.fixpoint_img='snail';
%Constants.imagedir=COMBO_DIRECTORY; %Constants.fixpoint_img='snail';

%--- For Training part Part 3 & Full Exp this must be defined ---
%Constants.StimulusAssignment=Constants.HiLeft_LoRight;
Constants.StimulusAssignment=Constants.HiRight_LoLeft;

%--For the full Experiment--
Constants.AudioStimulusHeldConstant=Constants.LOW;
%Constants.AudioStimulusHeldConstant=Constants.HIGH; % for PITCH - it MUST be this one - HIGH held constant so that the difficult trials are at the end and not at the start.

%load movie to keep attention
dirtmp=dir([pwd '\STIMULI\VISUAL\']);
for z=1:length(dirtmp)
    if(strcmp(dirtmp(z).name,AttentionMovieFile))
        attentionMovieFlag=1;
    else
        attentionMovieFlag=0;
    end
end

if(attentionMovieFlag)
    disp('Loading Attention Keeper Video')
    attnObj=VideoReader([pwd '\STIMULI\VISUAL\' AttentionMovieFile]);
else
    disp('Attention Keeper NOT loaded - Check filename & path')
    attnObj=[];
end
%%%----------- Edit Here to select which part of experiment you want to run

if(Constants.UseEyeTracker)
    HideCursor
end

%%%---Training Parts 1A----- Part one alternates Left & Right
Constants.numTrialEval=2; %for training how many trials to evaluate over
Constants.numTrialCorrect=2; % what number correct are needed?

Constants.LRvisible=0; %1=left, 2=right (the target is visible)
Constants.TrainHiLo=1; %1=Hi, 2=Low
Constants.savefile=[expdir 'data/' savename '.' num2str(GetSecs) '.Train1A.data.mat'];
disp('Start Training 1A')
RunExpTest_Training

%%%---Training Parts 1A-----
if(~ESC_PRESSED)
    DEBUG=1; %stops racker from recalibrating between conditions
    Constants.TrainHiLo=2; % 1=Hi, 2=Low
    Constants.savefile=[expdir 'data/' savename '.' num2str(GetSecs) '.Train1B.data.mat'];
    disp('Start Training 1B')
    RunExpTest_Training
end

if(~ESC_PRESSED)
    %%%---Training Parts 1B-----
    Constants.TrainHiLo=1; %1=Hi, 2=Low
    Constants.savefile=[expdir 'data/' savename '.' num2str(GetSecs) '.Train1C.data.mat'];
    disp('Start Training 1C')
    RunExpTest_Training
end

%%%---Training Parts 1C-----
if(~ESC_PRESSED)
    Constants.TrainHiLo=2; % 1=Hi, 2=Low
    Constants.savefile=[expdir 'data/' savename '.' num2str(GetSecs) '.Train2.data.mat'];
    disp('Start Training 1D')
    RunExpTest_Training
end

if(~ESC_PRESSED)
    %%%---Training Parts 2-----Now we don't use animation
    Constants.TrainingTrials=0;
    Constants.TrainHiLo=3; %0=normal, 1=Hi, 2=Low, 3=Hi&Lo
    Constants.savefile=[expdir 'data/' savename '.' num2str(GetSecs) '.Train3.data.mat'];
    Constants.numTrialEval=6; %for training how Smany trials to evaluate over
    Constants.numTrialCorrect=5; % what number correct are needed?
    disp('Start Training 2')
    RunExpTest_Training
end

if(~ESC_PRESSED)
    %%%---- FULL EXPERIMENT ----
    Constants.savefile=[expdir 'data/' savename '.' num2str(GetSecs) '.FullExp.data.mat'];
    %no training
    RunExpTest_FullExperiment
end


ShowCursor
%clean up
sca;
clear all;



disp('Testing Complete: All data stored in /data/ use files in /analysis/ to process - SummaryScores.m and ThresholdData.m')





