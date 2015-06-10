% script that computes a closed form solution for the microphones
% coordinatesusing a SVD decomposition (See paper raykar icassp 2004 )
load('primary_calibration_data');
load('Delta');
load('soundSrcCoorCam');
load('Calib_Results');
load('groundTruth');

N=sum(active_images)*nSpeakers;
A=zeros(N*(N-1)/2,3);
b=zeros(N*(N-1)/2,1);
nextIndex=1;
c=342000;% mm/s
%%
micCoordCam=zeros(3,nMics);
for i=1:nMics
    for j=1:N-1
       % Compute A and b 
       for k=i+1:N
          A(nextIndex-1+j,:) = (soundSrcCoorCam(:,k)-soundSrcCoorCam(:,j))';
          b(nextIndex-1+j)= ((c*Delta(i,j))^2- (c*Delta(i,k))^2 - ...
              norm(soundSrcCoorCam(:,j))^2 + norm(soundSrcCoorCam(:,k))^2 )/2;
       end
       
       
       %update the next starting index
       nextIndex=nextIndex+N-i;
    end
    nextIndex=1;
    sol= (A'*A)\(A'*b);
    micCoordCam(:,i)=sol;
end
 save('micCoordCam','micCoordCam');
plot3([0 25],[0 0],[0 0],'b',[0 0],[0 25],[0 0],'b',[0 0],[0 0],[0 -25],'b','LineWidth',2); hold on;
scatter3(soundSrcCoorCam(1,:),soundSrcCoorCam(3,:),-soundSrcCoorCam(2,:),'filled');
title 'Sound sources coordinates in the camera coordinates system'
xlabel 'Xcam'; ylabel 'Zcam'; zlabel 'Ycam';
hold on;
% plotting the coordinates of the microphones
scatter3(micCoordCam(1,:),micCoordCam(3,:),-micCoordCam(2,:),'c','filled');
scatter3(groundTruth(1,:),groundTruth(3,:),-groundTruth(2,:),'r*');
micCoordCam
%%
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


