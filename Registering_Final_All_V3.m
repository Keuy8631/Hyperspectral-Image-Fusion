% Registering ALL NIR(366-6037) image with Gopro(1-2672)
% image(120:1504,138:2600) use ML and GaussianBp Score
% Time:2.5hr
% Data path = 'F:\NIRSnapshotData\2020_9_18_12_17_17' NIR cut image size : 177x314 Gopro image size : 1520x2704
% Create time : 20210222
% Created by  : Bill
clc,clear,close all
%addpath('D:\WEI\wei\matlab')
%addpath('D:\WEI\wei\matlab\影像對位\Image_Quality\3D')
%addpath('D:\WEI\wei\matlab\影像對位\Image_Quality\2D')
load('NIRCamera_Calibration_Parameter.mat')
VISFolderInfo = dir('E:\lab_data\20210112_Liouguei\strong_tree2\GH010260_frames')
VISFolderInfo([VISFolderInfo.isdir]) = [] %get rid of the folders with the name of '.' or '..'
delete(gcp('nocreate'))  %Delete your current parallel pool if you still have one.
tform = affine2d;
DATA = {};
times = Texport('E:\lab_data\20210112_Liouguei\strong_tree2\2021_1_12_13_7_26');
Band = 5; 
spath = ['E:\lab_data\20210112_Liouguei\strong_tree2\2021_1_12_13_7_26_ALL_V3\Band_' num2str(Band)];
if ~exist(spath,'dir')
    mkdir(spath);
end
if ~exist([spath '\tform'],'dir')
    mkdir([spath '\tform']);
end
tic
% cnt = /4; number of cpu cores
for cnt = 1:1020/4 %1200-54=1146 % cnt = 1:2672/4
    start = 1+4*(cnt-1)
    stop = start+3;
    VISTimeShift = 1/3;
    NIRStart = 73; %366+1-3
    parfor (ind = start:stop,4)  
        tic
        VISimageNo = ind;
        [minV minD] = min(abs(times(:,4)-(ind*VISTimeShift+times(NIRStart,4))));
        NIRimageNo = minD; 
        for i = 1:11
            if(NIRimageNo-4+i>0)
                NIRNo = NIRimageNo-4+i;
                disp([i,NIRNo])
                Goprofpfn = [VISFolderInfo(cnt).folder '\' VISFolderInfo(cnt).name];
                Vopic = imread(Goprofpfn);
                Vimage = Vopic(160:1480,200:2548,:);
%                 figure()
%                 imshow(Vimage);
                NIRfpfn = ['E:\lab_data\20210112_Liouguei\strong_tree2\2021_1_12_13_7_26\image_' num2str(NIRNo) '.bin'];
                [Nopic fp] = NIRread(NIRfpfn,'file','bin');
                Npic = NIRband_V2(Nopic,1);
                piccut = NIRcut(Npic);
                for j = Band
                    Nimage_R = imresize(piccut{j,1},[size(Vimage,1),size(Vimage,2)]);
                    Nimage = uint8(Nimage_R.*255./1023);
                    Nimage_Heq = histeq(Nimage);
%                     figure()
%                     imshow(Nimage_R,[]);
%                     figure()
%                     imshow(Nimage);
                    figure()
                    imshow(Nimage_Heq);
                    for k = 1
                        Vimage_Gauss = imgaussfilt(Vimage(:,:,k),4);
                        [optimizer,metric] = imregconfig('multimodal');
                        optimizer.InitialRadius = 0.0001;
                        optimizer.Epsilon = 1.5e-4;
                        optimizer.GrowthFactor = 1.0001;
                        optimizer.MaximumIterations = 400;
                        tform = imregtform(Nimage,Vimage(:,:,k),'affine',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',4);
                        DATA{ind,i}(j,k) = tform;
                    end
                end
            end
        end
        toc
    end
    saveDataname = [spath '\tform\Data' num2str(start) '_' num2str(stop) '.mat'];
    save(saveDataname,'DATA');
end
toc
