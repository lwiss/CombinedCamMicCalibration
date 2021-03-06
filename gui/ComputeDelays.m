function Delta = ComputeDelays( nIm,nSp,nM,Fs,referenceSound )
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


N=nIm*nSp;
Delta = zeros(nM,N); 

for p=1:nIm
   filename =['calib_sounds_pos' num2str(p)];
   load(filename);
   for i=1:nSp
        for j=1:nM
            a=computeDelay2Signals(measurements(i,:,j),referenceSound',Fs);%m-audio delay+ TOF delay 
            b=computeDelay2Signals(measurements(i,:,nM+1),referenceSound',Fs)%m-audio delay
            Delta(j,i+nSp*(p-1))=(a-b)/Fs;
        end
    end 
end

end

