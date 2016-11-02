% This script estimates the delay introduced by the DSP device (the M-audio)
% The delay is then stored into a global variable called INTERNAL_DELAY 

clear all; close all;

load('primary_calibration_data');

N=T*Fs; % length of the signal to be used
frameSize=1024; % parameter used by the dsp library

% Channel mapping: the user must connect these two channels together
inChanMap = 1; % which input channel is used 
outChanMap = 1; % which output channel is used

% generate the synchronization signal: 
s = zeros(1,2*N); %create a signal that is 4 seconds long
s(1,1:N) = 0.9*calibSound(1:N); 
s=s';
figure
subplot(2,1,1);
plot(s); 
title 'pilot signal emitted from output channel' ;

fprintf('Starting internal delay estimation\n');
signal= dsp.SignalSource(s, frameSize);
[ microphone , speaker ] = setupMAudioDev( inChanMap, outChanMap, Fs, frameSize );
y=[];
while (~isDone(signal))
     noisyaudio = step(signal);
     step(speaker, noisyaudio );

     recAudioFrame = step(microphone);
     y=[y; recAudioFrame];
end

%release objects
disp 'Releasing objects';
release(signal);
release(microphone);
release(speaker); 

pause(1); 
subplot(2,1,2);
plot(y);
title 'pilot signal measured at the input channel';

INTERNAL_DELAY=computeDelay2Signals(y(1:2*N)',s',Fs);
fprintf( 'the internal delay introduced by the dsp device is MAUDIO_DELAY=%d samples\n',INTERNAL_DELAY);
disp 'storing the internal delay';
clickCounter=1;
save ('internalDelay','INTERNAL_DELAY','clickCounter');
