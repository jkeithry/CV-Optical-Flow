function MyKLT(S)
[imH, imW, seqSize ] = size(S);
sampleSize = 20;
wDim = 15;
[X, Y] = meshgrid(1:wDim,1:wDim);
halfWDim = floor(wDim/2);
boarderRegion = [imH - 10, imW - 10];
tau = 0.01;

%Detect keypoints in initial frame
initFrame = S(:,:,1);
[featRow, featCol] = MyHarrisCorners(initFrame);
numCorners = size(featRow,1);
rSample = randsample(numCorners,sampleSize);
rSample = [featRow(rSample), featCol(rSample)];%20 random points

%track samples
thisFrame = initFrame;

for iFrame = 2:seqSize
    
    nxtFrame = S(:,:,iFrame);    
    for jFeat = 1:sampleSize

        featLoc = [rSample(jFeat,1), rSample(jFeat,2)];
        %15x15 window size
        thisWindow = thisFrame(featLoc(1)-halfWDim:featLoc(1)+halfWDim,...
                featLoc(1,2)-halfWDim:featLoc(1,2)+halfWDim); 
        nxtWindow = nxtFrame(featLoc(1)-halfWDim:featLoc(1)+halfWDim,...
                 featLoc(2)-halfWDim:featLoc(2)+halfWDim);
        %compute u v for each point
        [u,v] = MyFlow(thisWindow,nxtWindow,5,tau);
        %shitf window
        shiftWindow = interp2(X,Y,thisWindow,X+u,Y+v,'nearest',0);        
        
        if intpY > boarderRegion(1) || intpX > boarderRegion(2)
            %discard feature
            discardedFeat = cat(discardedFeat,jFeat);
        end
    end    

end
%disp discarded
imshow(initFrame,[])
hold on;
plot(rSample, rSample, 'ro', 'MarkerSize', 5);

end
