%plotEyeData
if(exist('EyeErrorTestEnd'))
    figure(1); clf; hold on;
    
    for w=1:size(EyeErrorTestEnd,2)
        %     subplot(1,2,1); hold on;
        %     a=zeros(length(EyeErrorTestStart(w).Left),1)+w;
        %     plot(a+0.1,EyeErrorTestStart(w).Left,'g*')
        %     plot(a,EyeErrorTestStart(w).Right,'b*')
        %     xlabel('Calibration Points'); ylabel('Degrees of Error')
        %     xlim([0 6])
        %     text(0.1,2, 'Start')
        %     plot( a+0.1, median(EyeErrorTestStart(w).Left),'k*')
        %     plot( a, median(EyeErrorTestStart(w).Right), 'k*')
        
        %    subplot(1,2,2); hold on;
        
        idx=EyeErrorTestEnd(w).Left_Validity<2;
        a=zeros(length(EyeErrorTestEnd(w).Left(idx)),1)+w;
        plot(a+0.1,EyeErrorTestEnd(w).Left(idx),'g*')
        scatter( a(1)+0.1, median(EyeErrorTestEnd(w).Left(idx)),75,'r','filled')
        
        idx=EyeErrorTestEnd(w).Right_Validity<2;        
        a=zeros(length(EyeErrorTestEnd(w).Right(idx)),1)+w;
        plot(a,EyeErrorTestEnd(w).Right(idx),'b*')
        scatter( a(1), median(EyeErrorTestEnd(w).Right(idx)),75, 'r','filled')
    end
    
    xlim([0 6])
    %ylim([0 10])
    xlabel('Calibration Points'); ylabel('Degrees of Error')
    legend('Left Eye','Median', 'Right Eye')
    %text(0.1,2, 'End')
    title(['Final Calibration Validation: ' file_list(j).name])
end

for TrialNum=1:length(trialScore)
    
    processEyeData;
    
    %keyboard
end

%to check eye tracking quality
figure(3); clf; hold on;
title(file_list(j).name)
edges=0:0.05:1;
[N,~] = histcounts(tloss_perc_LR(:,1),edges,'Normalization','probability');
bar(edges(2:end),N,.2,'FaceColor', [1 0 0]);
[N,~] = histcounts(tloss_perc_LR(:,2),edges,'Normalization','probability');
bar(edges(2:end)+.01,N,.2,'FaceColor', [0 0.6 0.6]);
xlabel('% Track Loss'); ylabel('Frequency');
legend('Left Eye', 'Right Eye')
xlim([0 1])
ylim([0 1])
clear N edges a w