function[]=video_stabilization_4_1(filename)
    video = VideoReader(filename);
    count=video.FrameRate*video.Duration;
    v=zeros(video.Height,video.Width,3,count);
    u=zeros(video.Height,video.Width,count);
    count=0;
    while hasFrame(video)
        count=count+1;
        v(:,:,:,count)=readFrame(video);
    end
    v=uint8(v);
    Tcumm=eye(3);
    for i=1:100
        A=v(:,:,1,i); B=v(:,:,1,i+1);
    
        Apoints=detectFASTFeatures(A,'MinContrast',0.1);
        Bpoints=detectFASTFeatures(B,'MinContrast',0.1);
    
        [Afeatures,Apoints]=extractFeatures(A,Apoints);
        [Bfeatures,Bpoints]=extractFeatures(B,Bpoints);
    
        matchPairs= matchFeatures(Afeatures, Bfeatures);
        Apoints=Apoints(matchPairs(:,1),:);
        Bpoints=Bpoints(matchPairs(:,2),:);
    
        % figure; showMatchedFeatures(A,B,Apoints,Bpoints);
    
        Trans=estimateGeometricTransform(Bpoints,Apoints,'affine');
        temp=Trans.T;
        Temp1 = cvexTformToSRT(temp);
        Tcumm=Tcumm*Temp1;
        outputView=imref2d(size(B));
        BTrans=imwarp(B,affine2d(Tcumm),'OutputView',outputView);
        u(:,:,i)=BTrans;
        % figure;showMatchedFeatures(A,BTrans,Apoints,BStabPoints);
    
    end
    figure;
    for i=1:100
        subplot(1,2,1);imshow(uint8(u(:,:,i)));
        subplot(1,2,2);imshow(uint8(v(:,:,1,i)));
        drawnow;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



