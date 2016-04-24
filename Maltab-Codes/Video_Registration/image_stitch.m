function [ para ] = image_stitch(Im1,Im2)
    
    temp=zeros(size(Im1));
    para=zeros(size(Im1));
    Im1=double(Im1);
    Im2=double(Im2);
    para(find(Im1~=0))= Im1(find(Im1~=0));
    para(find(Im2~=0 & Im1==0))= Im2(find(Im2~=0 & Im1==0));
    
%     para(find(Im1~=0 & Im2~=0))=0.8*Im1(find(Im1~=0 & Im2~=0))+0.2*Im2(find(Im1~=0 & Im2~=0));
end

