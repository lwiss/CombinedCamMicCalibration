function Delta = ComputeDelays( nP,nS,M )
%COMPUTEDELAYS Summary of this function goes here
%   Delta:  M by N matrix, where N is the number of sound sources and M is
%   the number of microphones, delta[i,j]= delay between the signal emitted
%   by sound source j and recorded by microphone i
%   signalsPath: is the path to the directory storing the sound signals 
%   nP: number of diferent postions used for the calibration
%   nS: number of speakers 

% Note that the naming convension for the wav files is the following 
% pos{p}sp{i}mic{j} i denotes which speaker emitted the sound and j which
% mic has recorded the signal

% first we load the reference recoding of each speaker

load('sp_referenceRecordings44');
N=nP*nS;
Delta = zeros(M,N); 

for p=1:nP
   filename =['calibSounds44_pos' num2str(p)];
   load(filename);
   for i=1:nS
        for j=1:M
            Delta(j,i+nS*(p-1))=computeDelay2Signals(speakersReferenceRecording(:,i)',measurements(i,:,j),44100);
        end
    end 
end
save('Delta','Delta');
end

