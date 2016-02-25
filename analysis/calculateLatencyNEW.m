%calculate several relevant latencies
%Saccade - Audio Stimulus onset
%Saccade - visual Stimulus onset
%Saccade - either Stimulus onset
%Saccade - Audio Stimulus offset
%Saccade - visual Stimulus offset
%Saccade - Go Signal

%--Original-- find the closest video frame where the audio started
[~,AudioFrame]=min(abs(Trial_ND_Data(TrialNum).time-Trial_1D_Data.PD_AudioStart(TrialNum)));
%find the closest video frame where the visual appeared
[~,VideoFrame]=min(abs(Trial_ND_Data(TrialNum).time-Trial_1D_Data.ChangeTimeFlip(TrialNum)));

if(VideoFrame<AudioFrame)
    tmp_frame=VideoFrame;
elseif(VideoFrame>AudioFrame)
    tmp_frame=AudioFrame;
end

%latency to look to left bottom quadrant
idx1=find(AOI(tmp_frame:end,3));
if(~isempty(idx1)); LookToLB(TrialNum)=idx1(1)-1; end

%latency to look to right bottom quadrant
idx2=find(AOI(tmp_frame:end,5));
if(~isempty(idx2)); LookToRB(TrialNum)=idx2(1)-1; end


b_vis=Trial_1D_Data.ChangeTimeFlip(TrialNum);
b_aud=Trial_1D_Data.PD_AudioStart(TrialNum);
e_aud=b_aud+0.7; %not sure when to say it ends...affe/schnecke
e_vis=b_vis+1; %1s duration
b_go=Trial_1D_Data.blockUnlockTime(TrialNum);


clear lat_tmp
%now we mark whether they look left or right first & when
if(LookToLB(TrialNum)<LookToRB(TrialNum))
    LookFirstQuadrant(TrialNum)=0;% left==0
    lat_tmp=Trial_ND_Data(TrialNum).time(tmp_frame+idx1(1));
elseif(LookToLB(TrialNum)>LookToRB(TrialNum))
    LookFirstQuadrant(TrialNum)=1;% right==1
    lat_tmp=Trial_ND_Data(TrialNum).time(tmp_frame+idx2(1));
else 
    %no looks at all?
end

if(exist('lat_tmp'))
    LatencyToLook_VIS_ON(TrialNum)=lat_tmp-b_vis;
    LatencyToLook_VIS_OFF(TrialNum)=lat_tmp-e_vis;

    LatencyToLook_AUD_ON(TrialNum)=lat_tmp-b_aud;
    LatencyToLook_AUD_OFF(TrialNum)=lat_tmp-e_aud;

    LatencyToLook_GO(TrialNum)=lat_tmp-b_go;
    
    time_seq(TrialNum,:)=[ b_vis b_aud e_vis e_aud b_go lat_tmp ];
end
