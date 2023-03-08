% export ContextCapture BlocksExchange XML format to TYPE1 Format
% Create time : 20200207
% Created by  : Bill
clc,clear,close all
%%
tic
% addpath 'C:\Users\EBILxCPSL_S1\Documents\MATLAB\Examples\R2021a\matlab\ReadXMLFileIntoMATLABStructureArrayExample'
sampleXMLfile = uigetfile('.xml');
disp(['Loading ' sampleXMLfile ' ...']);
% XML檔的路徑
mlStruct = parseXML(['C:\Users\EBILxCPSL_S1\Documents\MATLAB\20210112_Liouguei\strong_tree1\' sampleXMLfile]);
disp('Loading Done')
toc
%%
tic
disp(['Export 3D point XML ...']);
NotUseNo = 0;
Photo = [];
Point = [];
index_Block = find(strcmp({mlStruct.Children.Name}, 'Block')==1);
index_Photogroups = find(strcmp({mlStruct.Children(index_Block).Children.Name},'Photogroups')==1);
index_Photogroup = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children.Name},'Photogroup')==1);
index_Photo = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children.Name},'Photo')==1);
for i = 1:size(index_Photo,2)
    index_Id = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children.Name},'Id')==1);
    index_ImagePath = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children.Name},'ImagePath')==1);
    Photo.Id(i,1) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Id).Children.Data);
    Photo.ImagePath{i,1} = mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_ImagePath).Children.Data;
    index_Pose = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children.Name},'Pose')==1);
    if isempty(index_Pose)
        NotUseNo = NotUseNo + 1;
        Photo.NotUse(NotUseNo) = Photo.Id(i,1);
    else
        index_Rotation = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children.Name},'Rotation')==1);
        index_Rotation_M00 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_00')==1);
        index_Rotation_M01 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_01')==1);
        index_Rotation_M02 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_02')==1);
        index_Rotation_M10 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_10')==1);
        index_Rotation_M11 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_11')==1);
        index_Rotation_M12 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_12')==1);
        index_Rotation_M20 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_20')==1);
        index_Rotation_M21 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_21')==1);
        index_Rotation_M22 = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children.Name},'M_22')==1);
        index_Center = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children.Name},'Center')==1);
        index_Center_x = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Center).Children.Name},'x')==1);
        index_Center_y = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Center).Children.Name},'y')==1);
        index_Center_z = find(strcmp({mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Center).Children.Name},'z')==1);
        Photo.Rotate(1,1,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M00).Children.Data);
        Photo.Rotate(1,2,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M01).Children.Data);
        Photo.Rotate(1,3,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M02).Children.Data);
        Photo.Rotate(2,1,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M10).Children.Data);
        Photo.Rotate(2,2,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M11).Children.Data);
        Photo.Rotate(2,3,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M12).Children.Data);
        Photo.Rotate(3,1,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M20).Children.Data);
        Photo.Rotate(3,2,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M21).Children.Data);
        Photo.Rotate(3,3,i) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Rotation).Children(index_Rotation_M22).Children.Data);
        Photo.Center(i,1) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Center).Children(index_Center_x).Children.Data);
        Photo.Center(i,2) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Center).Children(index_Center_y).Children.Data);
        Photo.Center(i,3) = str2num(mlStruct.Children(index_Block).Children(index_Photogroups).Children(index_Photogroup).Children(index_Photo(i)).Children(index_Pose).Children(index_Center).Children(index_Center_z).Children.Data);
    end
end

index_TiePoints = find(strcmp({mlStruct.Children(index_Block).Children.Name},'TiePoints')==1);
index_TiePoint = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children.Name},'TiePoint')==1);
for j = 1:size(index_TiePoint,2)
    index_Position = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children.Name},'Position')==1);
    index_PositionX = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Position).Children.Name},'x')==1);
    index_PositionY = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Position).Children.Name},'y')==1);
    index_PositionZ = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Position).Children.Name},'z')==1);
    Point.Position(j,1) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Position).Children(index_PositionX).Children.Data);
    Point.Position(j,2) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Position).Children(index_PositionY).Children.Data);
    Point.Position(j,3) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Position).Children(index_PositionZ).Children.Data);
    
    index_Color = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children.Name},'Color')==1);
    index_ColorR = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Color).Children.Name},'Red')==1);
    index_ColorG = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Color).Children.Name},'Green')==1);
    index_ColorB = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Color).Children.Name},'Blue')==1);
    Point.Color(j,1) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Color).Children(index_ColorR).Children.Data);
    Point.Color(j,2) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Color).Children(index_ColorG).Children.Data);
    Point.Color(j,3) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Color).Children(index_ColorB).Children.Data);
    
    index_Measurement = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children.Name},'Measurement')==1);
    for k = 1:size(index_Measurement,2)
        index_PhotoId = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Measurement(k)).Children.Name},'PhotoId')==1);
        index_PhotoX = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Measurement(k)).Children.Name},'x')==1);
        index_PhotoY = find(strcmp({mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Measurement(k)).Children.Name},'y')==1);
        Point.Photo(k,1,j) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Measurement(k)).Children(index_PhotoId).Children.Data);
        Point.Photo(k,2,j) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Measurement(k)).Children(index_PhotoX).Children.Data);
        Point.Photo(k,3,j) = str2num(mlStruct.Children(index_Block).Children(index_TiePoints).Children(index_TiePoint(j)).Children(index_Measurement(k)).Children(index_PhotoY).Children.Data);
    end
end
toc
%%
disp(['Save 3D point Data Cube ...']);
DataCube.Information.Source = sampleXMLfile;
DataCube.Photo = Photo;
DataCube.Point = Point;
Savename = sampleXMLfile(1:strfind(sampleXMLfile,'.')-1);
% 儲存檔案的路徑
Savepath = ['C:\Users\EBILxCPSL_S1\Documents\MATLAB\20210112_Liouguei\strong_tree1\' Savename '.mat'];
save(Savepath,'DataCube','-v7.3')
