function rec=soundDataAcquisition(calibSound,currentSp,T,Fs,frameSize,nMics)
% load the necessary variables
load('primary_calibration_data');
%% Script params

inChanMap=(1:nMics); % chanel mapping for the microphones (which channels are used) 
                       % the last channel is reserved for the microphone that will be used 
                       % for the speed of sound calculations
outChanMap=currentSp; % which speaker is used

calibSound=[0.9*calibSound; zeros(T*Fs,1)];

rec=zeros(T*Fs,nMics); % the matrix that will contain the measurement for each position

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
       % remove the delay introduced by the AD(the M audio device) converter
       %y=y(startingIndex:startingIndex+T*Fs-1,:);
 
       
       %release objects
       release(signal);
       release(microphones);
       release(speaker); 
       % store the sounds in the directory corresponding to the hypothesis
        
    
       rec=y(1:T*Fs,:);%currentSp*ones(T*Fs,nMics); %y;%each column is the recorded sound at the corresponding mic
       
       plot(y);

end