function InAOI = EyeInAOI_Median(rxy,lxy,Calib,rect,border)
%UL xy, BRxy  
%remember in this coordinate system y starts at 0 at top of screen
%add border

rect(1:2)=rect(1:2)-border;
rect(3:4)=rect(3:4)+border;

%size(rxy)
x=median(mean([rxy(:,1)  lxy(:,1)],2))*Calib.screen.width;
y=median(mean([rxy(:,2)  lxy(:,2)],2))*Calib.screen.height;
    
InAOI=IsInRect(x,y,rect);
return

