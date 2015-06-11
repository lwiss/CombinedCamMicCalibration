clear all; close all; clc
load('primary_calibration_data');
load('Delta');
load('soundSrcCoorCam');
load('Calib_Results');
load('groundTruth');
c=343100;% mm/s

dist1=Delta(1,:)*c;
dist2=Delta(2,:)*c;
dist3=Delta(3,:)*c;
d1= bsxfun(@minus, soundSrcCoorCam, groundTruth(:,1));
d2= bsxfun(@minus, soundSrcCoorCam, groundTruth(:,2));
d3= bsxfun(@minus, soundSrcCoorCam, groundTruth(:,3));
d1=sqrt(sum(d1.^2));
d2=sqrt(sum(d2.^2));
d3=sqrt(sum(d3.^2));
figure;
hold on ;
plot(d1-dist1);
plot(d2-dist2);
plot(d3-dist3);

effectiveSrc=[];
for i=1:length(d1)
    if abs(d1(i)-dist1(i))>3.5 |  abs(d2(i)-dist2(i))>3.5 | abs(d3(i)-dist3(i))>3.5
        %dont take this Src
    else 
        effectiveSrc=[effectiveSrc i];
    end   
end

effectiveSources=soundSrcCoorCam(:,effectiveSrc);%zeros(3,length(effectiveSrc));


mydistances=c*Delta'; % in mm
%%
micCoordCam=zeros(3,nMics);
for i=1:nMics
    micCoordCam(:,i)=trilaterate_beck(effectiveSources',mydistances(effectiveSrc,i))%(soundSrcCoorCam',mydistances(:,i));
end

save('micCoordCam','micCoordCam');
figure ;
% plotting the coordinates of the microphones
plot3([0 30],[0 0],[0 0],'b',[0 0],[0 30],[0 0],'b',[0 0],[0 0],[0 -30],'b','LineWidth',3); hold on;
scatter3(soundSrcCoorCam(1,:),soundSrcCoorCam(3,:),-soundSrcCoorCam(2,:),'r','filled');
title 'Sound sources coordinates in the camera coordinates system'
xlabel 'Xcam'; ylabel 'Zcam'; zlabel 'Ycam';
%hold on;
%scatter3(micCoordCam(1,:),micCoordCam(3,:),-micCoordCam(2,:),'r','filled','LineWidth',4);
