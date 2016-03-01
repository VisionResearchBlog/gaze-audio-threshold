clear all; clc;
savename=input('Please type Subject ID - then press enter: ','s');
LoadConstants;

%---- Edit Here to select audio stimuli -----
Constants.audiodir=PITCH_HUMAN;
%Constants.audiodir=RHYTHM_ELEC;
%Constants.audiodir=RHYTHM_HUMAN;
%Constants.audiodir=VOLUME;
%Constants.audiodir=PITCH_ELEC;

%---- Edit Here to select movies &  fixation image ----
%Constants.imagedir=ALIEN_DIRECTORY; Constants.fixpoint_img='alien';
%Constants.imagedir=DINO_DIRECTORY; Constants.fixpoint_img='dino';
Constants.imagedir=SNAIL_DIRECTORY; Constants.fixpoint_img='snail';
%Constants.imagedir=COMBO_DIRECTORY; %Constants.fixpoint_img='snail';

%--- For Training part Part 3 & Full Exp this must be defined ---
Constants.StimulusAssignment=Constants.HiLeft_LoRight;
%Constants.StimulusAssignment=Constants.HiRight_LoLeft;

%--For the full Experiment--

%Constants.AudioStimulusHeldConstant=Constants.LOW;
Constants.AudioStimulusHeldConstant=Constants.HIGH; % for PITCH - it MUST be this one - HIGH held constant so that the difficult trials are at the end and not at the start.

%load movie to keep attention
%attnObj=VideoReader([pwd '\STIMULI\VISUAL\' 'Pocoyo 3x00 El Show de Pocoyo.mov']);
%%%----------- Edit Here to select which part of experiment you want to run

HideCursor

%%%---Training Parts 1A----- Part one alternates Left & Right
Constants.numTrialEval=3; %for training how many trials to evaluate over
Constants.numTrialCorrect=3; % what number correct are needed?

Constants.LRvisible=0; %1=left, 2=right (the target is visible)
Constants.TrainHiLo=1; %1=Hi, 2=Low
Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train1A.data.mat'];
RunExpTest_Training

%%%---Training Parts 1B-----
if(~ESC_PRESSED)
    DEBUG=1; %stops racker from recalibrating between conditions
    Constants.TrainHiLo=2; % 1=Hi, 2=Low
    Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train1B.data.mat'];
    RunExpTest_Training
end

if(~ESC_PRESSED)
    %%%---Training Parts 1C----- Now we don't use animation
    Constants.TrainHiLo=1; %1=Hi, 2=Low
    Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train1C.data.mat'];
    RunExpTest_Training
end

%%%---Training Parts 1D-----
if(~ESC_PRESSED)
    Constants.TrainHiLo=2; % 1=Hi, 2=Low
    Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train2.data.mat'];
    RunExpTest_Training
end

if(~ESC_PRESSED)
    %%%---Training Parts 3-----
    Constants.TrainHiLo=3; %0=normal, 1=Hi, 2=Low, 3=Hi&Lo
    Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train3.data.mat'];
    Constants.numTrialEval=6; %for training how Smany trials to evaluate over
    Constants.numTrialCorrect=5; % what number correct are needed?
    RunExpTest_Training
end

if(~ESC_PRESSED)
    %%%---- FULL EXPERIMENT ----
    Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.FullExp.data.mat'];
    Constants.TrainingTrials=0; %no training
    RunExpTest_FullExperiment
end


ShowCursor
%clean up
sca;
clear all;









