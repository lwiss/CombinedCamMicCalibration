% MLE estimation of the microphones coordinates 
clear all; clc;

global soundSrcCoorCam;
global Delta;
%%
load 'primary_calibration_data'; 
load 'soundSrcCoorCam';
load 'Delta';
load 'micCoordCam';
%%
global speedOfSound;
global micIndex;
micIndex=1;
speedOfSound=340600;
% 1) Initialize Rm and omega_m to [0,0,0]

% 2) initialize microphone coordinates
    % now we will just initialize them at random // todo : Include the
    % closed form guess of the solution
disp('Initializing mics coordinates... ');
X_zero=micCoordCam;%(:,micIndex) %get the mic coordinates in the camera coordinates system
disp X_zero;
% 3) for each microphone in turn adjust X_m i.e find X_m that minimize to
% ofbjective function
X_mics_final=X_zero
epsilon=10^-2;


mylastNorm=0;
myNewNorm=0;
count_iter=0;
%%
while (1) 
    
    for micIndex=1:nMics
        
        fprintf('Adjusting coordinates of mic %d...\n',micIndex);
        %micCoordCam(:,micIndex); %get the mic coordinates in the camera coordinates system

        [X_hat,resnorm] = lsqnonlin(@TOF,X_mics_final(:,micIndex));

        myNewNorm = myNewNorm + resnorm;
        X_mics_final(:,micIndex) = X_hat;
    end 
    X_mics_final
    if abs(myNewNorm-mylastNorm)<epsilon
       fprintf('Iter %d J=%f...\n',count_iter,myNewNorm);
       disp 'No significant change in the objective function is recorded i.e.' ;
       disp 'Exit condition is reached' ;
       break;
    end
    mylastNorm=myNewNorm;
    fprintf('Iter %d J=%f...\n',count_iter,mylastNorm);
    myNewNorm=0;
    count_iter=count_iter +  1;
end 
% plot3([0 150],[0 0],[0 0],'b',[0 0],[0 150],[0 0],'b',[0 0],[0 0],[0 -150],'b','LineWidth',2); hold on;
% scatter3(soundSrcCoorCam(1,:),soundSrcCoorCam(3,:),-soundSrcCoorCam(2,:),'filled');
% title 'Sound sources coordinates in the camera coordinates system'
% xlabel 'Xcam'; ylabel 'Zcam'; zlabel 'Ycam';
% hold on;
hold on ;
scatter3(X_mics_final(1,:),X_mics_final(3,:),-X_mics_final(2,:),'k','filled');
%scatter3(micCoordCam(1,:),micCoordCam(3,:),-micCoordCam(2,:),'filled');
% 4) repeat 3 with smaller step sizes until an exit condition is reached (no change in the cost function)

% 5) adjust X_s  for each sound source in turn

% 6) adjust wighting of phi_ms to decrease the effect of sound sources
% which have the highest contribution to the cost function

% 7) repeat 3 to 6 with reducing step size until an exit condition is met
