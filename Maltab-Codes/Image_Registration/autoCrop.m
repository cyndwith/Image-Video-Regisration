function [imCROP] = autoCrop(Im)
imBW = Im;
imBW(Im~=0) = 255;
%figure(1);imshow(Im);
imBW = im2bw(imBW);

row = floor(size(Im,1)/2);
col = floor(size(Im,2)/2);

imROW = imBW(row,:);
imCOL = imBW(:,col)';

valROW = find(imROW~=0);
valCOL = find(imCOL~=0);

minCOL = min(valROW);
maxCOL = max(valROW);
minROW = min(valCOL);
maxROW = max(valCOL);

imCROP = uint8(Im(minROW:maxROW,minCOL:maxCOL,:));

% imBW = Im;
% imBW(Im~=0) = 255;
% %figure(1);imshow(Im);
% imBW = im2bw(imBW);
% sizeROW = []; minCOL = [];maxCOL = [];
% for i = 1:1:size(Im,1)
%     imROW = imBW(i,:,:);
%     [row,col] = find(imROW~=0);
%     sizeROW = [sizeROW,nnz(imROW)];
%     minCOL = [minCOL;min(col)];
%     maxCOL = [maxCOL;max(col)];
% end
% lowCOL = max(minCOL);
% highCOL = min(maxCOL);
% rangeCOL = highCOL - lowCOL;
% imRange = find(sizeROW>=rangeCOL);
% minROW = min(imRange);
% maxROW = max(imRange);
% 
% imCROP = Im(minROW:maxROW,lowCOL:highCOL);
% flag =0;
% for i = 1:1:size(imBW,1)/2
%     i
%     for j = 1:1:size(imBW,2)/2
%         j
%         temp = Im(i:size(imBW,1)-i,j:size(imBW,2)-j);
%         if(nnz(temp)==0)
%             flag = 1
%             break;
%         end
%     end
%     if(flag == 1)
%         break;
%     end
% end
% 
% imCROP = temp;

%figure(2);imshow(imBW);
% [C H W] = FindLargestRectangles(imBW, [0 10 1]);
% [tmp pos] = max(C(:));
% [r c] = ind2sub(size(C), pos);
% rectangle('Position',[c,r,W(r,c),H(r,c)], 'EdgeColor','r', 'LineWidth',3);
% imCROP = Im(r:r+H(r,c),c:c+W(r,c),:);
%figure(3);imshow(imCROP);
%[C, H, W, M] = FindLargestRectangles(Im,1, minSize)
%[imROW,imCLR] = autoCorp(Im);
%[row,col] = find(nbp(:,1)==1);



