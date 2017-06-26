clear all

for z=1:10000
    notyet=1;
    idx=0;
    while notyet
        idx=idx+1;
        a=randi([0 1],6,1);
        if(sum(a)>4)
            notyet=0;
        end
    end
    
    idxlist(z)=idx;
end

[N,BIN]=histc(idxlist,0:50);
perc=N./sum(N);
for z=1:length(N)

    cump(z)=sum(perc(1:z));

end
figure(1); clf; hold on
plot(1:50,cump(2:end)*100,'*-')
xlabel('Trial # (Each trial draws a set of 6)')
ylabel('Cumulative Probality that at least 5 are correct')

%compute directly using knowledge of system
actualprob=1-(1- (7/64) ).^(1:50);
plot(1:50,actualprob*100)
legend('Simulation','Direct Calculation')
ylim([0 100])