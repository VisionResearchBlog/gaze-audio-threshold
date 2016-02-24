FlushEvents;
[~,~,keyCode,~] = KbCheck;

if( find(keyCode)== 84 ) % press 'T' key to start pause

    DrawFormattedText(EXPWIN,'PAUSE','Center',Calib.screen.height/2, WHITE);
    Screen(EXPWIN,'Flip');
    while(1)
        FlushEvents;
        [~,~,keyCode,~] = KbCheck;
        if( find(keyCode)== 89 ) % press 'Y' key to stop pause
            break
        end
    end
end
