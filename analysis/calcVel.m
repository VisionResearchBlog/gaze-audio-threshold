function vel=calcVel(t,x,y)

%assuming samples are recorded with no deviations from a standard interval
sampleinterval=(t(end)-t(1))./length(x); % in seconds
d_del=sqrt( (x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2 );

%the tracker runs faster than the screen
%t_del=t(2:end)-t(1:end-1);

vel=d_del./sampleinterval;

end