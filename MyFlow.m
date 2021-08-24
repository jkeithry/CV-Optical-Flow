function [U, V, X] = MyFlow(IM1,IM2,WIN_DIM,TAU)
%Vars
sigma = 2;
hsize = [3, 3];
h1 = fspecial('gaussian', hsize, sigma);
scale = 1;
%spatial derivatives filters
conv_filter = (1/12)*[-1 8 0 -8 1];
conv_filter = conv_filter(end:-1:1, end:-1:1);
% Preprocess
% Compute Temporal Derivative
im1 = imresize(IM1, scale);
im2 = imresize(IM2, scale);
[im_h,im_w]=size(im1);

%smooth images with 2d gauss
smoothed_im1 = imfilter(im1, h1);
smoothed_im2 =  imfilter(im2, h1);
It = smoothed_im1 - smoothed_im2;

% Compute Partials
im1_Dx = conv2(im1, conv_filter);
im1_Dy  = conv2(im1, conv_filter');
im2_Dx = conv2(im2, conv_filter);
im2_Dy  = conv2(im2, conv_filter');

%compute flow: average change
Ix = (im1_Dx + im2_Dx);
Iy = (im1_Dy + im2_Dy);

X = ones(im_h,im_w);
U = zeros(im_h,im_w);
V = zeros(im_h,im_w);

for i = WIN_DIM:im_h
    for j = WIN_DIM:im_w 
        
        A = zeros(2,2);
        b = zeros(2,1);
        for y = i-WIN_DIM+1:i
            for x = j-WIN_DIM+1:j
                Ix2 = Ix(y,x)*Ix(y,x);
                Iy2 = Iy(y,x)*Iy(y,x);
                Ixy = Ix(y,x)*Iy(y,x);
                Ixt = Ix(y,x)*It(y,x);
                Iyt = It(y,x)*Iy(y,x);
                A(1,1) = A(1,1) + Ix2;
                A(2,2) = A(2,2) + Iy2;
                A(1,2) = A(1,2) + Ixy;
                A(2,1) = A(2,1) + Ixy;
                b(1,1) = b(1,1) + Ixt;
                b(2,1) = b(2,1) + Iyt;
            end
        end

        e = eig(A);
        if min(e) < TAU
            X(i,j) = 0; 
        else
            least_sq = pinv(A)*(-1*b);
            U(i,j) = least_sq(1);
            V(i,j) = least_sq(2);
        end

    end
end

end