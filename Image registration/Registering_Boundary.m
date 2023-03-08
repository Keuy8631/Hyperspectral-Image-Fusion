% Registering One Gopro(1) image with NIR(368-6037)
% image(120:1504,138:2600) use Histeq
% part registering useing boundary
% Data path = 'F:\NIRSnapshotData\2020_9_18_12_17_17' NIR cut image size : 177x314 Gopro image size : 1520x2704
% Create time : 20201227
% Created by  : Bill
clc,clear,close all

% 環境設定
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion')
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion\Image registration\Image_Quality\3D')
addpath('C:\Users\EBILxCPSL_S3\Desktop\Bridge plan\Hyperspectral\Image Fusion\Image registration\Image_Quality\2D')
spath = ['D:\Bridge plan\20221221_bridge inspection\Hyperspectral\Detail_regression'];

if ~exist(spath,'dir')
    mkdir(spath);
end
if ~exist([spath '\pic_range_50'],'dir')
    mkdir([spath '\pic_range_50']);
end
if ~exist([spath '\pic_range_0'],'dir')
    mkdir([spath '\pic_range_0']);
end
if ~exist([spath '\picmat_range_50'],'dir')
    mkdir([spath '\picmat_range_50']);
end
if ~exist([spath '\picmat_range_0'],'dir')
    mkdir([spath '\picmat_range_0']);
end
if ~exist([spath '\tform'],'dir')
    mkdir([spath '\tform']);
end
load('NIRCamera_Calibration_Parameter.mat')
% Registering_Final_All 參數
load('F:\Mapping_Process\2020_9_18_12_17_17_ONE_V3\tform\tform_all.mat')
% ChackValue
load('F:\Mapping_Process\2020_9_18_12_17_17_ALL_V3\ALL_Band\index.mat')
times = Texport('F:\NIRSnapshotData\2020_9_18_12_17_17');
% 以下為全局對位的參數
VISTimeShift = 1/3;
NIRStart = 364; %366+1-3
band = 5;
tform = {};
start = 1;
stop = 2762;
f = figure('visible','off');
for ind = start:stop
%     tic
    VISimageNo = ind;
    [minV minD] = min(abs(times(:,4)-(ind*VISTimeShift+times(NIRStart,4))));
    NIRimageNo = minD;
    indAdd = index(ind,2);
    NIRNo = NIRimageNo-4+indAdd;
    % 可見光資料夾的路徑
    Goprofpfn = ['F:\gopro_Process\GH019464\image' num2str(VISimageNo) '.jpg'];
    Vopic = imread(Goprofpfn);
    Vimage = Vopic(160:1480,200:2548,:);
    % 高光譜資料夾的路徑
    NIRfpfn = ['F:\NIRSnapshotData\2020_9_18_12_17_17\image_' num2str(NIRNo) '.bin'];
    [Nopic fp] = NIRread(NIRfpfn,'file','bin');
    Npic = NIRband_V2(Nopic,1);
    piccut = NIRcut(Npic);
    Nimage_R = imresize(piccut{band,1},[size(Vimage,1),size(Vimage,2)]);
    Nimage = histeq(uint8(Nimage_R.*256./1024));
    Vimage_Gauss = imgaussfilt(Vimage(:,:,1),4);
    tform = tform_all{1,ind};
    Nimage_T = imwarp(Nimage,tform,'OutputView',imref2d(size(Vimage,[1,2])));
    invtform = invert(tform);
    Nimage_T_T = imwarp(Nimage_T,invtform,'OutputView',imref2d(size(Nimage_T)));
    Vimage_T_T = imwarp(Vimage,invtform,'OutputView',imref2d(size(Nimage_T)));
%     imshowpair(Vimage,Nimage_T,'ColorChannels','green-magenta')
%     imshowpair(Vimage_T_T,Nimage_T_T,'ColorChannels','green-magenta')
    H_cutNum = 8;
    V_cutNum = 4;
    imsize = [round(size(Nimage_T_T,1)/V_cutNum),round(size(Vimage_T_T,2)/H_cutNum)];
    tform_min = {};
%     tic
    for i = 1:H_cutNum
       for j = 1:V_cutNum
            c_cut = Nimage_T_T(round((j-1)/V_cutNum*size(Nimage_T_T,1))+1:round((j)/V_cutNum*size(Nimage_T_T,1)),round((i-1)/H_cutNum*size(Nimage_T_T,2))+1:round((i)/H_cutNum*size(Nimage_T_T,2)));
    %         figure(1)
    %         imshow(c_cut)
    %         pause()
            c_cut_c = histeq(c_cut);
    %         figure()
    %         imshow(c_cut_c)
            d_cut = Vimage_T_T(round((j-1)/V_cutNum*size(Vimage_T_T,1))+1:round((j)/V_cutNum*size(Vimage_T_T,1)),round((i-1)/H_cutNum*size(Vimage_T_T,2))+1:round((i)/H_cutNum*size(Vimage_T_T,2)));
    %         figure()
    %         imshow(d_cut)
            [optimizer, metric] = imregconfig('multimodal');
            optimizer.InitialRadius = 0.0001;
            optimizer.Epsilon = 1.5e-4;
            optimizer.GrowthFactor = 1.0001;
            optimizer.MaximumIterations = 200;
            tform_min{j,i} = imregtform(c_cut_c,d_cut,'affine',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',3);
            c_cut_plus = Nimage_T_T(round((j-1)/V_cutNum*size(Nimage_T_T,1))+1:round((j)/V_cutNum*size(Nimage_T_T,1)),round((i-1)/H_cutNum*size(Nimage_T_T,2))+1:round((i)/H_cutNum*size(Nimage_T_T,2)));
            c_cut_plus_c = histeq(c_cut_plus);
            c_cut_T = imwarp(c_cut_plus,tform_min{j,i},'OutputView',imref2d(size(d_cut)));
    %         figure()
    %         imshowpair(d_cut,c_cut_T,'ColorChannels','green-magenta');
    %         figure()
    %         imshowpair(d_cut,c_cut,'ColorChannels','green-magenta');
       end
    end
%     toc
%     tic
    N_after = [];
    image_range = 0;
    for i = 1:H_cutNum
       for j = 1:V_cutNum
           x_min = round((j-1)/V_cutNum*size(Nimage_T_T,1))-image_range + 1;
           x_min_range = image_range;
           if x_min<1
               x_min = 1;
               x_min_range = 0;
           end
           x_max = round((j)/V_cutNum*size(Nimage_T_T,1))+image_range;
           x_max_range = image_range;
           if x_max > size(Nimage_T_T,1)
               x_max = size(Nimage_T_T,1);
               x_max_range = 0;
           end
           y_min = round((i-1)/H_cutNum*size(Nimage_T_T,2))-image_range + 1;
           y_min_range = image_range;
           if y_min < 1
               y_min = 1;
               y_min_range = 0;
           end
           y_max = round((i)/H_cutNum*size(Nimage_T_T,2))+image_range;
           y_max_range = image_range;
           if y_max > size(Nimage_T_T,2)
               y_max = size(Nimage_T_T,2);
               y_max_range = 0;
           end
           d_cut = Vimage_T_T(x_min:x_max,y_min:y_max);
           c_cut = Nimage_T_T(x_min:x_max,y_min:y_max);
           c_cut_T = imwarp(c_cut,tform_min{j,i},'OutputView',imref2d(size(d_cut)));
    %        figure()
    %        imshowpair(d_cut,c_cut_T,'ColorChannels','green-magenta');
    %        pause()
           N_after(round((j-1)/V_cutNum*size(Nimage_T_T,1))+1:round((j)/V_cutNum*size(Nimage_T_T,1)),round((i-1)/H_cutNum*size(Nimage_T_T,2))+1:round((i)/H_cutNum*size(Nimage_T_T,2))) = c_cut_T(1+x_min_range:size(c_cut_T,1)-x_max_range,1+y_min_range:size(c_cut_T,2)-y_max_range);
       end
    end
%     toc
    imshowpair(Vimage_T_T,N_after,'ColorChannels','green-magenta');
    savename = [spath '\pic_range_0\No_' num2str(ind) '.jpg'];
    saveas(f,savename) 
    savename = [spath '\picmat_range_0\No_' num2str(ind) '_NIR.mat'];
    save(savename,'N_after','-v7.3')
%     tic
    N_after = [];
    % 如果覆蓋不夠大或不夠小，則調整此參數
    image_range = 50;
    for i = 1:H_cutNum
       for j = 1:V_cutNum
           x_min = round((j-1)/V_cutNum*size(Nimage_T_T,1))-image_range + 1;
           x_min_range = image_range;
           if x_min<1
               x_min = 1;
               x_min_range = 0;
           end
           x_max = round((j)/V_cutNum*size(Nimage_T_T,1))+image_range;
           x_max_range = image_range;
           if x_max > size(Nimage_T_T,1)
               x_max = size(Nimage_T_T,1);
               x_max_range = 0;
           end
           y_min = round((i-1)/H_cutNum*size(Nimage_T_T,2))-image_range + 1;
           y_min_range = image_range;
           if y_min < 1
               y_min = 1;
               y_min_range = 0;
           end
           y_max = round((i)/H_cutNum*size(Nimage_T_T,2))+image_range;
           y_max_range = image_range;
           if y_max > size(Nimage_T_T,2)
               y_max = size(Nimage_T_T,2);
               y_max_range = 0;
           end
           d_cut = Vimage_T_T(x_min:x_max,y_min:y_max);
           c_cut = Nimage_T_T(x_min:x_max,y_min:y_max);
           c_cut_T = imwarp(c_cut,tform_min{j,i},'OutputView',imref2d(size(d_cut)));
    %        figure()
    %        imshowpair(d_cut,c_cut_T,'ColorChannels','green-magenta');
    %        pause()
           N_after(round((j-1)/V_cutNum*size(Nimage_T_T,1))+1:round((j)/V_cutNum*size(Nimage_T_T,1)),round((i-1)/H_cutNum*size(Nimage_T_T,2))+1:round((i)/H_cutNum*size(Nimage_T_T,2))) = c_cut_T(1+x_min_range:size(c_cut_T,1)-x_max_range,1+y_min_range:size(c_cut_T,2)-y_max_range);
       end
    end
%     toc
%     figure()
    imshowpair(Vimage_T_T,N_after,'ColorChannels','green-magenta');
    savename = [spath '\pic_range_50\No_' num2str(ind) '.jpg'];
    saveas(f,savename) 
%     figure()
%     imshowpair(Vimage_T_T,Nimage_T_T,'ColorChannels','green-magenta');
%     toc
    savename = [spath '\picmat_range_50\No_' num2str(ind) '_NIR.mat'];
    save(savename,'N_after','-v7.3')
    savename = [spath '\tform\No_' num2str(ind) '.mat'];
    save(savename,'tform_min','-v7.3')
end

%% 橫的8塊，縱的4塊，共32塊(可調可不調)
H_cutNum = 8;
V_cutNum = 4;
imsize = [round(size(Nimage_T_T,1)/V_cutNum),round(size(Vimage_T_T,2)/H_cutNum)]
%%
tform_min = {};
for i = 1:H_cutNum
   for j = 1:V_cutNum
        c_cut = Nimage_T_T(round((j-1)/V_cutNum*size(Nimage_T_T,1))+1:round((j)/V_cutNum*size(Nimage_T_T,1)),round((i-1)/H_cutNum*size(Nimage_T_T,2))+1:round((i)/H_cutNum*size(Nimage_T_T,2)));
%         figure(1)
%         imshow(c_cut)
%         pause()
        c_cut_c = histeq(c_cut);
%         figure()
%         imshow(c_cut_c)
        d_cut = Vimage_T_T(round((j-1)/V_cutNum*size(Vimage_T_T,1))+1:round((j)/V_cutNum*size(Vimage_T_T,1)),round((i-1)/H_cutNum*size(Vimage_T_T,2))+1:round((i)/H_cutNum*size(Vimage_T_T,2)));
%         figure()
%         imshow(d_cut)
        [optimizer, metric] = imregconfig('multimodal');
        optimizer.InitialRadius = 0.0001;
        optimizer.Epsilon = 1.5e-4;
        optimizer.GrowthFactor = 1.0001;
        optimizer.MaximumIterations = 300;
        tform_min{j,i} = imregtform(c_cut_c,d_cut,'affine',optimizer,metric,'DisplayOptimization',false,'PyramidLevels',3);
        c_cut_plus = Nimage_T_T(round((j-1)/V_cutNum*size(Nimage_T_T,1))+1:round((j)/V_cutNum*size(Nimage_T_T,1)),round((i-1)/H_cutNum*size(Nimage_T_T,2))+1:round((i)/H_cutNum*size(Nimage_T_T,2)));
        c_cut_plus_c = histeq(c_cut_plus);
        c_cut_T = imwarp(c_cut_plus,tform_min{j,i},'OutputView',imref2d(size(d_cut)));
%         figure()
%         imshowpair(d_cut,c_cut_T,'ColorChannels','green-magenta');
%         figure()
%         imshowpair(d_cut,c_cut,'ColorChannels','green-magenta');
   end
end
%%
N_after = [];
image_range = 50;
for i = 1:H_cutNum
   for j = 1:V_cutNum
       x_min = round((j-1)/V_cutNum*size(Nimage_T_T,1))-image_range + 1;
       x_min_range = image_range;
       if x_min<1
           x_min = 1;
           x_min_range = 0;
       end
       x_max = round((j)/V_cutNum*size(Nimage_T_T,1))+image_range;
       x_max_range = image_range;
       if x_max > size(Nimage_T_T,1)
           x_max = size(Nimage_T_T,1);
           x_max_range = 0;
       end
       y_min = round((i-1)/H_cutNum*size(Nimage_T_T,2))-image_range + 1;
       y_min_range = image_range;
       if y_min < 1
           y_min = 1;
           y_min_range = 0;
       end
       y_max = round((i)/H_cutNum*size(Nimage_T_T,2))+image_range;
       y_max_range = image_range;
       if y_max > size(Nimage_T_T,2)
           y_max = size(Nimage_T_T,2);
           y_max_range = 0;
       end
       d_cut = Vimage_T_T(x_min:x_max,y_min:y_max);
       c_cut = Nimage_T_T(x_min:x_max,y_min:y_max);
       c_cut_T = imwarp(c_cut,tform_min{j,i},'OutputView',imref2d(size(d_cut)));
%        figure()
%        imshowpair(d_cut,c_cut_T,'ColorChannels','green-magenta');
%        pause()
       N_after(round((j-1)/V_cutNum*size(Nimage_T_T,1))+1:round((j)/V_cutNum*size(Nimage_T_T,1)),round((i-1)/H_cutNum*size(Nimage_T_T,2))+1:round((i)/H_cutNum*size(Nimage_T_T,2))) = c_cut_T(1+x_min_range:size(c_cut_T,1)-x_max_range,1+y_min_range:size(c_cut_T,2)-y_max_range);
   end
end
figure()
imshowpair(Vimage_T_T,N_after,'ColorChannels','green-magenta');
figure()
imshowpair(Vimage_T_T,Nimage_T_T,'ColorChannels','green-magenta');
