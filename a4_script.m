disp('################## CPS843 Assignment 4 ##################');
disp('## Name: Jeffrey Keith');
disp('## Student Number: 500804619');
disp('## Date: April 24th, 2021');
disp("###############Q1 Optical Flow Estimation###############");
clear;
%vars
low_in = 0;
high_in = 1;
win_dim = 5;
tau = 0.0001;

% Preprocess
synth1 = im2single(imread('Sequences/synth/synth_0.png'));
synth2 = im2single(imread('Sequences/synth/synth_1.png'));
synth1 = imadjust(synth1, [low_in high_in]);
synth2 = imadjust(synth2, [low_in high_in]);

sphere1 = im2single(imread('Sequences/sphere/sphere_0.png'));
sphere2 = im2single(imread('Sequences/sphere/sphere_1.png'));
sphere1 = im2gray(sphere1);
sphere2 = im2gray(sphere2);
sphere1 = imadjust(sphere1, [low_in high_in]);
sphere2 = imadjust(sphere2, [low_in high_in]);

corridor1 = im2single(imread('Sequences/corridor/bt_0.png'));
corridor2 = im2single(imread('Sequences/corridor/bt_1.png'));
corridor1 = imadjust(corridor1, [low_in high_in]);
corridor2 = imadjust(corridor2, [low_in high_in]);

%hotel sequence
imageDir = 'Hotel Sequence';
imList = dir(strcat(imageDir ,'/*.png'));
imSizes = size(imread(imList(1,1).name));
hSeq = zeros(imSizes(1),imSizes(2),51);
for iIm = 1:size(imList,1)
    hSeq(:,:,iIm) = im2single(imread(imList(iIm,1).name));
end



% %Processing
disp('(1.1) Calculating optical flow...');
[synth_u, synth_v, synth_x]= MyFlow(synth1,synth2,win_dim,tau);
synth_flow = cat(3,synth_u,synth_v);
[sphere_u, sphere_v, sphere_x] = MyFlow(sphere1,sphere2,win_dim,tau);
sphere_flow = cat(3,sphere_u,sphere_v);
[corridor_u, corridor_v, corridor_x] = MyFlow(corridor1,corridor2,win_dim,tau);
corridor_flow = cat(3,corridor_u,corridor_v);

disp('(1.2) Visualizing flow...');
synth_color = flowToColor(synth_flow);
sphere_color = flowToColor(sphere_flow );
corridor_color = flowToColor(corridor_flow);
f1 = figure('Name','Optical flow');
subplot(2,2,1)
imshow(synth_color, []);
title('Synth')
subplot(2,2,2)
imshow(sphere_color, []);
title('Sphere')
subplot(2,2,3)
imshow(corridor_color, []);
title('Corridor')
fprintf(['         Increasing the window size seems to increase the detail of the\n' ...
 '         optical flow.\n\n']);
fprintf('         Press enter to continue.');
pause;

close all;
disp('(1.3) Warping images...');
disp('Synth');
MyWarp(synth2, synth_u, synth_v)
disp('Sphere');
MyWarp(sphere2, sphere_u, sphere_v)
disp('Corridor');
MyWarp(corridor2, corridor_u, corridor_v)

% disp('(1.4) KLT Tracker')
% MyKLT(hSeq)

disp('End of script.')

