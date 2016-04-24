function [para]=multiband_blend(im1,im2)

im1 = im2double(im1);
im2 = im2double(im2);
%grayIm1 = rgb2gray(im1);
maskIm = (im1);
maskIm(find(im1~=0)) = 1;
mp{1} = maskIm;
% figure;imshow(maskIm);
%M = floor(log2(max(size(im2))));
im1_size = size(im1);
M = floor(log2(max(im1_size)));
im1p{1} = im1;
im2p{1} = im2;

for n = 2 : M
    im1p{n} = imresize(im1p{n-1}, 0.5);
    im2p{n} = imresize(im2p{n-1}, 0.5);
    mp{n} = imresize(mp{n-1}, 0.5, 'bilinear');
end

for n = 1 : M-1
    im1p{n} = im1p{n} - imresize(im1p{n+1}, [size(im1p{n},1), size(im1p{n},2)]);
    im2p{n} = im2p{n} - imresize(im2p{n+1}, [size(im2p{n},1), size(im2p{n},2)]);
end

for n = 1 : M
    imp{n} = im1p{n} .* mp{n} + im2p{n} .* (1-mp{n});
end

para = imp{M};
for n = M-1 : -1 : 1
    para = imp{n} + imresize(para, [size(imp{n},1) size(imp{n},2)]);
    %imshow(para);drawnow;
end
para = uint8(para.*255);
% imshow(im);
end


