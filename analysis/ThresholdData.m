clear all
current_dir=pwd;
data_dir=[current_dir(1:end-8) 'data/'];
file_list=dir([data_dir '*FullExp*']);

%If you have one file to view & don't want to run each file in the data directory, 
%comment out line #4 and uncomment #8 and then enter the name like this:
%file_list.name='c4_rhyhumandino.6170.8393.FullExp.data.mat'

for j=1:length(file_list)
    load([data_dir file_list(j).name])
    disp(file_list(j).name)
    %generates plots 1-3, figure 2, trial by trial eye data
    viz=0; %should we do trial by trial plot? or just move on
    plotEyeData
    
    figure(4); clf;
    subplot(3,1,1); hold on;
    title(file_list(j).name)
    plot(StepStimulus,'-*')
    xlabel('Trial #')
    ylabel('Stimulus Step Size')
    text(1,9.5,'Most Difficult')
    text(1,1.5,'Least Difficult')
    xlim([1 length(TrialData) ])
    
    subplot(3,1,2)
    plot(trialScore,'-*')
    xlabel('Trial #')
    ylabel('Participant Response')
    text(1,.95,'Correct')
    text(1,0.05,'Incorrect')
    xlim([1 length(TrialData) ])
    
    subplot(3,1,3); hold on
    plot(RT(:,3),'-*')
    xlabel('Trial #')
    ylabel('Saccade Latency (s)')
    xlim([1 length(TrialData) ])
    %plot(RT2(:,3))
    %legend('Audio Start','Trial Start')
    
    if(j==length(file_list))
        disp('Last participant...done')
    else
        h=input('Press Return to plot next...');
    end
    
end