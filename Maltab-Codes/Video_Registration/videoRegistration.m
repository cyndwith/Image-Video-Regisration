function[]=videoRegistration(filename1, filename2,outputFile)

    video1 = VideoReader(filename1); video2=VideoReader(filename2);
    count1=floor(video1.FrameRate*video1.Duration);
    count2=floor(video2.FrameRate*video2.Duration);
    noFrames = min(count1,count2);
    t=cell(n,1);
    count1=0; count2=0;
    while hasFrame(video1)
        count1=count1+1;
        if count1>noFrames
            break;
        end
        count1
        A=readFrame(video1);
        B=readFrame(video2);
        temp=imageRegistration(A,B);
        t{count1}=uint8(temp);
        %t{count1}=(temp);
    end
    figure;
    v = VideoWriter([outputFile 'para.avi']);
    v2 = VideoWriter([outputFile 'para_crop.avi']);
    open(v);
    open(v2);
    for i=1:noFrames
        imshow(uint8(t{i}));
        vFrame = imresize(t{i},[480,640]);
        writeVideo(v,vFrame);
        vFrame = autoCrop(vFrame);
        vFrame = imresize(vFrame,[480,640]);
        writeVideo(v2,vFrame);
        drawnow;   
    end
    close(v);
    close(v2);
end
