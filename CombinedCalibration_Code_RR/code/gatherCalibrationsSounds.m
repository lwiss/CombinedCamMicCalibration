% this script is a helper to perform the aquization of data needed for the calibration
% the data is recorded sounds of sound sources.
clear all;
close all;
clc;

% load the necessary variables 



%% Script params
nPositions=25; % number of positions corresponds to the number of photo needed for the calibration of the camera 
nSpeakers=6; % number of speakers 
nMics=4; % number of microphones

dirpath='../data/hyp02/calibrationSounds/';


frameSize=1024;
T = 2; %seconds
inChanMap=[1 2 3 4]; % chanel mapping for the microphones (which channels are used) 
                       % the last channel is reserved for the microphone that will be used 
                       % for the speed of sound calculations
outChanMap=1; % which speaker is used

speedofsoundOK=0; % says whether we are taking measurement for speed of sound calculation or not (1->yes,0->no)

%load the mlseq signal used for calibration 
[calibSound,Fs] = audioread('../data/referenceRecordings/calibSound_44100Fs.wav');

if Fs==96000
    filename='calibSounds96_pos';
    load 'MaudioDelay96.mat';
else 
    filename='calibSounds44_pos';
    load 'MaudioDelay44.mat';
end

calibSound=[0.9*calibSound; zeros(T*Fs,1)];
plot(calibSound); hold on 

startingIndex=M_AUDIO_DELAY;

measurements=zeros(nSpeakers,T*Fs,nMics); % the matrix that will contain the measurement for each position

%% Run the experiments
for i=10:nPositions
    %TODO run the fction responsible for taking the camera image and store
    %it in the corresponding directory
    
    
    % for each image emit a sound from each of the speakers
    fprintf('Experiment n°%d\n',i);
    for j=1:nSpeakers
        outChanMap=j;
        fprintf('\tSpeaker %d\n',j); 
        signal= dsp.SignalSource(calibSound, frameSize);
        [ microphones , speaker ] = setupMAudioDev( inChanMap, outChanMap, Fs, frameSize );
        y=[];
        while (~isDone(signal))
            noisyaudio = step(signal);
            step(speaker, noisyaudio );

            recAudioFrame = step(microphones);
            y=[y; recAudioFrame];
        end
       % remove the delay introduced by the AD(the M audio device) converter
       y=y(startingIndex:startingIndex+T*Fs-1,:);
 
       
       %release objects
       release(signal);
       release(microphones);
       release(speaker); 
       % store the sounds in the directory corresponding to the hypothesis
        

       measurements(j,:,:)=y; %each column is the recorded sound at the corresponding mic
       
       pause(1); 
       if j<nSpeakers
            input('press any key to continue with the next speaker\n','s');
       end
    end
    
    fprintf('End of experiment  %d\n',i);
    fprintf('Storing measurements of experiment %d\n',i);
    save([dirpath filename num2str(i)],'measurements');
    if i<nPositions
    input('Change the position/orientation of the calibration rig then press any key to continue  \n', 's');
    end
end