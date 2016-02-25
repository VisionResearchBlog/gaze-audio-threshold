function result=medfilter1(x,n)

for i=1:length(x)
    xx(1,i)=x(i);
end

midpt=ceil(n/2);
sz=length(xx);

y=[];
for i=(midpt+1):sz
    if( (i+midpt)<=sz )
    y(end+1)=median(xx(i-midpt:i+midpt));
    end
end

result=[xx(1:(midpt)) y xx( (end-midpt+1):end )];


return