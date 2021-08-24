function MyWarp(IMG2,U,V)

Usize = size(U,1);
scale = Usize/size(IMG2,1);

img2 = imresize(IMG2,scale);
[imh, imw] = size(img2);
[X, Y] = meshgrid(1:imh,1:imw);

intp_im1 = interp2(X,Y,img2,X+U,Y+V,'bicubic',0);
intp_im2 = interp2(X,Y,img2,X+U,Y+V,'bilinear',0);

abs_val = abs(img2 - intp_im1);
figure('Name','Absolute value of differences.');
imshow(abs_val,[0,1]);
disp('Press enter to continue.');
pause;
close all;

for i = 1:10    
    imshow(img2,[0,1]);
    imshow(intp_im1,[0,1]);
    drawnow;
end

close all;
end