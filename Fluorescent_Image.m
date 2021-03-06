%% Camera Image Analysis
%developed June 2020
%Rachael Feord
%Ines Loureiro

%Code analyses MEA photos taken with the camera as well as the fluorescent images.
%PV neurons express tdTomato (red). It identifies PV cells and the electrodes
%% Read Camera Image
I = imread('IMG_3723.JPG');
  p = [50 50 900 1400]; %can change numbers to alter image size
set(0, 'DefaultFigurePosition', p) 
f = figure;
imagesc(I);

MB = msgbox('Click on six top row electrodes (left to right)');
  
for i = 1:6 % to select six electrodes
ROI = drawpoint;
TemplateElec(i,:) = ROI.Position; 
clear ROI
end

close Figure 1

for i=1:length(TemplateElec) - 1
    lengthx(i) = TemplateElec(i+1,1)-TemplateElec(i,1);
end  %calculates the length of x for all electrodes chosen
 
eleclength=mean(lengthx); %calculates mean of the length between elecs

Elec1= TemplateElec(1,:);
Elec1(1)= Elec1(1)- eleclength;

count= 0;
for w = 1:8  %w=width cooresponding to y coord           
    for l = 1:8 %l=length corresponding to x coord
        if (l==1 && w==1) || (l==8 && w==8) || (l==1 && w==8) || (l==8 && w==1) || (l==1 && w==4) 
            continue
        else
            count=count+1;
            ElecCoord(count,1)= Elec1(1)+ (w-1)*eleclength;
            ElecCoord(count,2)= Elec1(2)+ (l-1)*eleclength;
        end
    end
end

ElecCoord = ElecCoord';
%% Fluorescent Image
I = imread('IMG_3724.JPG');
Ired = I(:,:,1);
imagesc(Ired); % image with all red channels identified
imshow(I);
%MaxDist = 1/3 * eleclength
MaxDist = 1/11 * eleclength; % change to 35pixels of distance

[PVElecLoc, CtrPVCoords] = PVcellLocMEA(I, ElecCoord,MaxDist);
close Figure 1


