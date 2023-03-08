% Registering ALL NIR(366-6037) image with Gopro(1-2672)
% image(120:1504,138:2600) use ML and GaussianBp Score
% Time:2.5hr
% Data path = 'F:\NIRSnapshotData\2020_9_18_12_17_17' NIR cut image size : 177x314 Gopro image size : 1520x2704
% Create time : 20210222
% Created by  : Bill
clc,clear,close all
% 環境設定
% addpath('D:\WEI\wei\matlab')
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion')
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion\Image registration\Image_Quality\3D')
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion\Image registration\Image_Quality\2D')
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion\Image registration')
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion\NIRsnapshot')
load('NIRCamera_Calibration_Parameter.mat')
tform = affine2d;
DATA = {};

%Hyperspectral的資料位置
% times = Texport('D:\Bridge plan\20211221_bridge inspection\Hypespectral\2021_12_17_15_34_20');
% times = Texport('D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\Hyper\2022_12_21_16_30_18');
% times = Texport('D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\Hyper\2022_12_21_16_41_20');
% times = Texport('D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\Hyper\2022_12_21_16_52_12');
%選較好的Band
Band = 6;
% spath = ['D:\Bridge plan\20211221_bridge inspection\Hypespectral\0\Band_' num2str(Band)];
% spath = ['D:\Bridge plan\20221221_bridge inspection\Hyperspectral\1\Band_' num2str(Band)];
spath = ['D:\Bridge plan\20221221_bridge inspection\Hyperspectral\2\Band_' num2str(Band)];
% spath = ['D:\Bridge plan\20221221_bridge inspection\Hyperspectral\3\Band_' num2str(Band)];
if ~exist(spath,'dir')
    mkdir(spath);
end
if ~exist([spath '\tform'],'dir')
    mkdir([spath '\tform']);
end
tic
% cnt = 8; 
%RGB的資料位置
% path = dir('D:\Bridge plan\20211221_bridge inspection\20211217_plan\Hyperspectral\Drone_GoPro\GH010462_frames')
% path = dir('D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\GH010527_frames')
path = dir('D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\GH010529_frames')
% path = dir('D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\GH010530_frames')
% NIRpath = dir('D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\Hyper\2022_12_21_16_30_18')
%cnt要先看path裡面RGB照片的順序(第一張:最後一張)
for cnt = 45:491/4
    start = 1+2*(cnt-1)
    %算核心數，例如:從第一張開始(使用6核)，start+5
    stop = start+3;
    %改GoPro影像切的時間 20221221都是0.8
    VISTimeShift = 0.8;
    %NIR對到的檔名(第一張)
    NIRStart = 170; %366+1-3
    parfor ind = start:stop
        tic
        VISimageNo = ind;
        [minV minD] = min(abs(times(:,4)-(ind*VISTimeShift+times(NIRStart,4))));
        % NIRimageNo = 317
        NIRimageNo = minD;
        for i = 1:11
            if(NIRimageNo-4+i>0)
                NIRNo = NIRimageNo-4+i;
                disp(i)
                Goprofpfn = [path(cnt).folder '\' path(cnt).name];
                Vopic = imread(Goprofpfn);
                Vimage = Vopic(160:1480,200:2548,:);
%                 figure()
%                 imshow(Vimage);
                % 快照bin檔的位置
                NIRfpfn = ['D:\Bridge plan\20221221_bridge inspection\Video\GoPro_hyper\Hyper\2022_12_21_16_52_12\image_' num2str(NIRNo) '.bin'];
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
                        tform = imregtform(Nimage,Vimage_Gauss,'affine',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',4);
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
