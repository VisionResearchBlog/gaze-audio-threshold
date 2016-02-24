function Escape=CheckEsc()
FlushEvents;
[~,~,keyCode,~] = KbCheck;
if( find(keyCode)== 27 )
    disp('EXITING EARLY! --- Escape Pressed......')
    Escape=1;
else
    Escape=0;
end

return
