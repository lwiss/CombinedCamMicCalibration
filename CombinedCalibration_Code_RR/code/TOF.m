function J = TOF( X_mic)
%TOF computes the time of flight between a sound source and a microphone 
%   X_mic: microphone coordinates in the camera coordinates system 
%    The function has access to the variable storing the sound source
%    coordinates in the camera coordinates system 
%   gamma 

    global soundSrcCoorCam;
    global Delta;
    global speedOfSound;
    global micIndex;
    
    [~,N]= size(soundSrcCoorCam);
    tof_theoretical = zeros(N,1);
    J = zeros(N,1);
    
    %%TODO : optimize this function (get rid of the for loop)
    for i=1:N
        tof_theoretical(i) = sqrt((X_mic(1)-soundSrcCoorCam(1,i))^2+...
                                (X_mic(2)-soundSrcCoorCam(2,i))^2+...
                                (X_mic(3)-soundSrcCoorCam(3,i))^2);
        tof_actual= speedOfSound*Delta(micIndex,i);
        
        J(i)=(tof_theoretical(i)-tof_actual)^2;
    end
    
end

