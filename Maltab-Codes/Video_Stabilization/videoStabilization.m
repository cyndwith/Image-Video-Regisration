clear all;clc;close all;
inputFile = 'video Stabilization Database/shaky_car/shaky_car.avi';
outputFile = 'video Stabilization Database/shaky_car/outputImg/';
%function[]=video_stabilization_4_1(filename)
    filename = inputFile;
    video = VideoReader(filename);
    count=floor(video.FrameRate*video.Duration);
    noFrames = count;
    v=zeros(video.Height,video.Width,3,count);
    u=zeros(video.Height,video.Width,3,count);
    count=0;
    while hasFrame(video)
        count=count+1;
        v(:,:,:,count)=readFrame(video);
    end
    v=uint8(v);
    ImSize = size(v);
    Tcumm=eye(3);
    noFrames = count;
    windowSize = 60;
    transformationAcc = [0 0 0];
    trajectory = zeros([3 noFrames]);
    smooth_trajectory = zeros([3 noFrames]); 
    %temp_trajectory = zeros([3 noFrames]); 
    transformation = zeros([3 noFrames]);
    trajectory(:,1) = zeros([3 1]);
    smooth_trajectory(:,1) = zeros([3 1]);
    %temp_trajectory(:,1) = zeros([3 1]);
    transformation(:,1) = zeros([3 1]);
    
    
    %Temp1 = zeros(3);
    for i=2:noFrames
        A=v(:,:,:,i-1);
        AStart=v(:,:,:,1);
        B=v(:,:,:,i);
    
        Apoints=detectFASTFeatures(rgb2gray(A),'MinContrast',0.1);
        Bpoints=detectFASTFeatures(rgb2gray(B),'MinContrast',0.1);
    
        [Afeatures,Apoints]=extractFeatures(rgb2gray(A),Apoints);
        [Bfeatures,Bpoints]=extractFeatures(rgb2gray(B),Bpoints);
    
        matchPairs= matchFeatures(Afeatures, Bfeatures);
        Apoints=Apoints(matchPairs(:,1),:);
        Bpoints=Bpoints(matchPairs(:,2),:);
    
        % figure; showMatchedFeatures(A,B,Apoints,Bpoints);
        
        %Trans=estimateGeometricTransform(Bpoints,Apoints,'affine');
        Trans=estimateGeometricTransform(Bpoints,Apoints,'affine');
        temp=Trans.T;
        Temp1(:,:,i) = cvexTformToSRT(temp);
        transformation(1,i) = Temp1(3,1,i);
        transformation(2,i) = Temp1(3,2,i);
        if (Temp1(2,1,i)~=0 || Temp1(1,1,i)~=0)
            transformation(3,i) = atan(double(Temp1(2,1,i))/double(Temp1(1,1,i)));
        else
            transformation(3,i) = 0;
        end
        x(i) = transformation(1,i);
        y(i) = transformation(2,i);
        a(i) = transformation(3,i);
        transformationAcc=[x(i)+ transformationAcc(1); y(i)+ transformationAcc(2);a(i)+ transformationAcc(3)];
        %avgTemp1(3,1) = newX(i);
        %avgTemp1(3,2) = newY(i);
        trajectory(1,i) = trajectory(1,i) + transformation(1,i);
        trajectory(2,i) = trajectory(2,i) + transformation(2,i);
        trajectory(3,i) = trajectory(3,i) + transformation(3,i);
        Tcumm=Tcumm*Temp1(:,:,i); 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %for i = 1:numel(T)
            [xlim, ylim] = outputLimits(Trans, [1 ImSize(2)], [1 ImSize(1)]);
        %end

        % Find the minimum and maximum output limits
        xMin = min([1; xlim(:)]);
        xMax = max([ImSize(2); xlim(:)]);

        yMin = min([1; ylim(:)]);
        yMax = max([ImSize(1); ylim(:)]);

        % Width and height of panorama.
        width  = round(xMax - xMin);
        height = round(yMax - yMin);

        xLimits = [xMin xMax];  
        yLimits = [yMin yMax];

        %outputView = imref2d([height width],xLimits,yLimits);
        outputView=imref2d(size(B));
        %%%%%%%%%%%%%%%% Smoothing trajectory %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        count = 0;
        temp_trajectory = zeros([3 1]);
        for k = -windowSize:1:-1
            j = i+k;
            if j >= 1
                j
                temp_trajectory(1) = temp_trajectory(1) + transformation(1,j);
                temp_trajectory(2) = temp_trajectory(2) + transformation(2,j);
                temp_trajectory(3) = temp_trajectory(3) + transformation(3,j);
                count=count+1;
            end
        end
        count
        smooth_trajectory(:,i) = temp_trajectory./count;
        
        newTrajectory = transformation(:,i)+smooth_trajectory(:,i)-trajectory(:,i);
        
        %newTrajectory = transformation(:,i)+smooth_trajectory(:,i)-transformationAcc;
        newT = consTransform(newTrajectory);
        newX(i) = newT(3,1);
        newY(i) = newT(3,2);
        BTrans= imwarp(B,affine2d(newT),'OutputView',outputView);
        %BTrans = imresize(BTrans,[video.Height,video.Width]);
        u(:,:,:,i)= BTrans;%autoCrop(BTrans);%.*uint8(maskIm));
    end
    figure;
    vidOBJ = VideoWriter([outputFile '/stabilized.avi'],'Uncompressed AVI');
    open(vidOBJ);
    for i=1:noFrames
        i
        %subplot(1,2,1);imshow(uint8(v(:,:,:,i)));
        %subplot(1,2,2);imshow(uint8(u(:,:,:,i)));
        %figure(2);imshow(wFrame.cdata);
        %wFrame = getframe;
        %wFrame = imresize(wFrame.cdata,[video.Height video.Width]);
        %wFrame = imresize(uint8(u(:,:,:,i)),[video.Height video.Width]);
        wFrame = imresize([uint8(v(:,:,:,i)) uint8(u(:,:,:,i)) ],[video.Height video.Width]);
        writeVideo(vidOBJ,wFrame);
        drawnow;
    end
    close(vidOBJ);
    figure(2);
    subplot(1,2,1);
    plot(trajectory(1,:));hold on;
    plot(smooth_trajectory(1,:));hold on;
    legend('Trajectory - X','smooth_Trajectory - X');
    subplot(1,2,2);
    plot(trajectory(2,:));hold on;
    plot(smooth_trajectory(2,:));
    legend('Trajectory - Y','smooth_Trajectory - Y');
    figure(3);
    subplot(1,2,1);plot(newX);hold on;
    subplot(1,2,2);plot(newY);legend('newX','newY');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



