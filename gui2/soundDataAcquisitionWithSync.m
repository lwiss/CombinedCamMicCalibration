function rec=soundDataAcquisitionWithSync(calibSound,currentSp,T,Fs,frameSize,nMics,syncIn,syncOut)
% load the necessary variables
load('primary_calibration_data');
%% Script params

inChanMap=(1:nMics); % chanel mapping for the microphones (which channels are used) 
inChanMap=[inChanMap syncIn]; % we add the last channel for synchronization purposes 

outChanMap=currentSp; % which speaker is used
outChanMap=[outChanMap syncOut];% we add the last channel for synchronization purposes 

calibSound=[0.9*calibSound; zeros(T*Fs,1)];
calibSound=repmat(calibSound,1,2);


%% Run the experiments
        signal= dsp.SignalSource(calibSound, frameSize);
        [ microphones , speaker ] = setupMAudioDev( inChanMap, outChanMap, Fs, frameSize );
        y=[];
        while (~isDone(signal))
            noisyaudio = step(signal);
            step(speaker, noisyaudio );

            recAudioFrame = step(microphones);
            y=[y; recAudioFrame];
        end

  
       %release objects
       release(signal);
       release(microphones);
       release(speaker); 
       % store the sounds in the directory corresponding to the hypothesis
        
    
       rec=y(1:2*T*Fs,:);%currentSp*ones(T*Fs,nMics); %y;%each column is the recorded sound at the corresponding mic
       
       plot(y(:,1:3));

end