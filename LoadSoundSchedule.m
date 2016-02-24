function [pahandle, buffer]=LoadSoundSchedule(wavfilenames,audiodir)
% BasicSoundScheduleDemo([wavfilenames])
%
% This demo shows two things:
%
% - How to use audio schedules in PsychPortAudio to preprogram a sequence
% of different sounds to play and how to dynamically add new sounds to the
% schedule while it is playing. This is similar to "playlists" in typical
% audio player applications like iTunes or the iPod etc.
%
% - How to create and use many prefilled audio buffers before start of a
% session. This way you can preload all needed sounds before start of an
% experiment into memory, in a format optimized for fast playback and low
% memory usage. This is similar to the concept of textures or offscreen
% windows in the domain of Screen() for the visuals.
%
% 
%
% Optional arguments:
%
% wavfilenames = Name of a .wav sound file to load and play back, or a cell
% array with multiple filenames to load. Otherwise the default sound files
% provided with Psychtoolbox will be loaded.
%
% The demo first loads all soundfiles, and resamples them to identical
% samplingrate if possible. Then it plays the first second of each of them.
% Then it goes into an interactive mode: By pressing any of the F1 - F10
% keys or any letter key, you can select a specific file for playback. By
% pressing any other key you exit the interactive loop. After the
% interactive loop has finished, a subset of the soundfiles is played again
% with a different method, for about 3 repetitions. Then the demo exits.
%

% History:
% 04/09/2009  mk Written.

% Running on PTB-3? Abort otherwise.

% Filenames provided?
if nargin < 1
    wavfilenames = [];
end

nfiles = length(wavfilenames);

% Always init to 2 channels, for the sake of simplicity:
nrchannels = 2;

% Does a function for resampling exist?
if exist('resample') %#ok<EXIST>
    % Yes: Select a target sampling rate of 44100 Hz, resample if
    % neccessary:
    freq = 44100;
    doresample = 1;
else
    % No. We will choose the frequency of the wav file with the highest
    % frequency for actual playback. Wav files with deviating frequencies
    % will play too fast or too slow, b'cause we can't resample:
    % Init freq:
    freq = 0;
    doresample = 0;
end

% Perform basic initialization of the sound driver:
InitializePsychSound(1);

% Read all sound files and create & fill one dynamic audiobuffer for
% each read soundfile:
buffer = [];
j = 0;

for i=1:nfiles
    try
        % Make sure we don't abort if we encounter an unreadable sound
        % file. This is achieved by the try-catch clauses...
        [audiodata, infreq] = audioread([audiodir wavfilenames{i}]);
        dontskip = 1;
    catch
        fprintf('Failed to read and add file %s. Skipped.\n', wavfilenames{i});
        dontskip = 0;
        psychlasterror
        psychlasterror('reset');
    end

    if dontskip
        j = j + 1;

        if doresample
            % Resampling supported. Check if needed:
            if infreq ~= freq
                % Need to resample this to target frequency 'freq':
                fprintf('Resampling from %i Hz to %i Hz... ', infreq, freq);
              %  keyboard
                %audiodata = resample(audiodata, freq, infreq);
            end
        else
            % Resampling not supported by Matlab/Octave version:
            % Adapt final playout frequency to maximum frequency found, and
            % hope that all files match...
            freq = max(infreq, freq);
        end

        [samplecount, ninchannels] = size(audiodata);
        audiodata = repmat(transpose(audiodata), nrchannels / ninchannels, 1);

        buffer(end+1) = PsychPortAudio('CreateBuffer', [], audiodata); %#ok<AGROW>
        [fpath, fname] = fileparts(char(wavfilenames(j)));
        fprintf('Filling audiobuffer handle %i with soundfile %s ...\n', buffer(j), fname);
    end
end

% Recompute number of available sounds:
nfiles = length(buffer);


InitializePsychSound(1)

% Open the default audio device [], with default mode [] (==Only playback),
% and a required latencyclass of 1 == standard low-latency mode, as well as
% a playback frequency of 'freq' and 'nrchannels' sound output channels.
% This returns a handle 'pahandle' to the audio device:
%pahandle = PsychPortAudio('Open', [], [], 1, freq, nrchannels);
pahandle = PsychPortAudio('Open', [], 1, 3, freq, nrchannels);

% For the fun of demoing this as well, we switch PsychPortAudio to runMode
% 1, instead of the default runMode 0. This will slightly increase the cpu
% load and general system load, but provide better timing and even lower
% sound onset latencies under certain conditions. It is not really needed
% in this demo, just here to grab your attention for this feature. Type
% PsychPortAudio RunMode? for more details...
runMode = 1;
PsychPortAudio('RunMode', pahandle, runMode);

% Enable use of sound schedules: We create a schedule of default size,
% currently 128 slots by default. From now on, the driver will not play
% back the sounds stored via PsychPortAudio('FillBuffer') anymore. Instead
% you'll have to define a "playlist" or schedule via subsequent calls to
% PsychPortAudio('AddToSchedule'). Then the driver will process that
% schedule by playing all defined sounds in the schedule, one after each
% other, until the end of the schedule is reached. You can add new items to
% the schedule while the schedule is already playing.

% PsychPortAudio('UseSchedule', pahandle, 1);
% PsychPortAudio('AddToSchedule', pahandle, buffer(2), 1);
% PsychPortAudio('Start', pahandle, [], 0, 1);
% keyboard

return;
