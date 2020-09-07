%% PLOTS

p = [50 50 700 500];
set(0, 'DefaultFigurePosition', p)
x = ElecCoord(2,:);
y = ElecCoord(1,:);
c = linspace(1,10,length(x));
s = scatter(x,y,'k','o','LineWidth',1.5);
s.SizeData= 60;
xlim([0 2900])
ylim([500 3200])

hold on 
a =scatter(CtrPVCoords(:,2),CtrPVCoords(:,1),'r','filled')
% view(90, 90)
a.SizeData = 50

PVElecCoord = ElecCoord(:,PVElecLoc);
scatter(PVElecCoord(2,:),PVElecCoord(1,:),'filled','MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)

hold on
PVElecCoord = ElecCoord(:,PVElecLoc);
scatter(PVElecCoord(2,:),PVElecCoord(1,:),'filled','MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)

