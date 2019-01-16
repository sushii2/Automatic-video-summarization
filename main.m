clear;  
folder = 'F:\study material\Summer 18\CSE 408\final project\database';
movieFullFileName = fullfile(folder, 'v21.mpg');

	videoObject = VideoReader(movieFullFileName);
	% Determine how many frames there are.
	%numberOfFrames = videoObject.NumberOfFrames;
    duration=floor(videoObject.Duration);
    framerate=videoObject.FrameRate;
    numberofframes=duration*framerate;
    numberOfFrames=floor(numberofframes);
	avidHeight = videoObject.Height;
	vidWidth = videoObject.Width;
	
	numberOfFramesWritten = 0;
	
	
		writeToDisk = true;
		[folder, baseFileName, extentions] = fileparts(movieFullFileName);
		folder = pwd;   % Make it a subfolder of the folder where this m-file lives.
		outputFolder = sprintf('%s/Movie Frames from %s', folder, baseFileName);
		if ~exist(outputFolder, 'dir')
			mkdir(outputFolder);
        end
    final=[];
    sampledframes=[];
    summaryframes=[];
    startmatrix=[];
    diffs=[];
    samplingrate=uint64(numberOfFrames/100);
    for frame = 1 : samplingrate: numberOfFrames-samplingrate
        sum=0;
		thisFrame1 = read(videoObject, frame);
        if frame+samplingrate > numberOfFrames
            blah=1;
        end
        
        thisFrame2 = read(videoObject, frame+samplingrate);
        thisFrame1=rgb2hsv(thisFrame1);
        thisFrame2=rgb2hsv(thisFrame2);
        diffframe=thisFrame1-thisFrame2;
        for i=1:avidHeight
            for j=1:vidWidth
                for k=1:3
                    sum=sum+diffframe(i,j,k).^2;
                end
            end
        end
        mag=sqrt(sum);

        diffs=[diffs,mag];
    end
    plot(diffs);
        
threshold=((25*min(diffs))+(75*max(diffs)))/100;
K=1;
for i=1:numel(diffs)
    if diffs(i)>threshold
        K=K+1;
    end
end
	for frame = 1 : samplingrate : numberOfFrames
		
        sampledframes=[sampledframes,frame];
		thisFrame = read(videoObject, frame);
        thisFrameinHSV=rgb2hsv(thisFrame);
        
        h=thisFrameinHSV(:,:,1);
        s=thisFrameinHSV(:,:,2);
        v=thisFrameinHSV(:,:,3);
        [countsh,binLocations]=imhist(h);
         [countss,binLocations]=imhist(s);
          [countsv,binLocations]=imhist(v);
          countshsv=[countsh;countss;countsv];
        featvect=countshsv';

        
        final=[final;featvect];
         figure(1);

 		image(thisFrame);

		if writeToDisk
			progressIndication = sprintf('Wrote frame %4d of %d.', frame, numberOfFrames);
		else
			progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
		end
		disp(progressIndication);
		
		numberOfFramesWritten = numberOfFramesWritten + 1;
	end
	
	
	
	
        
        if K>numberOfFramesWritten
            K=numberOfFramesWritten;
        end
%         gap=uint64(numberOfFramesWritten/K);
%         startmatrix=[startmatrix;final(2,:)];
%         old=1;
%         for i=1:K-2
%             new=old+gap;
%             if new>numberOfFramesWritten
%               new=numberOfFramesWritten;
%             end
%              startmatrix=[startmatrix;final(new,:)];
%              old=new;
%         end
%         startmatrix=[startmatrix;final(numberOfFramesWritten,:)];
    [idx,C,sumd,D]=kmeans(final,K,'Distance','cityblock','Replicates',K+1);
    
    %[idx,C,sumd,D]=kmeans(final,K,'Distance','cityblock','start',startmatrix);
	
	for i=1:K
        [~,index]=min(D(:,i));
        summaryframes=[summaryframes,sampledframes(index)];
    end
    

        for i=1:K
       			outputBaseFileName = sprintf('Frame%d.png', summaryframes(i));	
                outputFullFileName = fullfile(outputFolder, outputBaseFileName);
                framenumber=summaryframes(i);
                thisFrame = read(videoObject, summaryframes(i));
                %frameWithText = getframe(thisFrame);
                imwrite(thisFrame, outputFullFileName, 'png');

        end
		


		


