function calibSound= generateCalibrationSound(val, T, Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 switch val;
    case 1 % generates a maximum length sequences
       calibSound = mlseqGenerator(T,Fs);
    case 2 % generates a chirp signal
       f1=10000;f0=5000;
       ft=f0+(f1-f0)*(0:T*Fs-1)/(T*Fs);
       calibSound = sin(2*pi*ft.*(0:T*Fs-1)/Fs);
    end
end

