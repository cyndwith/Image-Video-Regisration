function [t]= imageRegistration(varargin)
    switch nargin
        case 1
            Scene = imageSet(varargin{1});
            n=Scene.Count;
            n
            Im = cell(n,1); Imc = cell(n,1);wIm=cell(n,1);
            for i=1:n
                
                Im{i} = rgb2gray(read(Scene, i));
                Imc{i}= read(Scene, i);
                
            end
        otherwise
            Im = cell(nargin,1);Imc = cell(nargin,1);wIm=cell(nargin,1);n=nargin;
            for i=1:nargin
                
                Im{i}=rgb2gray((varargin{i}));
                Imc{i}=(varargin{i});
            end     
    end

    ImSize = size(Im{1});
    points = detectSURFFeatures(Im{1});
    [features, points] = extractFeatures(Im{1},points);

    T(1) = projective2d(eye(3));

    for i = 2:n
    
        prevPoints = points;
        prevFeatures = features;
    
        points = detectSURFFeatures(Im{i});
        [features, points] = extractFeatures(Im{i},points);
    
        matchPairs = matchFeatures(features,prevFeatures,'Unique',true,'MatchThreshold',1);
    
        currMatchPoints = points(matchPairs(:,1),:);
        prevMatchPoints = prevPoints(matchPairs(:,2),:);
        %figure;showMatchedFeatures(Im{i-1},Im{i},prevMatchPoints,currMatchPoints,'montage');
        T(i)= estimateGeometricTransform(currMatchPoints, prevMatchPoints,'projective','Confidence',99.9,'MaxNumTrials',2000);
        T(i).T = T(i).T*T(i-1).T;
    end


    for i = 1:size(T,2)
        [xlim(i,:),ylim(i,:)] = outputLimits(T(i),[1 ImSize(1)],[1 ImSize(2)]);
    end

    avgXLim = mean(xlim,2);
    [~,idx] = sort(avgXLim);
    centerIdx = floor((numel(T)+1)/2);
    centerImageIdx  = idx(centerIdx);
    
    Tinv = invert(T(centerImageIdx));

    for i = 1:numel(T)
        T(i).T = Tinv.T * T(i).T;
    end

    for i = 1:numel(T)
        [xlim(i,:), ylim(i,:)] = outputLimits(T(i), [1 ImSize(2)], [1 ImSize(1)]);
    end

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

    panoramaView = imref2d([height width],xLimits,yLimits);
    for i=1:n
        temp=Imc{i};
        temp(find(temp==0))=0.5;
        Imc{i}=temp;
    end
    wIm{1}=imwarp(Imc{1},T(1),'OutputView',panoramaView);
    t=wIm{1};
    for i=2:n
        wIm{i} = imwarp(Imc{i}, T(i),'OutputView',panoramaView);
        t=image_stitch(t,wIm{i});
        %t = multiband_blend(t,wIm{i});
    end
    %t = autoCrop(uint8(t));
    %imshow(t);
end