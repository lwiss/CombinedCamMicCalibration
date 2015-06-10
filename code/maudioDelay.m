% This script estimates the delay introduced by the DSP device (the M-audio)
% The delay is then stored into a global variable called MAUDIO_DELAY 

clear all; close all;

load('primary_calibration_data');

N=T*Fs; % length of the signal to be used
frameSize=1024; % parameter used by the dsp library

% Channel mapping: the user must connect these two channels together
inChanMap = [1 2 3 4]; % which input channel is used 
outChanMap = [3 7]; % which output channel is used

% generate the synchronization signal: 
s = zeros(1,2*N); %create a signal that is 4 seconds long
s(1,1:N) = 0.9*calibSound(1:N); 
s=s';
figure
plot(s); 
title 'zero padded sound' ;

fprintf('Starting M-audio delay estimation\n');
% play and record
s=repmat(s,1,2);

%%
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
figure ;
subplot(4,1,1);
plot(y(:,1));
title 'mic1';
subplot(4,1,2);
plot(y(:,2));
title 'mic2';
subplot(4,1,3);
plot(y(:,3));
title 'mic3';
subplot(4,1,4);
plot(y(:,4));
title 'sync channel';


%%
disp 'Compute the delay';
a=computeDelay2Signals(0.5*y(1:4*Fs,1)',s(:,1)',Fs);
b=computeDelay2Signals(0.5*y(1:4*Fs,2)',s(:,1)',Fs);
c=computeDelay2Signals(0.5*y(1:4*Fs,3)',s(:,1)',Fs);
d=computeDelay2Signals(0.5*y(1:4*Fs,4)',s(:,1)',Fs);
distance1=(a-d)*(1/Fs)*340600;
distance2=(b-d)*(1/Fs)*340600;
distance3=(c-d)*(1/Fs)*340600;
%M_AUDIO_DELAY=round(computeDelay2Signals(0.5*y(1:length(s))',s',Fs));
%disp M_AUDIO_DELAY;
% save the variable into a .mat file so that it can be used later on. 
%%
v=343100;
spnum=4;
disp 'Compute the delay';
s=[calibSound;zeros(T*Fs,1)];
a=computeDelay2Signals(measurements(spnum,1:4*Fs,1),s',Fs);
b=computeDelay2Signals(measurements(spnum,1:4*Fs,2),s',Fs);
c=computeDelay2Signals(measurements(spnum,1:4*Fs,3),s',Fs);
d=computeDelay2Signals(measurements(spnum,1:4*Fs,4),s',Fs);
distance1=(a-d)*(1/Fs)*v;
distance2=(b-d)*(1/Fs)*v;
distance3=(c-d)*(1/Fs)*v;
