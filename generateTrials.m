function [AudioStimList,correctList]=generateTrials(Constants)

%make equal number of trials and then shuffle
a=zeros(ceil(Constants.numTrialEval/2),1);
b=ones(floor(Constants.numTrialEval/2),1);

%we assume 0=lo & 1=hi
AudioStimList=Shuffle([a; b]);

%make a trial list for checking correct choices
for q=1:length(AudioStimList)
    if(Constants.StimulusAssignment==Constants.HiLeft_LoRight)
        
        if(AudioStimList(q)==0) % lo
            %correct is to go right
            correctList(q)=Constants.RIGHT;
        elseif(AudioStimList(q)==1) %hi
            %correct is to go right
            correctList(q)=Constants.LEFT;
        end
        
    elseif(Constants.StimulusAssignment==Constants.HiRight_LoLeft)
        if(AudioStimList(q)==0) % lo
            %correct is to go right
            correctList(q)=Constants.LEFT;
        elseif(AudioStimList(q)==1) %hi
            %correct is to go right
            correctList(q)=Constants.RIGHT;
        end
        
    end
end

return
