if(viz)
    figure(201); clf;  hold on;
    %title('Eye & Mouse Data')
    set(gca,'FontSize',Fsz)
    
    if(0)
        plot( L_eye_pix_x, Calib.screen.height-L_eye_pix_y,'*r' )
        plot( R_eye_pix_x, Calib.screen.height-R_eye_pix_y,'*b' )
    end
    
    plot(Trial_ND_Data(TrialNum).mouse(:,1),...
        Calib.screen.height-Trial_ND_Data(TrialNum).mouse(:,2),'b', 'LineWidth',4)

    if(Constants.trackEyes)
        for xz=1:size(AOI,2)
            idx=find(AOI(:,xz));
            scatter( Bi_x(idx), Calib.screen.height-Bi_y(idx),100,colorList(xz,:),'o', 'filled' )
        end; clear xz
    end
    legend('Mouse','Binocular Eye Position')
    
    drawBox(q1,Calib,[.95 .95 .95],'-',3);
    drawBox(q2,Calib,[.95 .95 .95],'-',3);
    drawBox(Constants.centerBlock,Calib,[.7 .7 .7],'-',2);
    drawBox(Constants.SortAreaLocation(TrialNum,:,1),Calib,[0 0 0],'-',3);
    drawBox(Constants.SortAreaLocation(TrialNum,:,2),Calib,[0 0 0],'-',3);
    %drawBox(Constants.TrafficLight',Calib,[.9 .9 .9],'-',2);
    
    plot(Trial_ND_Data(TrialNum).mouse(:,1),...
        Calib.screen.height-Trial_ND_Data(TrialNum).mouse(:,2),'b', 'LineWidth',4)
    
    if(Constants.trackEyes)
        for xz=1:size(AOI,2)
            idx=find(AOI(:,xz));
            scatter( Bi_x(idx), Calib.screen.height-Bi_y(idx),100,colorList(xz,:),'o', 'filled' )
        end; clear xz
    end
    
    %plot all the data first
    %scatter( Bi_x, Calib.screen.height-Bi_y,55,[0.75 0.75 0],'o', 'filled' )
    
    %now plot with AOI labels
    
    xlim([0 Calib.screen.width]); ylim([0 Calib.screen.height]);
    
    set(gca,'XTickLabel', round( (get(gca,'XTick'))/Calib.screen.pixperdeg_xy(1) -...
        Calib.screen.width/Calib.screen.pixperdeg_xy(1)/2 ) )
    set(gca,'YTickLabel', round((get(gca,'YTick'))/Calib.screen.pixperdeg_xy(2) -... ) )
        Calib.screen.height/Calib.screen.pixperdeg_xy(2)/2 ) )
    xlabel('Horizontal Screen Position (Deg)')
    ylabel('Vertical Screen Position (Deg)')
    
%    keyboard
    %------------Figure 5 -----------------------
    
    
    
     
    if(1 && Constants.trackEyes)
        figure(202); clf; hold on;
        title(['Velocity - Median Filter, ' num2str(tloss_perc_LR(TrialNum,:))])
        plot(Trial_ND_Data(TrialNum).time(2:length(R_Vel)+1),R_VelFilt,'r');
        ylabel('Degrees/Sec'); xlabel('Time (s)')
        plot(Trial_ND_Data(TrialNum).time(2:length(L_Vel)+1),L_VelFilt);
        ylabel('Degrees/Sec'); xlabel('Time (s)')
        plot(Trial_ND_Data(TrialNum).time(2:length(Bi_VelFilt)+1),Bi_VelFilt,'k');
        ylabel('Degrees/Sec'); xlabel('Time (s)')
        legend('Left','Right','Binoc.')
        ylim([0 500])
        set(gca,'FontSize',Fsz)
    end
    
    if(Constants.trackEyes)
        figure(203); clf; hold on;
        for j=1:size(AOI,2)
            scatter( Trial_ND_Data(TrialNum).time(2:length(AOI)+1), ...
                ones(length(AOI),1).*AOI(:,j)*j,55,colorList(j,:),'filled')
        end
        
        yl=[0.5 size(AOI,2)+0.5];
    end
end



if(viz && Constants.trackEyes)
    if(~isempty(Trial_1D_Data.PD_AudioStart(TrialNum)))
        line([Trial_1D_Data.PD_AudioStart(TrialNum) Trial_1D_Data.PD_AudioStart(TrialNum)],...
            yl,'Color', [0 1 0]);
    end
    
    if(~isempty(Trial_1D_Data.ChangeTimeFlip(TrialNum)))
        line([Trial_1D_Data.ChangeTimeFlip(TrialNum) Trial_1D_Data.ChangeTimeFlip(TrialNum)],...
            yl,'Color', [1 0 0]);
        text(Trial_1D_Data.ChangeTimeFlip(TrialNum), 6,...
            'Visual On','FontSize',Fsz, 'BackgroundColor',[1 0.9 0.8])
    end
    
    if(~isempty(Trial_1D_Data.putDownTime(TrialNum)))
        line([Trial_1D_Data.putDownTime(TrialNum) Trial_1D_Data.putDownTime(TrialNum)],...
            yl,'Color', [.5 0 0]);
        text(Trial_1D_Data.putDownTime(TrialNum), 5.5,...
            'Put Down','FontSize',Fsz, 'BackgroundColor',[.5 0.9 0.8])
    end
    
    if(~isempty(Trial_1D_Data.blockUnlockTime(TrialNum)))
        line([Trial_1D_Data.blockUnlockTime(TrialNum) Trial_1D_Data.blockUnlockTime(TrialNum)],...
            yl,'Color', [.5 0 0]);
        text(Trial_1D_Data.blockUnlockTime(TrialNum), 5.5,...
            'Go Cue','FontSize',Fsz, 'BackgroundColor',[0 0.9 0.1])
    end
    
    
    ylim(yl)
    h = gca;
    h.YTick = 1:size(AOI,2);
    set(gca,'YTickLabel',AOI_labels)
    
    if(~isempty(Trial_1D_Data.PD_AudioStart(TrialNum)))
        text(Trial_1D_Data.PD_AudioStart(TrialNum),6.5, ...
            Trial_1D_Data.PD_Instruction(TrialNum),...
            'FontSize',Fsz, 'BackgroundColor',[1 0.9 0.5])
        %text(Trial_ND_Data(TrialNum).PD_AudioStart, yl(2)+0.1,...
        %    'PD Instruction','FontSize',8, 'BackgroundColor',[1 0.9 0.8])
    end
    
    %we start at midx(10) to avoid initial click to start trial
    midx=Trial_ND_Data(TrialNum).time(find(Trial_ND_Data(TrialNum).mouse(:,3)));
    if(length(midx)>=10)
        line([midx(10) midx(10)],yl,'Color', [0 0 0]);
        line([midx(end) midx(end)],yl,'Color', [0 0 0]);
        text(midx(10), 4.5, 'Picked Up','FontSize',Fsz, 'BackgroundColor',[1 0.9 0.8])
        if(~isempty(Trial_1D_Data.PD_AudioStart(TrialNum)))
            text(midx(end), 4.5, 'Sorted','FontSize',Fsz, 'BackgroundColor',[1 0.9 0.8])
        end
    end
    
    if(Constants.BLUELEFT)
        if(Constants.changeCatTypeList(TrialNum)==0)
            b=': Monkey - ';
        else
            b=': Snail - ';
        end
    else
        if(Constants.changeCatTypeList(TrialNum)==0)
            b=': Snail - ';
        else
            b=': Monkey - ';
        end
    end
    
    if(Constants.changeTimeTypeList(TrialNum)==1)
        a='Visual Before Audio';
    elseif(Constants.changeTimeTypeList(TrialNum)==2)
        a='Visual After Audio';
    elseif(Constants.changeTimeTypeList(TrialNum)==3)
        a='Visual & Audio Simultaneous';
    end
    
    if(Trial_1D_Data.SortedInto(TrialNum)==0)
        c=' Sort: None ';
    elseif(Trial_1D_Data.SortedInto(TrialNum)==1)
        c=' Sort: Left ';
    elseif(Trial_1D_Data.SortedInto(TrialNum)==2)
        c=' Sort: Right ';
    end
    
    if(Constants.conflictList(TrialNum))
        b2='CONFLICT: ';
    else
        b2='';
    end
    
    set(gca,'FontSize',Fsz)
    xlabel('Time (s)')
    title([a b b2 c ])
end