
ScreenTime=[];

fn=randi(length(VidDirList));

if( strcmp(VidDirList(fn).name(1),'s') )
	fname='snail';
elseif( strcmp(VidDirList(fn).name(1),'d') )
	fname='dino';
elseif( strcmp(VidDirList(fn).name(1),'a') )
	fname='alien';
end

%fname='house' % overwrite as we are using a new icon - uncomment if using
%COMBO and want neutral house stimuli
%loads fixation image
myimgfile=[fname '_fixation.png'];
[imdata,~,alpha] =imread([Constants.imagedir myimgfile]);
imdata(:,:,4)=alpha;
blockTex=Screen('MakeTexture', EXPWIN, imdata);
bRect=Screen('Rect', blockTex);

myimgfile=[fname '_RIGHT.tif'];
imdata = imread([Constants.imagedir myimgfile]);
blockTex_RIGHT=Screen('MakeTexture', EXPWIN, imdata);
bRect_RIGHT=Screen('Rect', blockTex);

myimgfile=[fname '_LEFT.tif'];
imdata =imread([Constants.imagedir myimgfile]);
blockTex_LEFT=Screen('MakeTexture', EXPWIN, imdata);
bRect_LEFT=Screen('Rect', blockTex);


%we have nothing on screen, so flip again to have an interval to get initial
%eye tracking data
ScreenTime(end+1)=Screen(EXPWIN,'Flip');

Screen('FillRect',EXPWIN,GREY);
Screen('DrawTexture', EXPWIN, blockTex, bRect, FixationSquare);

%display fixation point
ScreenTime(end+1)=Screen(EXPWIN,'Flip');

%audio won´t begin until fixationfor constant.fixThresh
FixateToBegin

AudioPlayTime=PsychPortAudio('Start', pahandle, [], 0, 1);

s = PsychPortAudio('GetStatus', pahandle);

Screen('FillRect',EXPWIN,GREY);
Screen('DrawTexture', EXPWIN, blockTex, bRect, FixationSquare);
ScreenTime(end+1)=Screen(EXPWIN,'Flip');

while (s.Active) % wait for press
	s = PsychPortAudio('GetStatus', pahandle);
	%disp('wait for end of sound')
	Screen('FillRect',EXPWIN,GREY);
	Screen('DrawTexture', EXPWIN, blockTex, bRect, FixationSquare);
	
	if(Constants.showGaze & Constants.UseEyeTracker)
		drawGazeCursor
	end
	ScreenTime(end+1)=Screen(EXPWIN,'Flip');
end

%SETUP & RESET FLAGS for individual trials
finished=0;

if(Constants.UseEyeTracker)
	%flush eye buffer before starting new recordings
	tetio_readGazeData;
end

t1=GetSecs; %use last flip instead?
EyeInsideLR=[];
left_xy=[]; right_xy=[]; left_pupil=[];
right_pupil=[]; left_validity=[]; right_validity=[];

%start tally for trial correct/incorrect
trialScore(trial)=0; %assume incorrect & alter with later info

%begin choice portion where we monitor gaze location for % correct
EyeTime=[]; AllEyeData=[];

