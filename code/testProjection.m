load 'soundSrcCoorCam.mat'

i=3;
nSpeakers=6;
active_images=zeros(1,20);
active_images(i)=1;

scatter3(soundSrcCoorCam(1,(i-1)*nSpeakers+1:i*nSpeakers),...
    soundSrcCoorCam(3,(i-1)*nSpeakers+1:i*nSpeakers),...
    -soundSrcCoorCam(2,(i-1)*nSpeakers+1:i*nSpeakers),'filled');
hold on ;