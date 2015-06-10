% script that computes a closed form solution for the microphones
% coordinatesusing a SVD decomposition (See paper raykar icassp 2004 )

load('Delta');
load('soundSrcCoorCam');
nSpeakers=6;
nMics=4;
nPos=25;
N=nPos*nSpeakers;
A=zeros(N*(N-1)/2,3);
b=zeros(N*(N-1)/2,1);
nextIndex=1;
c=340.6;
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

