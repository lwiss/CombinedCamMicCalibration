close all;clear all;
load('micCoordCam.mat');
load('soundSrcCoorCam.mat')

figure ;
% plotting the coordinates of the microphones
%plot3([0 10],[0 0],[0 0],'b',[0 0],[0 10],[0 0],'b',[0 0],[0 0],[0 -10],'b','LineWidth',3); hold on;
hold on;
arrow3d([0 100],[0 0],[0 0],0.7,1,1,'red');
arrow3d([0 0],[0 100],[0 0],0.7,1,1,'red');
arrow3d([0 0],[0 0],[0 -100],0.7,1,1,'red');
%plot3(micCoordCam(1,:),micCoordCam(3,:),-micCoordCam(2,:),'--gs',...
plot3(soundSrcCoorCam(1,:),soundSrcCoorCam(3,:),-soundSrcCoorCam(2,:),'s',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
%title 'Microphones coordinates in the camera coordinates system'
title 'Sound sources coordinates in the camera coordinates system'
xlabel 'Xcam'; ylabel 'Zcam'; zlabel 'Ycam';
hold on;
%%
Origin=0.5*(micCoordCam(:,2)+micCoordCam(:,3));
scatter3(Origin(1),Origin(3),-Origin(2),'k','*','LineWidth',5);

e1=micCoordCam(:,2)-Origin; e1=(e1./norm(e1));
e2=[-e1(2);e1(1);e1(3)];e2=(e2./norm(e2));
e3=cross(e1,e2);e3=(e3./norm(e3));
arrow3d([Origin(1), Origin(1)+5*e1(1)],[Origin(3), Origin(3)+5*e1(3)],[-Origin(2), -Origin(2)-5*e1(2)],0.7,0.5,1,'blue');

arrow3d([Origin(1), Origin(1)+5*e2(1)],[Origin(3), Origin(3)+5*e2(3)],[-Origin(2), -Origin(2)-5*e2(2)],0.7,0.5,1,'blue');

arrow3d([Origin(1), Origin(1)+5*e3(1)],[Origin(3), Origin(3)+5*e3(3)],[-Origin(2), -Origin(2)-5*e3(2)],0.7,0.5,1,'blue');
plot3(groundTruth(1,:),groundTruth(3,:),-groundTruth(2,:),'rx',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
save('microphoneBasis','e1','e2','e3','Origin');

T=Origin;
R=[e1,e2,e3];
save('transformation','R','T');
mapXmic_toX_cam(micCoordCam(:,1),R,T)
