function maxLenSeqWhiteNoise = mlseqGenerator( T, Fs )
%MLSEQGENERATOR generates a binary mlseq of length T seconds sampled at Fs 
%   T length in seconds of the mls sequence
%   Fs sampling frequency 

N=T*Fs;% total number of samples

power=ceil(log2(N+1));

maxLenSeqWhiteNoise = mseq(2,power,0,1);
maxLenSeqWhiteNoise = maxLenSeqWhiteNoise(1:N);

end

