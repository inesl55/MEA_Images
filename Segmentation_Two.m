%% SEGMENTATION 2.0
%developed July 2020
%Ines Loureiro
%% Read Image
I = imread('MPT200115_1C_DIV28.jpg');
imshow(I);

MB = msgbox('Click on six top row electrodes (left to right)');

  
for i = 1:6 % to select six electrodes
ROI = drawpoint;
TemplateElec(i,:) = ROI.Position; 
clear ROI
end

for i=1:length(TemplateElec) - 1
    lengthx(i) = TemplateElec(i+1,1)-TemplateElec(i,1);
end  %calculates the length of x for all electrodes chosen
 
eleclength=mean(lengthx); %calculates mean of the length between elecs

Elec1= TemplateElec(1,:);
Elec1(1)= Elec1(1)- eleclength;

count= 0;
for w = 1:8  %w=width cooresponding to y coord           
    for l = 1:8 %l=length corresponding to x coord
        if (l==1 && w==1) || (l==8 && w==8) || (l==1 && w==8) || (l==8 && w==1) || (l==5 && w==1) 
            continue
        else
            count=count+1;
            ElecCoord(count,1)= Elec1(1)+ (w-1)*eleclength;
            ElecCoord(count,2)= Elec1(2)+ (l-1)*eleclength;
        end
    end
end

ElecCoord = ElecCoord';
%  
% I = imread('MPT200115_1C_DIV28.jpg');
% imshow(I)
%% Convert to greyscale processing 
Igray = rgb2gray(I);
imshow(Igray);

%% Problem: illumination doesnt allow for easy segmentation
level = 0.5;
Ithresh = im2bw(Igray, level);
imshowpair(I, Ithresh, 'montage');

%% Complement Image and Fill in Holes
Icomp = imcomplement(Ithresh);
Ifilled= imfill(Icomp,'holes');
figure, imshow(Ifilled);

% close Figure 1

%% Fill in Electrodes
se = strel('disk', 20); %change numb after disk -> smaller see more, larger numb more strigent
Iopenned = imopen(Ifilled,se);
figure, imshowpair(Iopenned, I);
imshow(Iopenned);

%% Extract Features
Iregion = regionprops(Iopenned, 'centroid');
[labeled,numObjects]= bwlabel(Iopenned, 4);
stats = regionprops(labeled,'Eccentricity', 'Area', 'BoundingBox');
areas = [stats.Area];  
eccentricities = [stats.Eccentricity];
BoundingBox = [stats.BoundingBox];
for i = 1:length(areas)
    BoundBox(i,:) = BoundingBox (1 + (i * 4 -4): i*4);
end
clear BoundingBox

%% Use feature analysis to count cells
idxOfCells = find(eccentricities);
statsDefects = stats(idxOfCells);

figure, imshow(I);
hold on;
for idx = 1 : length(idxOfCells)
    h = rectangle('Position',statsDefects(idx).BoundingBox)
    set(h,'EdgeColor',[0.75 0 0]);
    hold on;
end

if idx > 10
    title(['There are',  num2str(numObjects),  'objects in image']);
end 
hold off;
     
%% Label Elecs

eleclabel = {'12','13','14','16','17','21','22','23','24','25','26','27','28','31','32','33','34','35','36','37','38','41','42','43','44','45','46','47','48','51','52','53','54','55','56','57','58','61','62','63','64','65','66','67','68','71','72','73','74','75','76','77','78','82','83','84','85','86','87'};


for i= 1:length(eleclabel)
    text(ElecCoord(1,i),ElecCoord(2,i),cell2mat(eleclabel(i)),'Color','w','FontSize',10,'HorizontalAlignment', 'left', 'FontWeight','bold');
end

% [0.3010 0.7450 0.9330] blue color

%% Numb of Objects in Image

% [centersDark, radiiDark] = imfindcircles(I,[7 12],'ObjectPolarity','dark', 'Sensitivity',0.92); % between 7-12 works well on electrodes    
% size(centersDark)


centersDark = [56,2]; 
centersDark(:,2) = [];
numObjects = numObjects - centersDark;
% turning an array into single number





