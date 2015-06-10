function d = computeDelay2Signals(x ,s_ref,Fs )
%COMPUTEDELAY computes the delay,in seconds, between the signal x and a
% reference signal s_ref
%   x: the signal 
%   s_ref: the reference signal
%   Fs: the sampling rate of the signals 
%   d : delay in seconds between x and s_ref

d = delayest_iterative(x,s_ref); % delay in the subsample precision
% now we have to convert the delay into a time delay 
% d = d/Fs;
end

