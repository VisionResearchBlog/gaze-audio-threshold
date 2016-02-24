PerfCode=0; % performance code to tell us why the final test was ended

if(length(StepStimulus)>Constants.MaximumPerformanceTrialNum)
    
    %are we at top level of difficulty
    if(sum(StepStimulus(end-(Constants.MaximumPerformanceTrialNum-1):end)))/Constants.MaximumPerformanceTrialNum == length(rng)
        %are we 100% correct
        if(sum(trialScore(end-(Constants.MaximumPerformanceTrialNum-1):end))==...
                Constants.MaximumPerformanceTrialNum)
            PerfCode=1; %max
            training=0;
            disp('Maxed out performance, exiting')
        end
    end
    
end

if(length(StepStimulus)>Constants.MinimumPerformanceTrialNum)
    if( sum(~trialScore(end-(Constants.MinimumPerformanceTrialNum-1):end))==...
            Constants.MinimumPerformanceTrialNum ) %min performance
        training=0;
        PerfCode=2; %min
        disp('Lowest level of performance, exiting')
    end
end


%findReversal
StepDerivative=StepStimulus(2:end)-StepStimulus(1:end-1);
ReversalCount=[];
%reversal counts as change in performance direction
% use trialScore to make sure 

ReversalStart=0;
for ii = 1:length(StepDerivative)
    %reversal can be up or down (+1 or -1 in StepDerivative) but can't
    %multiple in a row so need to look at the context
    if(StepDerivative(ii)~=0 && ~ReversalStart)
        ReversalTrial=ii;
        ReversalStart=1;
        %ReversalCount=ReversalCount+1; counting this makes the first
        %improvement or decrement a direction change (which is debatable)
    elseif(ReversalStart && StepDerivative(ii)~=0)
        %evaluate if it is in the same or opposite direction
        %if same we don't do anything
        if(StepDerivative(ii)~=StepDerivative(ReversalTrial))
            ReversalTrial=ii;
            ReversalCount(ii)=1;
        end
    elseif( trialScore(ii)==0 && StepStimulus(ii)==1 && ii>3)
        %not improved & at lowest thresh & not at beginning of trial
        ReversalCount(ii)=1;
    end
end

ReversalCount=sum(ReversalCount);

% plot(StepStimulus,'*-'); hold on;
% plot(ReversalCount-.1,'*-')
% plot(trialScore+.1,'*-')
% legend('Step','Reversal','Correct')

if(ReversalCount >= Constants.MaxReversals)
    training=0;
    PerfCode=3; %reversals
    disp('Maximum reversals met, exiting')
end

