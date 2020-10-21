function [PVeElecLoc, CtrPVCoords] = PVcellLocMEA(image, coordinates,MaxDist, mFileName)

% This function identifies PV cells and their location from 3D RGB image
% (z-stack). A green fluorescent dye labels all cells and PV neurons 
% express tdTomato (red) 

% author RCFeord, June 2020

% Inputs:
%   image: RGB image (classuint8)
%   CellID: vector of ones, length of identified cells in image
%   coordinates: coordinates for all identified cells

% Outputs:
%   CellID: modified input vector where 2 denotes PV cell identity

% coordinates = ROI.Coords;
% X = Image3D;

X = image;

%% plot image with PV cells

p = [50 50 1400 300];
set(0, 'DefaultFigurePosition', p)
F1 = figure;
subplot(1,3,1)
imagesc(X(:,:,1:3));
title('RGB image')
set(gca,'ytick',[])
set(gca,'xtick',[])

subplot(1,3,2)
imagesc(X(:,:,1));
title('Red channel only')
set(gca,'ytick',[])
set(gca,'xtick',[])


%% locate PV cells

X2 = X(:,:,1);
X3 = zeros(size(X2));
X3(X2>220) = 1; % pick threshold here for RED channel. max 255
X4 = logical(X3);
BW =  bwareafilt(X4,[100 30000]); % increasing first numb = less small regions picking up, second numb = max pixels

subplot(1,3,3)
imagesc(BW);
title('PV cell location')
set(gca,'ytick',[])
set(gca,'xtick',[])

%% save figure

if exist('mFileName','var')
    saveas(F1,strcat(mFileName,'PVcellIdentification.fig'));
    close(F1)
end

%% find cell numbers corresponding to PV cell location

% find coordinates of identified PV cells
CtrPVs = regionprops(BW,'centroid');
CtrPV = [];
for k = 1:length(CtrPVs)
    CtrPV(k,:) = CtrPVs(k).Centroid;
end

% match them up to the coordinates of electrodes in the network
PVeElecLoc = [];
CtrPVCoords = nan(size(CtrPV));
for i = 1:length(CtrPV)
    Xposs = find(abs(coordinates(1,:)-CtrPV(i,1))<MaxDist);
    Yposs = find(abs(coordinates(2,:)-CtrPV(i,2))<MaxDist);
    if ~isempty(Xposs) && ~isempty(Yposs)
        val = intersect(Xposs,Yposs);
        if length(val)>1
            for t = 1:length(val)
                dis(t) = abs(coordinates(1,val(t))-CtrPV(i,1))+abs(coordinates(2,val(t))-CtrPV(i,2));
            end
            Prox = dis==min(dis);
            PVeElecLoc = [PVeElecLoc (val(Prox))];
        else
            PVeElecLoc = [PVeElecLoc (val)];
        end
        clear val dis
        CtrPVCoords(i,:) = CtrPV(i,:);
    end
end
% CtrPVCoords(isnan(CtrPVCoords)) = [];
CtrPVCoords = rmmissing(CtrPVCoords);

end