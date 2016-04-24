clear;clc;clear all;
Im = imread('buildingPara.bmp');
%imCarving = seamcarving(imCROP,1000);
figure(1);imshow(Im);
figure(2);
imCROP = autoCrop(uint8(Im));
imshow(uint8(imCROP));
figure(3);
imCROP = autoCrop_Matlab(uint8(imCROP));
imshow(uint8(imCROP));
%figure(3);imshow(imCarving);
% imBW = Im;
% imBW(Im~=0) = 255;
% figure(1);imshow(Im);
% imBW = im2bw(imBW);
% row = floor(size(Im,1)/2);
% col = floor(size(Im,2)/2);
% 
% imROW = imBW(row,:);
% imCOL = imBW(:,col)';
% 
% valROW = find(imROW~=0);
% valCOL = find(imCOL~=0);
% 
% minCOL = min(valROW);
% maxCOL = max(valROW);
% minROW = min(valCOL);
% maxROW = max(valCOL);
% 
% 
% imCROP = Im(minROW:maxROW,minCOL:maxCOL,:);
% 
% figure(2);imshow(imCROP);


% imBW = Im;
% imBW(Im~=0) = 255;
% imBW = im2bw(imBW);
% flag =0;
% size(imBW,1)
% size(imBW,2)
% for i = 1:1: size(imBW,1)/2
%     for j = 1:1:size(imBW,2)/2
%         temp = Im(i:size(imBW,1)-i,j:size(imBW,2)-j);
%         if(nnz(temp==0)==0)
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

