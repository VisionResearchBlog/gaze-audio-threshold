

L_eye_pix_x=(EyeData(TrialNum).leye_xypv(:,1)*Calib.screen.width);
L_eye_pix_y=(EyeData(TrialNum).leye_xypv(:,2)*Calib.screen.height);
R_eye_pix_x=(EyeData(TrialNum).reye_xypv(:,1)*Calib.screen.width);
R_eye_pix_y=(EyeData(TrialNum).reye_xypv(:,2)*Calib.screen.height);

%calculate track lossers per eye
tloss_perc_LR(TrialNum,1)=sum(EyeData(TrialNum).leye_xypv(:,4)>2)./length(L_eye_pix_x);
tloss_perc_LR(TrialNum,2)=sum(EyeData(TrialNum).reye_xypv(:,4)>2)./length(R_eye_pix_x);


if(viz) % plot each individual trial?
    L_eye_pix_x=(EyeData(TrialNum).leye_xypv(:,1)*Calib.screen.width);
    L_eye_pix_y=(EyeData(TrialNum).leye_xypv(:,2)*Calib.screen.height);
    R_eye_pix_x=(EyeData(TrialNum).reye_xypv(:,1)*Calib.screen.width);
    R_eye_pix_y=(EyeData(TrialNum).reye_xypv(:,2)*Calib.screen.height);
    L_eye_v=EyeData(TrialNum).leye_xypv(:,4);
    R_eye_v=EyeData(TrialNum).reye_xypv(:,4);
    
    clear eyedat
    %step through and switch L,R, binoc depending on track signal
    for k=1:length(L_eye_pix_x)
        
        if( L_eye_v(k)<2 && R_eye_v(k)<2 )
            %use binocular
            eyedat(k,1)=(L_eye_pix_x(k) + R_eye_pix_x(k))/2;
            eyedat(k,2)=(L_eye_pix_y(k) + R_eye_pix_y(k))/2;
            
        elseif(R_eye_v(k)<2 && L_eye_v(k)>2 )
            %only trust right eye
            eyedat(k,:)=[R_eye_pix_x(k) R_eye_pix_y(k)];
            
        elseif(R_eye_v(k)>2 && L_eye_v(k)<2 )
            %only trust left eye
            eyedat(k,:)=[L_eye_pix_x(k) L_eye_pix_y(k)];
        else
            eyedat(k,:)=[-1 -1];
        end
        
    end
    
    L_filt_x= medfilter1(L_eye_pix_x,3);
    L_filt_y= medfilter1(L_eye_pix_y,3);
    R_filt_x= medfilter1(R_eye_pix_x,3);
    R_filt_y= medfilter1(R_eye_pix_y,3);
    
    Bi_x=medfilter1(eyedat(:,1),3);
    Bi_y=medfilter1(eyedat(:,2),3);
    
    
    L_Vel=calcVel(EyeData(TrialNum).time, L_eye_pix_x/Calib.screen.pixperdeg_xy(1),...
        L_eye_pix_y/Calib.screen.pixperdeg_xy(2));
    L_VelFilt=calcVel(EyeData(TrialNum).time, L_filt_x/Calib.screen.pixperdeg_xy(1),...
        L_filt_y/Calib.screen.pixperdeg_xy(2));
    
    R_Vel=calcVel(EyeData(TrialNum).time, R_eye_pix_x/Calib.screen.pixperdeg_xy(1),...
        R_eye_pix_y/Calib.screen.pixperdeg_xy(2));
    R_VelFilt=calcVel(EyeData(TrialNum).time, R_filt_x/Calib.screen.pixperdeg_xy(1),...
        R_filt_y/Calib.screen.pixperdeg_xy(2));
    
    Bi_VelFilt=calcVel(EyeData(TrialNum).time, Bi_x/Calib.screen.pixperdeg_xy(1),...
        Bi_y/Calib.screen.pixperdeg_xy(2));
    
    
    figure(2); clf;
    subplot(2,1,1); hold on
    plot(L_eye_pix_x)
    plot(R_eye_pix_x)
    plot(Bi_x)
    legend('lx','rx','bx')
    xlabel('Frames')
    ylabel('Horizontal Pixels')
    
    subplot(2,1,2); hold on
    plot(L_eye_pix_y)
    plot(R_eye_pix_y)
    plot(Bi_y)
    legend('ly','ry','by')
    xlabel('Frames')
    xlabel('Vertical Pixels')
    
end

%evaluate saccade latency form audio start
l=find(EyeData(TrialNum).AOI(:,1));
r=find(EyeData(TrialNum).AOI(:,2));
if(isempty(l));
    RT(TrialNum,1)=-99;
    RT2(TrialNum,2)=-99;
    
else
    RT(TrialNum,1)=EyeData(TrialNum).time(l(1))-...
        TrialData(TrialNum).AudioPlayTime;
    RT2(TrialNum,1)=EyeData(TrialNum).time(l(1))-...
        EyeData(TrialNum).time(1);
    
end

if(isempty(r));
    RT(TrialNum,2)=-99;
    RT2(TrialNum,2)=-99;
    
else
    RT(TrialNum,2)=EyeData(TrialNum).time(r(1))-...
        TrialData(TrialNum).AudioPlayTime;
    RT2(TrialNum,2)=EyeData(TrialNum).time(r(1))-...
        EyeData(TrialNum).time(1);
end



if(RT(TrialNum,1)>RT(TrialNum,2))
    RT(TrialNum,3)=RT(TrialNum,1);
    RT2(TrialNum,3)=RT2(TrialNum,1);
    
else
    
    RT(TrialNum,3)=RT(TrialNum,2);
    RT2(TrialNum,3)=RT2(TrialNum,2);
end

%keyboard
