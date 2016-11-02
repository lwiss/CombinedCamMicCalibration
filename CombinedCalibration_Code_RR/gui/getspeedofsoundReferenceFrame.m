cam=webcam('Logitech Camera');
I=snapshot(cam);
Igray=rgb2gray(I);
figure;
imshow(Igray);
imwrite(Igray,'speedofsoundRefImage.tif');