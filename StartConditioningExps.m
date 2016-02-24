clear all; clc;
savename=input('Please type Subject ID - then press enter: ','s');
LoadConstants;

%---- Edit Here to select audio stimuli

%Constants.audiodir=PITCH_HUMAN;
%Constants.audiodir=RHYTHM_ELEC;
%Constants.audiodir=RHYTHM_HUMAN;
Constants.audiodir=VOLUME;
%Constants.audiodir=PITCH_ELEC;

%---- Edit Here to select movies &  fixation image
%Constants.imagedir=ALIEN_DIRECTORY; Constants.fixpoint_img='alien';
%Constants.imagedir=DINO_DIRECTORY; Constants.fixpoint_img='dino';
Constants.imagedir=SNAIL_DIRECTORY; Constants.fixpoint_img='snail';
%Constants.imagedir=COMBO_DIRECTORY; %Constants.fixpoint_img='snail';

%For Training part Part 3 & Full Exp this must be defined &
%Constants.StimulusAssignment=Constants.HiLeft_LoRight;
Constants.StimulusAssignment=Constants.HiRight_LoLeft;

%For the full Experiment

%Constants.AudioStimulusHeldConstant=Constants.LOW;
Constants.AudioStimulusHeldConstant=Constants.HIGH; % for PITCH - it MUST be this one - HIGH held constant so that the difficult trials are at the end and not at the start.

%load movie to keep attention
attnObj=VideoReader([pwd '\STIMULI\VISUAL\' 'Pocoyo 3x00 El Show de Pocoyo.mov']);


%----------- Edit Here to select which part of experiment you want to run




%---Training Parts 1-----
Constants.LRvisible=0; %1=left, 2=right (the target is visible)
Constants.TrainHiLo=1; %1=Hi, 2=Low
Constants.animate_fix=1;
Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train1.data.mat'];
RunExpTest_Training

if(~ESC_PRESSED)
% %---Training Parts 2-----
DEBUG=1; %stops racker from recalibrating between conditions
Constants.LRvisible=0; %1=left, 2=right (the target is visible)
Constants.TrainHiLo=2; % 1=Hi, 2=Low
Constants.animate_fix=1;
Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train2.data.mat'];
RunExpTest_Training
end

if(~ESC_PRESSED)
% %---Training Parts 3-----
Constants.LRvisible=0; %0=both, 1=left, 2=right
Constants.TrainHiLo=3; %0=normal, 1=Hi, 2=Low, 3=Hi&Lo
Constants.animate_fix=1;
Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.Train3.data.mat'];
RunExpTest_Training
end 
 
if(~ESC_PRESSED)
%---- FULL EXPERIMENT ----
Constants.savefile=[expdir 'data\' savename '.' num2str(GetSecs) '.FullExp.data.mat'];
Constants.LRvisible=0;
Constants.animate_fix=1;
RunExpTest_FullExperiment
end

%clean up
sca;
clear all;









