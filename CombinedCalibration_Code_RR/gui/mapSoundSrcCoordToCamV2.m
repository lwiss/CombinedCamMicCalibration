load('Calib_Results');
load('srcCoordinatesInRealWorld');
load('primary_calibration_data');


nEffectiveImages=sum(active_images);
nSrc=nEffectiveImages*nSpeakers;
soundSrcCoorCam= zeros(3,nSrc);
sourceCoorInRealWorld=sourceCoorInRealWorld';


% loop to compute the coordinate of the sound sources in the camera
% reference frame coordinates system
i=1;
for j=1:nImages
    if active_images(j)==1
        eval(['soundSrcCoorCam(:,(i-1)*nSpeakers+1:i*nSpeakers)=Rc_' num2str(j)...
            '*  sourceCoorInRealWorld + repmat(Tc_' num2str(j) ',1, nSpeakers);']);
        i=i+1;
    end
end
save('soundSrcCoorCam','soundSrcCoorCam');
plot3([0 150],[0 0],[0 0],'b',[0 0],[0 150],[0 0],'b',[0 0],[0 0],[0 -150],'b','LineWidth',2); hold on;
scatter3(soundSrcCoorCam(1,:),soundSrcCoorCam(3,:),-soundSrcCoorCam(2,:),'filled');
title 'Sound sources coordinates in the camera coordinates system'
xlabel 'Xcam'; ylabel 'Zcam'; zlabel 'Ycam';