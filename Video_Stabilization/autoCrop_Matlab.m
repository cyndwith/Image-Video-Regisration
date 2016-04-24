function [imCROP] = autoCrop_Matlab(Im)
imBW = Im;
imBW(Im~=0) = 255;
imBW = im2bw(imBW);

[C H W] = FindLargestRectangles(imBW, [0 10 1]);
[tmp pos] = max(C(:));
[r c] = ind2sub(size(C), pos);
%rectangle('Position',[c,r,W(r,c),H(r,c)], 'EdgeColor','r', 'LineWidth',3);
imCROP = Im(r:r+H(r,c),c:c+W(r,c),:);

figure(3);imshow(imCROP);
