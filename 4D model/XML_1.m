% export ContextCapture BlocksExchange XML TYPE2 Format format to TYPE2 Format
% Set Region of interest
% Create time : 20200219
% Created by  : Bill
clc,clear,close all
%%
DataCubepath = ['D:\WEI\wei\matlab\3D_XML_analyze\Data\TYPE1'];
DataCubename = uigetfile(DataCubepath);
DataCubefpfn = [DataCubepath '\' DataCubename];
load(DataCubefpfn);
%% boundary check ContextCapter切範圍的值
xMax = 0.285595;
xmin = -0.246107;
yMax = 0.372402;
ymin = -0.172760;
zMax = -0.153946;
zmin = -0.658973;
check = zeros(size(DataCube.Point.Position,1),1);
for i = 1:size(DataCube.Point.Position,1)
   x = DataCube.Point.Position(i,1);
   y = DataCube.Point.Position(i,2);
   z = DataCube.Point.Position(i,3);
   if (x>xmin && x<xMax && y>ymin && y<yMax && z>zmin && z<zMax)
       check(i,1) = 1;
   end
end
point_index = find(check);
%%
DataCube1 = DataCube;
DataCube2.Information.Source = DataCubefpfn;
DataCube2.Point.PointIndex = point_index;
DataCube2.Point.Position = DataCube1.Point.Position(point_index,:);
DataCube2.Point.Color = DataCube1.Point.Color(point_index,:);
DataCube2.Point.Photo = DataCube1.Point.Photo(:,:,point_index);
check_photo = ones(size(DataCube1.Photo.Id,1),1);
check_photo(DataCube1.Photo.NotUse+1') = 0;
photo_index = find(check_photo);
DataCube2.Photo.Rotate = DataCube1.Photo.Rotate(:,:,photo_index);
DataCube2.Photo.ImagePath = DataCube1.Photo.ImagePath(photo_index,:);
DataCube2.Photo.Id = DataCube1.Photo.Id(photo_index,:);
DataCube2.Photo.Center = DataCube1.Photo.Center(photo_index,:);
figure()
scatter3(DataCube2.Point.Position(:,1),DataCube2.Point.Position(:,2),DataCube2.Point.Position(:,3),[],DataCube2.Point.Color(:,:),'s')
hold on
scatter3(DataCube2.Point.Position(1,1),DataCube2.Point.Position(1,2),DataCube2.Point.Position(1,3),[],'r','+')
%%
disp(['Save 3D point Type2 Data Cube ...']);
DataCube = DataCube2;
Savename = [DataCubename(1:strfind(DataCubename,'.')-1) '_' num2str(xMax) '_' num2str(xmin) '_' num2str(yMax) '_' num2str(ymin) '_' num2str(zMax) '_' num2str(zmin)]; 
Savepath = ['D:\WEI\wei\matlab\3D_XML_analyze\Data\TYPE2\' Savename '.mat'];
save(Savepath,'DataCube')
