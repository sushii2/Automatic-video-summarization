clear;
alluserframes=[];
allusers = dir('F:\study material\Summer 18\CSE 408\final project\UserSummary\v52');
for b=3:7
    userno=allusers(b).name;
    allimages=dir(fullfile('F:\study material\Summer 18\CSE 408\final project\UserSummary\v52',userno));
    for c=3:numel(allimages)
        imagename=allimages(c).name;
        fnumber1=sscanf(imagename,'Frame%d.jpeg');
        alluserframes=[alluserframes,fnumber1];
    end
end

totalmatch=0;
allimages = dir('F:\study material\Summer 18\CSE 408\final project\Movie Frames from v52\Frame*.png');

for a=1:numel(alluserframes)
    fnumber1=alluserframes(a);
    for d=1:numel(allimages)
        namestring1=allimages(d).name;
        fnumber2=sscanf(namestring1,'Frame%d.png');
        if abs(fnumber1-fnumber2)<=200
            totalmatch=totalmatch+1;
            break;
        end
    end
end

accuracy=(totalmatch/numel(alluserframes))*100;
disp(accuracy);


