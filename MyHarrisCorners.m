function [row, col] = MyHarrisCorners(IMG)
[~, ~, imd ] = size(IMG);
if imd == 3
    IMG = double(rgb2gray(IMG))/255;    
end

SIGMA = 2;
k = 0.04;
g = fspecial('gaussian', 2*SIGMA*3+1, SIGMA);
dx = [-1 0 1; -1 0 1; -1 0 1];

Ix = imfilter(IMG, dx, 'symmetric', 'same');
Iy = imfilter(IMG, dx', 'symmetric', 'same');

Ix2 = imfilter(Ix.^2, g, 'symmetric', 'same');
Iy2 = imfilter(Iy.^2, g', 'symmetric', 'same');
Ixy = imfilter(Ix.*Iy, g, 'symmetric', 'same');

response = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Ixy).^2;
response = response > 0.002;
[row, col] = find(response);

end