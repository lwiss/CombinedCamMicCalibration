load('Calib_Results');
load('srcCoordinatesInRealWorld');

nImages=25;
nSpeakers=6;
nSrc=nImages*nSpeakers;
soundSrcCoorCam= zeros(3,nSrc);
sourceCoorInRealWorld=sourceCoorInRealWorld';


% loop to compute the coordinate of the sound sources in the camera
% reference frame coordinates system

for i=1:nImages
    eval(['soundSrcCoorCam(:,(i-1)*nSpeakers+1:i*nSpeakers)=Rc_' num2str(i)...
        '*  sourceCoorInRealWorld + repmat(Tc_' num2str(i) ',1, nSpeakers);']);
end
save('soundSrcCoorCam','soundSrcCoorCam');
scatter3(soundSrcCoorCam(1,:),soundSrcCoorCam(3,:),-soundSrcCoorCam(2,:),'filled');