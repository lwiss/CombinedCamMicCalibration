% for i=1:25
%     I=imread(['Image' num2str(i) '.jpg']);
%     Igray=rgb2gray(I);
%     [M,N]= size(Igray);
%     X=reflection(Igray,N);
%     imwrite(X,['Image' num2str(i) '.tif']);
%     
% end 

for i=1:3
    I=imread(['Frame' num2str(i) '.jpg']);
    Igray=rgb2gray(I);
    [M,N]= size(Igray);
    X=reflection(Igray,N);
    imwrite(X,['Frame' num2str(i) '.tif']);
    
end 