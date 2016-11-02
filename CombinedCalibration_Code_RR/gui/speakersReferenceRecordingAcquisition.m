function rec=speakersReferenceRecordingAcquisition(calibSound,T,Fs,frameSize,inChanMap,outChanMap,handles)
% Synchronization phase (see with robin if to leave it or not)
%startingIndex=M_AUDIO_DELAY;
% startingIndex=M_AUDIO_DELAY; % this is the delay introduced by the Maudio 
% % we padd the signal with some zeros 
% calibSound=[0.9*calibSound; zeros(T*Fs,1)];
% plot(calibSound); 

set(handles.instructionMsg1,'String',...
       ['Speaker ' num2str(outChanMap) 'is active'] );
set(handles.instructionMsg2,'String','Wait until the end of the recording');
calibSound=[0.9*calibSound; zeros(T*Fs,1)];

% the recorded sounds are put together into a matrix speakersReferenceRecording 
% speakersReferenceRecording is a MxN matrix 
%                           where M=T*Fs  (length of the audio recording in seconds)
%                           and   N=nSpeakers

        
        %UNCOMMENT THIS CODE TO ENABLE DSP DEVICE
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
%        y=y(startingIndex:startingIndex+T*Fs-1); % because we know that the reference calibration sound lasts only T seconds
       % update the matrix   
       
       %release objects
       %UNCOMMENT THIS CODE TO ENABLE DSP DEVICE
       release(signal);
       release(microphone);
       release(speaker);  
    pause(1);
    rec=y(1:T*Fs);%outChanMap*ones(T*Fs,1);
    plot(linspace(0,T,T*Fs),rec,'r');
    xlabel 't(sec)'; ylabel 'recording';

       
end

