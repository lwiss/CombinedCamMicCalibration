% this script is a helper to perform the acquisition of a reference recording 
% for each speaker.

% clean the workspace 
clear all;
close all;
clc;

% load the necessary variables 

% Script params
nSpeakers = 6; % number of speakers 
frameSize = 1024; % parameter of the dsp library (for the M-audio device)
T = 2; % length of the recordings in seconds
dirpath = '../data/referenceRecordings/'; %path to the directory that wil store the reference recordings





inChanMap = 1; % chanel mapping for the microphones (which channels are used)
outChanMap = 1; % which speaker is used

% load the calibration signal: 
% the calibration sound has already been generated and stored to the data
% directory using mlseqGenerator.m 


[calibSound,Fs] = audioread([dirpath '/calibSound_96000Fs.wav']);%audioread([dirpath '/calibSound_44100Fs.wav']);

if Fs==96000
    filename = 'sp_referenceRecordings96' ;
    load 'MaudioDelay96.mat';
else 
    filename = 'sp_referenceRecordings44' ;
    load 'MaudioDelay44.mat';
end

% Synchronization phase 

startingIndex=M_AUDIO_DELAY; % this is the delay introduced by the Maudio 
% we padd the signal with some zeros 
calibSound=[0.9*calibSound; zeros(T*Fs,1)];
plot(calibSound); 

%% Play and record from speakers

% the recorded sounds are put together into a matrix speakersReferenceRecording 
% speakersReferenceRecording is a MxN matrix 
%                           where M=T*Fs  (length of the audio recording in seconds)
%                           and   N=nSpeakers

M=T*Fs;
N=nSpeakers;
speakersReferenceRecording=zeros(M,N);

fprintf('Starting... \n');
fprintf ('fix the microphone at a distance of 2 mm from the first speaker\n');
input('press Enter when you are ready to continue\n','s');

for j=1:nSpeakers
        fprintf('Speaker %d\n',j); 
        outChanMap=j;
        signal= dsp.SignalSource(calibSound, frameSize);
        [ microphone , speaker ] = setupMAudioDev( inChanMap, outChanMap, Fs, frameSize );
        y=[];
        while (~isDone(signal))
            noisyaudio = step(signal);
            step(speaker, noisyaudio );
            recAudioFrame = step(microphone);
            y=[y; recAudioFrame];
        end

       % remove the delay introduced by the AD(the M audio device) converter
       y=y(startingIndex:startingIndex+T*Fs-1); % because we know that the reference calibration sound lasts only T seconds
       % update the matrix   
       speakersReferenceRecording(:,j) = y;
       %release objects
       release(signal);
       release(microphone);
       release(speaker); 
       figure 
       pause(1); 
       plot(y,'r');
       if j<nSpeakers
           fprintf ('fix the microphone at a distance of 2 mm from the speaker %d\n',j+1);
           input('press Enter when you are ready to continue\n','s');
       end
end
save([dirpath filename],'speakersReferenceRecording');
fprintf('Reference recordings of the speakers are stored at %s \n', dirpath);
