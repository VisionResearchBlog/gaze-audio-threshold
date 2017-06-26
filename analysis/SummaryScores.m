


% script to create a summary table of training and FullExperiment data from
% threshold experiment.
%
% ew 8/4/16


% first want to create (OR ADD TO?) a data file

% write a for loop that goes through every file in the folder
% dir('/Volumes/MATLAB2016/Threshold_Experiment/analysis/*.mat')

clear all % ERROR message - consider not using clear all within a script??

current_dir=pwd;

data_dir=[current_dir(1:end-8) 'data/'];
file_list = dir([data_dir '*.data.mat']);

%[file_list, pathname] = uigetfile('../data/*.mat', 'Pick a MAT file', 'MultiSelect', 'on');
%if isequal(file_list,0) || isequal(pathname,0)
%    disp('User pressed cancel')
%
%else
%    disp(['User selected some files'])
%end

File_List = [];

NCorrect =  zeros(length(file_list),1);
NTrials =  zeros(length(file_list),1);
highestLevel =  zeros(length(file_list),1);
MeanLevel =  zeros(length(file_list),1);
ReversalCounter =  zeros(length(file_list),1);

for k = 1:length(file_list)
    
    % want to write an if statement so that if the file name contains
    % 'Train1A' it lists the first 10 characters in first column, then
    % creates column 'Train1A_Ncorrect' then column 'Train1A_Ntotal'
    
    %check if a piece of string is contained in a longer string
    
    %  now if the string is contained, k is a number, otherwise it is empty
    %   check whether k is empty, if not then you can load the data for the
    %   'Train1A' condition...need to check for each condition you're
    %   interested in
    
    fileName{k} = file_list(k).name;
    load([data_dir fileName{k}]);
    
    NCorrect(k)=sum(trialScore);
    NTrials(k)=numel(trialScore);
    
    if strfind(fileName{k},'FullExp') >0;
        highestLevel(k) = max(StepStimulus);
        MeanLevel(k) = mean(StepStimulus);
        ReversalCounter(k) = ReversalCount;
    end

end

% pCorrectScores = 100* NCorrect ./ NTrials;
% figure
% bar(pCorrectScores)

%below - example of how to create that 'M' - the matrix - where you tell
%matlab what to actually include in the data.
% I THINK I NEED TO TRANSPOSE THESE.

M = {fileName' NCorrect  NTrials  highestLevel  MeanLevel  ReversalCounter};
dataTable=table(fileName', NCorrect,  NTrials,  highestLevel,  MeanLevel,  ReversalCounter)
writetable(dataTable,'ThresholdSummaryScores.csv' )

% this is putting everything in one long list................. NOT RIGHT!
% dlmwrite('ThresholdSummaryScores.exl', M)
